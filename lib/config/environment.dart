// Environment configuration for multi-tenant SaaS deployment

// Flutter imports:
import 'package:flutter/foundation.dart';

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

  /// Test Environment
  test._(
    name: 'Test',
    supabaseUrl: 'https://ohdbsujaetmrztseqana.supabase.co',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oZGJzdWphZXRtcnp0c2VxYW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTgxNDcsImV4cCI6MjA2NjAzNDE0N30.J7Z9lKyr2nSNpxiwZRx4hJbq9_ZpwhLwtM0nvMCqqV8',
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

  /// Get current environment based on build mode
  static Environment get current {
    if (kDebugMode) {
      return development;
    } else if (kProfileMode) {
      return test;
    } else {
      return production;
    }
  }

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
  static bool get enableCrashReporting => !isDevelopment;
  static bool get enablePerformanceMonitoring => isProduction;

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
        };
    }
  }
}
