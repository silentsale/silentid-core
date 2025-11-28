import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  final _storage = StorageService();

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.apiBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add request interceptor to include auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 unauthorized - attempt token refresh
          if (error.response?.statusCode == 401) {
            try {
              final refreshToken = await _storage.getRefreshToken();
              if (refreshToken != null) {
                // Attempt to refresh token
                final response = await _dio.post(
                  ApiConstants.refresh,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['accessToken'];
                  final newRefreshToken = response.data['refreshToken'];

                  await _storage.saveAccessToken(newAccessToken);
                  await _storage.saveRefreshToken(newRefreshToken);

                  // Retry original request with new token
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  return handler.resolve(await _dio.fetch(error.requestOptions));
                }
              }
            } catch (e) {
              // Refresh failed, clear auth data
              await _storage.clearAuthData();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // GET request with retry logic
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    return await _retryableRequest(
      () => _dio.get(endpoint, queryParameters: queryParameters),
      maxRetries: maxRetries,
    );
  }

  // POST request with retry logic
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    return await _retryableRequest(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      ),
      maxRetries: maxRetries,
    );
  }

  // PATCH request
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Multipart upload request (for file uploads)
  Future<Response> uploadMultipart(
    String endpoint, {
    required FormData formData,
    int maxRetries = 3,
  }) async {
    return await _retryableRequest(
      () => _dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      ),
      maxRetries: maxRetries,
    );
  }

  // Retry logic for network requests
  Future<Response> _retryableRequest(
    Future<Response> Function() request, {
    int maxRetries = 3,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await request();
      } on DioException catch (e) {
        attempts++;

        if (attempts >= maxRetries) {
          throw _handleError(e);
        }

        // Only retry on network errors
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.unknown) {
          await Future.delayed(Duration(seconds: attempts));
          continue;
        }

        throw _handleError(e);
      }
    }

    throw Exception('Max retries exceeded');
  }

  // Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ??
                       error.response?.data?['error'] ??
                       'An error occurred';
        return Exception('$message (Error $statusCode)');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return Exception('No internet connection');
        }
        return Exception('An unexpected error occurred');
      default:
        return Exception('Network error occurred');
    }
  }
}
