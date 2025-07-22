class Profile {
  const Profile({
    required this.userId,
    required this.organizationId,
    required this.createdAt,
    required this.updatedAt,
    this.username,
    this.avatarUrl,
    this.website,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        userId: json['user_id'] as String,
        organizationId: json['organization_id'] as String,
        username: json['username'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        website: json['website'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  final String userId;
  final String organizationId;
  final String? username;
  final String? avatarUrl;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile copyWith({
    String? username,
    String? avatarUrl,
    String? website,
    DateTime? updatedAt,
  }) =>
      Profile(
        userId: userId,
        organizationId: organizationId,
        username: username ?? this.username,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        website: website ?? this.website,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'organization_id': organizationId,
        'username': username,
        'avatar_url': avatarUrl,
        'website': website,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
