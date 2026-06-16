/// Lightweight, fully on-device user profile. No account / sign-in is required,
/// keeping the app COPPA-friendly and privacy-first.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.referralCode,
    required this.createdAt,
    this.referredBy,
    this.referralCredits = 0,
  });

  final String id;
  final String displayName;
  final String referralCode;
  final DateTime createdAt;
  final String? referredBy;
  final int referralCredits;

  UserProfile copyWith({
    String? displayName,
    String? referredBy,
    int? referralCredits,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      referralCode: referralCode,
      createdAt: createdAt,
      referredBy: referredBy ?? this.referredBy,
      referralCredits: referralCredits ?? this.referralCredits,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'displayName': displayName,
        'referralCode': referralCode,
        'createdAt': createdAt.toIso8601String(),
        'referredBy': referredBy,
        'referralCredits': referralCredits,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        referralCode: json['referralCode'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        referredBy: json['referredBy'] as String?,
        referralCredits: (json['referralCredits'] as num?)?.toInt() ?? 0,
      );
}
