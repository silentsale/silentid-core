import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_spacing.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryPurple = Color(0xFF5A3EB8);
  static const Color darkModePurple = Color(0xFF462F8F);
  static const Color softLilac = Color(0xFFE8E2FF);
  static const Color deepBlack = Color(0xFF0A0A0A);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color neutralGray900 = Color(0xFF111111);
  static const Color neutralGray700 = Color(0xFF4C4C4C);
  static const Color neutralGray300 = Color(0xFFDADADA);
  static const Color successGreen = Color(0xFF1FBF71);
  static const Color warningAmber = Color(0xFFFFC043);
  static const Color dangerRed = Color(0xFFD04C4C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryPurple,
        secondary: darkModePurple,
        surface: pureWhite,
        error: dangerRed,
        onPrimary: pureWhite,
        onSurface: deepBlack,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: pureWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: pureWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: deepBlack),
        titleTextStyle: GoogleFonts.inter(
          color: deepBlack,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: pureWhite,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonRadius,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.buttonRadius,
          ),
          side: const BorderSide(
            color: primaryPurple,
            width: 1.5,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.inputRadius,
          borderSide: const BorderSide(color: neutralGray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputRadius,
          borderSide: const BorderSide(color: neutralGray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputRadius,
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputRadius,
          borderSide: const BorderSide(color: dangerRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.inputRadius,
          borderSide: const BorderSide(color: dangerRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: neutralGray700,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.inter(
          color: neutralGray700,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.inter(
          color: dangerRed,
          fontSize: 12,
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardRadius,
        ),
        elevation: 0,
        color: pureWhite,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.sheetTopRadius,
        ),
        backgroundColor: pureWhite,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.modalRadius,
        ),
        backgroundColor: pureWhite,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryPurple,
        secondary: darkModePurple,
        surface: neutralGray900,
        error: dangerRed,
        onPrimary: pureWhite,
        onSurface: pureWhite,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      scaffoldBackgroundColor: neutralGray900,
      appBarTheme: AppBarTheme(
        backgroundColor: neutralGray900,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: pureWhite),
        titleTextStyle: GoogleFonts.inter(
          color: pureWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardRadius,
        ),
        elevation: 0,
        color: neutralGray900,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.sheetTopRadius,
        ),
        backgroundColor: neutralGray900,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.modalRadius,
        ),
        backgroundColor: neutralGray900,
      ),
    );
  }
}
