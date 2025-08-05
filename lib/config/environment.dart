// Environment configuration for multi-mode app deployment

// Flutter imports:
import 'package:flutter/foundation.dart';

/// 🎯 App Mode Configuration - 2025 Best Practice
/// Defines how the app operates for different use cases
enum AppMode {
  /// Single user, no authentication required
  /// Perfect for individual coaches who want to use the app standalone
  standalone('Standalone Mode'),

  /// Multi-user demo with temporary accounts
  /// For trying out the SaaS features without commitment
  demo('Demo Mode'),

  /// Full SaaS with authentication, billing, multi-tenant
  /// For club-level deployment with multiple users
  saas('SaaS Mode');

  const AppMode(this.displayName);
  final String displayName;
}

/// 🌍 Environment Configuration
/// Manages different environments: development, test, production
enum EnvironmentType { development, test, production }

class EnvConfig {
  const EnvConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.appName,
    required this.enableDebugFeatures,
    required this.enableAnalytics,
    required this.sentryDsn,
    required this.stripePublishableKey,
  });
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String appName;
  final bool enableDebugFeatures;
  final bool enableAnalytics;
  final String sentryDsn;
  final String stripePublishableKey;
}

enum Environment {
  /// Development Environment
  development._(
    name: 'Development',
    supabaseUrl: 'https://ohdbsujaetmrztseqana.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oZGJzdWphZXRtcnp0c2VxYW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTgxNDcsImV4cCI6MjA2NjAzNDE0N30.J7Z9lKyr2nSNpxiwZRx4hJbq9_ZpwhLwtM0nvMCqqV8',
    appName: 'JO17 Tactical Manager',
    enableDebugFeatures: true,
    enablePerformanceLogging: true,
    logLevel: 'debug',
  ),

  /// Test Environment - Uses development database with test isolation
  test._(
    name: 'Test',
    supabaseUrl:
        'https://ohdbsujaetmrztseqana.supabase.co', // Same as dev for now
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oZGJzdWphZXRtcnp0c2VxYW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTgxNDcsImV4cCI6MjA2NjAzNDE0N30.J7Z9lKyr2nSNpxiwZRx4hJbq9_ZpwhLwtM0nvMCqqV8', // Same as dev
    appName: 'JO17 Tactical Manager (Test)',
    enableDebugFeatures: true,
    enablePerformanceLogging: false,
    logLevel: 'info',
  ),

  /// Production Environment
  production._(
    name: 'Production',
    supabaseUrl: 'https://ohdbsujaetmrztseqana.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oZGJzdWphZXRtcnp0c2VxYW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTgxNDcsImV4cCI6MjA2NjAzNDE0N30.J7Z9lKyr2nSNpxiwZRx4hJbq9_ZpwhLwtM0nvMCqqV8',
    appName: 'JO17 Tactical Manager',
    enableDebugFeatures: false,
    enablePerformanceLogging: false,
    logLevel: 'error',
  );

  const Environment._({
    required this.name,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.appName,
    required this.enableDebugFeatures,
    required this.enablePerformanceLogging,
    required this.logLevel,
  });
  final String name;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String appName;
  final bool enableDebugFeatures;
  final bool enablePerformanceLogging;
  final String logLevel;

  /// Get current environment based on build mode and environment variables
  static Environment get current {
    // Check for explicit environment variable first
    const envName = String.fromEnvironment('FLUTTER_ENV', defaultValue: '');
    if (envName.isNotEmpty) {
      return getByName(envName);
    }

    // Fallback to build mode detection
    if (kDebugMode) {
      return development;
    } else if (kProfileMode) {
      return test;
    } else {
      return production;
    }
  }

  /// 🎯 Get current app mode - 2025 Best Practice
  /// Determines how the app operates: standalone, demo, or saas
  static AppMode get appMode {
    // Check for explicit app mode environment variable
    const modeString = String.fromEnvironment('APP_MODE', defaultValue: '');
    if (modeString.isNotEmpty) {
      switch (modeString.toLowerCase()) {
        case 'standalone':
          return AppMode.standalone;
        case 'demo':
          return AppMode.demo;
        case 'saas':
          return AppMode.saas;
      }
    }

    // Check legacy coach mode flag for backwards compatibility
    const coachMode =
        String.fromEnvironment('COACH_MODE_ONLY', defaultValue: 'false');
    if (coachMode.toLowerCase() == 'true') {
      return AppMode.standalone;
    }

    // Default to standalone mode for single-user experience
    return AppMode.standalone;
  }

  /// Check if app is running in coach-only mode (legacy compatibility)
  static bool get isCoachMode => appMode == AppMode.standalone;

  /// Modern app mode checks - 2025 Best Practice
  static bool get isStandaloneMode => appMode == AppMode.standalone;
  static bool get isDemoMode => appMode == AppMode.demo;
  static bool get isSaasMode => appMode == AppMode.saas;

  /// Get environment by name
  static Environment getByName(String name) {
    switch (name.toLowerCase()) {
      case 'development':
      case 'dev':
        return development;
      case 'test':
      case 'testing':
        return test;
      case 'production':
      case 'prod':
        return production;
      default:
        return development;
    }
  }

  @override
  String toString() => 'Environment: $name';

  // Helper methods
  static bool get isDevelopment => current.name == 'Development';
  static bool get isStaging => current.name == 'Test';
  static bool get isProduction => current.name == 'Production';

  // Feature flags based on environment
  static bool get showDebugInfo => current.enableDebugFeatures;
  static bool get enableCrashReporting => !isDevelopment && !isCoachMode;
  static bool get enablePerformanceMonitoring => isProduction && !isCoachMode;

  // Coach mode feature flags
  static bool get enableAuthentication => !isCoachMode;
  static bool get enableSubscriptionGating => !isCoachMode;
  static bool get enableUsageLimits => !isCoachMode;
  static bool get enableOrganizationFeatures => !isCoachMode;
  static bool get enableBillingFeatures => !isCoachMode;

  // Multi-tenant configuration
  static const multiTenantConfig = {
    'maxTenantsPerInstance': 100,
    'enableTenantIsolation': true,
    'tenantDataRetentionDays': 90,
    'enableCrossTenantAnalytics': false,
  };

  // Telemetry & Monitoring endpoints
  static String? get otlpEndpoint {
    switch (current.name) {
      case 'production':
        return 'https://otlp.teammanager.app/v1/traces';
      case 'test':
        return 'https://staging-otlp.teammanager.app/v1/traces';
      default:
        return null; // Skip telemetry in development
    }
  }

  static String? get sentryDsn {
    switch (current.name) {
      case 'production':
        return 'https://your-sentry-dsn@sentry.io/project-id';
      case 'test':
        return 'https://your-staging-sentry-dsn@sentry.io/project-id';
      default:
        return null; // Skip error reporting in development
    }
  }

  // API endpoints
  static String get apiBaseUrl {
    switch (current.name) {
      case 'production':
        return 'https://api.teammanager.app';
      case 'test':
        return 'https://staging-api.teammanager.app';
      default:
        return 'http://localhost:3000';
    }
  }

  // Feature availability per environment
  static Map<String, bool> get availableFeatures {
    // In coach mode, all core features are enabled without restrictions
    if (isCoachMode) {
      return {
        'calendar': true,
        'analytics': true,
        'fieldDiagram': true,
        'video': true,
        'annualPlanning': true,
        'importExport': true,
        'api': false, // API access disabled in coach mode
        'betaFeatures': true,
        'playerManagement': true,
        'trainingPlanning': true,
        'matchManagement': true,
        'performanceAnalytics': true,
        'exerciseLibrary': true,
        'offlineMode': true,
        // Disabled SaaS features
        'userManagement': false,
        'billing': false,
        'organizationSettings': false,
        'subscriptions': false,
        'multiTenant': false,
      };
    }

    switch (current.name) {
      case 'production':
        return {
          'calendar': true,
          'analytics': true,
          'fieldDiagram': true,
          'video': true,
          'annualPlanning': true,
          'importExport': true,
          'api': true,
          'betaFeatures': false,
          'playerManagement': true,
          'trainingPlanning': true,
          'matchManagement': true,
          'performanceAnalytics': true,
          'exerciseLibrary': true,
          'offlineMode': false,
          'userManagement': true,
          'billing': true,
          'organizationSettings': true,
          'subscriptions': true,
          'multiTenant': true,
        };
      case 'test':
        return {
          'calendar': true,
          'analytics': true,
          'fieldDiagram': true,
          'video': true,
          'annualPlanning': true,
          'importExport': true,
          'api': true,
          'betaFeatures': true,
          'playerManagement': true,
          'trainingPlanning': true,
          'matchManagement': true,
          'performanceAnalytics': true,
          'exerciseLibrary': true,
          'offlineMode': false,
          'userManagement': true,
          'billing': true,
          'organizationSettings': true,
          'subscriptions': true,
          'multiTenant': true,
        };
      default:
        return {
          'calendar': true,
          'analytics': true,
          'fieldDiagram': true,
          'video': true,
          'annualPlanning': true,
          'importExport': true,
          'api': true,
          'betaFeatures': true,
          'playerManagement': true,
          'trainingPlanning': true,
          'matchManagement': true,
          'performanceAnalytics': true,
          'exerciseLibrary': true,
          'offlineMode': false,
          'userManagement': true,
          'billing': true,
          'organizationSettings': true,
          'subscriptions': true,
          'multiTenant': true,
        };
    }
  }
}
