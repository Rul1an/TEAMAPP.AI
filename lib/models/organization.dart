enum OrganizationTier { basic, pro, enterprise }

class Organization {
  Organization({
    required this.id,
    required this.name,
    required this.slug,
    this.tier = OrganizationTier.basic,
    this.logoUrl,
    this.primaryColor = '#1976D2',
    this.secondaryColor = '#FFC107',
    Map<String, dynamic>? settings,
    this.subscriptionStatus = 'trial',
    this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
  }) : settings = settings ?? {};

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        tier: OrganizationTier.values.firstWhere(
          (e) => e.name == json['tier'],
          orElse: () => OrganizationTier.basic,
        ),
        logoUrl: json['logoUrl'] as String?,
        primaryColor: json['primaryColor'] as String? ?? '#1976D2',
        secondaryColor: json['secondaryColor'] as String? ?? '#FFC107',
        settings: json['settings'] as Map<String, dynamic>? ?? {},
        subscriptionStatus: json['subscriptionStatus'] as String? ?? 'trial',
        subscriptionEndDate: json['subscriptionEndDate'] != null
            ? DateTime.parse(json['subscriptionEndDate'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
  final String id;
  final String name;
  final String slug;
  final OrganizationTier tier;
  final String? logoUrl;
  final String primaryColor;
  final String secondaryColor;
  final Map<String, dynamic> settings;
  final String subscriptionStatus;
  final DateTime? subscriptionEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Organization copyWith({
    String? id,
    String? name,
    String? slug,
    OrganizationTier? tier,
    String? logoUrl,
    String? primaryColor,
    String? secondaryColor,
    Map<String, dynamic>? settings,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Organization(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        tier: tier ?? this.tier,
        logoUrl: logoUrl ?? this.logoUrl,
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        settings: settings ?? this.settings,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'tier': tier.name,
        'logoUrl': logoUrl,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'settings': settings,
        'subscriptionStatus': subscriptionStatus,
        'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class OrganizationSettings {
  const OrganizationSettings({
    this.maxPlayers = 25,
    this.maxTeams = 1,
    this.maxCoaches = 2,
    this.svsEnabled = false,
    this.analyticsEnabled = false,
    this.apiAccess = false,
  });

  factory OrganizationSettings.fromJson(Map<String, dynamic> json) =>
      OrganizationSettings(
        maxPlayers: json['maxPlayers'] as int? ?? 25,
        maxTeams: json['maxTeams'] as int? ?? 1,
        maxCoaches: json['maxCoaches'] as int? ?? 2,
        svsEnabled: json['svsEnabled'] as bool? ?? false,
        analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
        apiAccess: json['apiAccess'] as bool? ?? false,
      );
  final int maxPlayers;
  final int maxTeams;
  final int maxCoaches;
  final bool svsEnabled;
  final bool analyticsEnabled;
  final bool apiAccess;

  Map<String, dynamic> toJson() => {
        'maxPlayers': maxPlayers,
        'maxTeams': maxTeams,
        'maxCoaches': maxCoaches,
        'svsEnabled': svsEnabled,
        'analyticsEnabled': analyticsEnabled,
        'apiAccess': apiAccess,
      };
}

// Helper extension for tier features
extension OrganizationTierExtension on OrganizationTier {
  OrganizationSettings get defaultSettings {
    switch (this) {
      case OrganizationTier.basic:
        return const OrganizationSettings();
      case OrganizationTier.pro:
        return const OrganizationSettings(
          maxPlayers: 100,
          maxTeams: 3,
          maxCoaches: 5,
          svsEnabled: true,
          analyticsEnabled: true,
        );
      case OrganizationTier.enterprise:
        return const OrganizationSettings(
          maxPlayers: 999,
          maxTeams: 99,
          maxCoaches: 99,
          svsEnabled: true,
          analyticsEnabled: true,
          apiAccess: true,
        );
    }
  }

  String get displayName {
    switch (this) {
      case OrganizationTier.basic:
        return 'Basic';
      case OrganizationTier.pro:
        return 'Pro';
      case OrganizationTier.enterprise:
        return 'Enterprise';
    }
  }

  double get monthlyPrice {
    switch (this) {
      case OrganizationTier.basic:
        return 9;
      case OrganizationTier.pro:
        return 29;
      case OrganizationTier.enterprise:
        return 99;
    }
  }
}
