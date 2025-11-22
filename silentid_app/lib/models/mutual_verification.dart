class MutualVerification {
  final String id;
  final String userAId;
  final String userBId;
  final String item;
  final double amount;
  final String roleA;
  final String roleB;
  final DateTime date;
  final String status;
  final String? evidenceId;
  final bool fraudFlag;
  final DateTime createdAt;

  // Display properties
  final String? otherUserName;
  final String? otherUserUsername;

  MutualVerification({
    required this.id,
    required this.userAId,
    required this.userBId,
    required this.item,
    required this.amount,
    required this.roleA,
    required this.roleB,
    required this.date,
    required this.status,
    this.evidenceId,
    required this.fraudFlag,
    required this.createdAt,
    this.otherUserName,
    this.otherUserUsername,
  });

  factory MutualVerification.fromJson(Map<String, dynamic> json) {
    return MutualVerification(
      id: json['id'] as String,
      userAId: json['userAId'] as String,
      userBId: json['userBId'] as String,
      item: json['item'] as String,
      amount: (json['amount'] as num).toDouble(),
      roleA: json['roleA'] as String,
      roleB: json['roleB'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      evidenceId: json['evidenceId'] as String?,
      fraudFlag: json['fraudFlag'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      otherUserName: json['otherUserName'] as String?,
      otherUserUsername: json['otherUserUsername'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userAId': userAId,
      'userBId': userBId,
      'item': item,
      'amount': amount,
      'roleA': roleA,
      'roleB': roleB,
      'date': date.toIso8601String(),
      'status': status,
      'evidenceId': evidenceId,
      'fraudFlag': fraudFlag,
      'createdAt': createdAt.toIso8601String(),
      'otherUserName': otherUserName,
      'otherUserUsername': otherUserUsername,
    };
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'rejected':
        return 'Rejected';
      case 'blocked':
        return 'Blocked';
      default:
        return status;
    }
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isRejected => status.toLowerCase() == 'rejected';
}

class CreateVerificationRequest {
  final String otherUserIdentifier;
  final String item;
  final double amount;
  final String yourRole;
  final DateTime date;

  CreateVerificationRequest({
    required this.otherUserIdentifier,
    required this.item,
    required this.amount,
    required this.yourRole,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'otherUserIdentifier': otherUserIdentifier,
      'item': item,
      'amount': amount,
      'yourRole': yourRole,
      'date': date.toIso8601String(),
    };
  }
}
