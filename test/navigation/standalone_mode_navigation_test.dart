// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:jo17_tactical_manager/config/environment.dart';
import 'package:jo17_tactical_manager/config/router.dart';
import 'package:jo17_tactical_manager/config/providers.dart';
import 'package:jo17_tactical_manager/screens/dashboard/dashboard_screen.dart';
import 'package:jo17_tactical_manager/analytics/analytics_route_observer.dart';

// Test imports:
import '../helpers/firebase_test_helper.dart';
import '../helpers/auth_test_helper.dart';

/// Mock Analytics Route Observer for testing
class MockAnalyticsRouteObserver extends AnalyticsRouteObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // No-op for tests - skip analytics logging
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // No-op for tests - skip analytics logging
  }
}

/// Tests for standalone mode navigation behavior
/// Verifies that the app correctly navigates to dashboard without auth
void main() {
  group('Standalone Mode Navigation Tests', () {
    late ProviderContainer container;
    late GoRouter router;

    setUp(() async {
      // Setup Firebase mocking before creating providers
      await FirebaseTestHelper.setupFirebaseMocking();

      // Setup Auth mocking for Supabase
      AuthTestHelper.setupAuthMocking();

      // Create container with all necessary overrides for standalone mode
      container = ProviderContainer(
        overrides: [
          // Auth provider overrides for standalone mode
          ...AuthTestHelper.getStandaloneModeOverrides(),
          // Mock analytics route observer to prevent dependency issues
          analyticsRouteObserverProvider
              .overrideWithValue(MockAnalyticsRouteObserver()),
        ],
      );

      router = container.read(routerProvider);
    });

    tearDown(() {
      container.dispose();
      FirebaseTestHelper.cleanup();
      AuthTestHelper.cleanup();
    });

    testWidgets('should start at dashboard in standalone mode', (tester) async {
      // Verify Environment is in standalone mode
      expect(Environment.isStandaloneMode, isTrue);
      expect(Environment.isDemoMode, isFalse);
      expect(Environment.isSaasMode, isFalse);

      // Build app with router
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Wait for navigation to complete - Best Practice 2025: Use controlled pumps instead of pumpAndSettle
      await tester.pump(); // Initial build
      await tester.pump(const Duration(milliseconds: 100)); // Allow navigation
      await tester.pump(const Duration(milliseconds: 100)); // Allow rendering

      // Verify we're on the correct screen
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(router.routerDelegate.currentConfiguration.fullPath,
          equals('/dashboard'));
    });

    testWidgets('should redirect from auth to dashboard in standalone mode',
        (tester) async {
      // Navigate to auth page
      router.go('/auth');

      // Build app
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Wait for redirect to complete - Best Practice 2025: Use controlled pumps
      await tester.pump(); // Initial build
      await tester.pump(const Duration(milliseconds: 100)); // Allow navigation
      await tester.pump(const Duration(milliseconds: 100)); // Allow rendering

      // Verify redirect worked
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(router.routerDelegate.currentConfiguration.fullPath,
          equals('/dashboard'));
    });

    test('should have correct auth state in standalone mode', () {
      // Auth providers should return correct values for standalone mode
      expect(container.read(isLoggedInProvider), isTrue);
      expect(container.read(userRoleProvider), equals('coach'));
      expect(container.read(organizationIdProvider),
          equals('standalone-org-local'));
      expect(container.read(currentUserProvider),
          isNull); // No actual Supabase user needed
    });

    test('should allow all routes in standalone mode', () {
      // All main routes should be accessible
      final testRoutes = [
        '/dashboard',
        '/players',
        '/training',
        '/matches',
        '/training-sessions',
        '/exercise-library',
        '/annual-planning',
        '/insights',
      ];

      for (final route in testRoutes) {
        expect(() => router.go(route), returnsNormally);
      }
    });

    test('should have correct environment flags', () {
      // Verify environment flags are set correctly
      expect(Environment.isStandaloneMode, isTrue);
      expect(Environment.appMode, equals(AppMode.standalone));
      expect(Environment.appMode.displayName, equals('Standalone Mode'));

      // Legacy compatibility
      expect(Environment.isCoachMode, isTrue);

      // Feature flags should be appropriate for standalone
      expect(Environment.enableAuthentication, isFalse);
      expect(Environment.enableSubscriptionGating, isFalse);
      expect(Environment.enableUsageLimits, isFalse);
      expect(Environment.enableOrganizationFeatures, isFalse);
      expect(Environment.enableBillingFeatures, isFalse);
    });

    test('should have all core features enabled in standalone mode', () {
      final features = Environment.availableFeatures;

      // Core features should be enabled
      expect(features['calendar'], isTrue);
      expect(features['analytics'], isTrue);
      expect(features['fieldDiagram'], isTrue);
      expect(features['video'], isTrue);
      expect(features['annualPlanning'], isTrue);
      expect(features['importExport'], isTrue);
      expect(features['playerManagement'], isTrue);
      expect(features['trainingPlanning'], isTrue);
      expect(features['matchManagement'], isTrue);
      expect(features['performanceAnalytics'], isTrue);
      expect(features['exerciseLibrary'], isTrue);
      expect(features['offlineMode'], isTrue);
      expect(features['betaFeatures'], isTrue);

      // SaaS features should be disabled
      expect(features['userManagement'], isFalse);
      expect(features['billing'], isFalse);
      expect(features['organizationSettings'], isFalse);
      expect(features['subscriptions'], isFalse);
      expect(features['multiTenant'], isFalse);
      expect(features['api'], isFalse);
    });
  });
}
