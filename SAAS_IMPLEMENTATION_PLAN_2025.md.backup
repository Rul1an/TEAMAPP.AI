# JO17 Tactical Manager - SaaS Implementation Plan 2025 (Revised)

## 📋 Inhoudsopgave

1. [Executive Summary](#executive-summary)
2. [MVP Strategie](#mvp-strategie)
3. [Implementatie Roadmap](#implementatie-roadmap)
4. [Phase 1: Demo Mode (Quick Win)](#phase-1-demo-mode-quick-win)
5. [Phase 2: Basic Auth](#phase-2-basic-auth)
6. [Phase 3: Multi-tenancy](#phase-3-multi-tenancy)
7. [Phase 4: Deployment](#phase-4-deployment)
8. [Technische Details](#technische-details)

## 🎯 Executive Summary

### Herziene Aanpak
Op basis van de analyse kiezen we voor een **pragmatische MVP aanpak** die voortbouwt op de bestaande sterke punten:
- Solide model structuur
- Bestaande UI/UX
- Supabase configuratie

### MVP Focus (2-3 weken)
1. **Demo Mode First** - Direct waarde voor sales/demo
2. **Simple Auth** - Magic links zonder complexiteit
3. **Soft Multi-tenancy** - Organization isolation zonder RLS
4. **Quick Deploy** - Netlify static hosting

## 🚀 MVP Strategie

### Principes
1. **Build on Strengths** - Gebruik bestaande models en UI
2. **Fake it till you make it** - Demo mode voor immediate value
3. **Progressive Enhancement** - Start simple, add complexity later
4. **Time to Market** - 2-3 weken naar live demo

### Out of Scope voor MVP
- Payment integration
- Complex permissions
- Real-time sync
- Email notifications
- User invitations

## 📅 Implementatie Roadmap

### Week 1: Demo Mode & Basic Auth
- **Dag 1-2**: Demo Mode Provider
- **Dag 3-4**: Login Screen met Demo buttons
- **Dag 5**: Basic Auth Service

### Week 2: Multi-tenancy Light
- **Dag 1-2**: Organization context
- **Dag 3-4**: Role-based navigation
- **Dag 5**: Testing & fixes

### Week 3: Deployment & Polish
- **Dag 1-2**: Netlify setup
- **Dag 3-4**: Bug fixes
- **Dag 5**: Documentation

## 🎮 Phase 1: Demo Mode (Quick Win)

### 1.1 Demo Mode Provider
```dart
// lib/providers/demo_mode_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

enum DemoRole { clubAdmin, coach, player }

class DemoModeState {
  final bool isActive;
  final DemoRole? role;
  final String? organizationId;
  final String? userId;
  final DateTime? expiresAt;

  DemoModeState({
    this.isActive = false,
    this.role,
    this.organizationId,
    this.userId,
    this.expiresAt,
  });
}

class DemoModeNotifier extends StateNotifier<DemoModeState> {
  Timer? _sessionTimer;

  DemoModeNotifier() : super(DemoModeState());

  void startDemo(DemoRole role) {
    // Cancel existing timer
    _sessionTimer?.cancel();

    // Set demo state
    state = DemoModeState(
      isActive: true,
      role: role,
      organizationId: 'demo-org-${role.name}',
      userId: 'demo-user-${role.name}',
      expiresAt: DateTime.now().add(Duration(minutes: 30)),
    );

    // Start session timer
    _sessionTimer = Timer(Duration(minutes: 30), () {
      endDemo();
    });
  }

  void endDemo() {
    _sessionTimer?.cancel();
    state = DemoModeState();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}

final demoModeProvider = StateNotifierProvider<DemoModeNotifier, DemoModeState>(
  (ref) => DemoModeNotifier(),
);
```

### 1.2 Demo Data Service
```dart
// lib/services/demo_data_service.dart
class DemoDataService {
  static Map<String, dynamic> generateDemoData(DemoRole role) {
    switch (role) {
      case DemoRole.clubAdmin:
        return {
          'club': _createDemoClub(),
          'teams': _createDemoTeams(),
          'players': _createDemoPlayers(45),
          'coaches': _createDemoCoaches(5),
        };
      case DemoRole.coach:
        return {
          'team': _createDemoTeam(),
          'players': _createDemoPlayers(18),
          'trainings': _createDemoTrainings(),
          'matches': _createDemoMatches(),
        };
      case DemoRole.player:
        return {
          'profile': _createDemoPlayerProfile(),
          'team': _createDemoTeam(),
          'schedule': _createDemoSchedule(),
        };
    }
  }
}
```

### 1.3 Quick Login Screen
```dart
// lib/screens/auth/login_screen.dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/logo.png', height: 120),
              SizedBox(height: 48),

              // Title
              Text(
                'JO17 Tactical Manager',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 8),
              Text(
                'Professioneel Team Management',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              SizedBox(height: 48),

              // Email login (disabled for MVP)
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  enabled: false,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: null,
                child: Text('Login met Email (Coming Soon)'),
              ),

              SizedBox(height: 32),
              Divider(),
              SizedBox(height: 32),

              // Demo buttons
              Text(
                'Probeer Direct:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16),

              // Demo as Club Admin
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(demoModeProvider.notifier).startDemo(DemoRole.clubAdmin);
                  context.go('/dashboard');
                },
                icon: Icon(Icons.business),
                label: Text('Demo als Bestuurder'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),

              SizedBox(height: 12),

              // Demo as Coach
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(demoModeProvider.notifier).startDemo(DemoRole.coach);
                  context.go('/dashboard');
                },
                icon: Icon(Icons.sports),
                label: Text('Demo als Coach'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),

              SizedBox(height: 12),

              // Demo as Player
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(demoModeProvider.notifier).startDemo(DemoRole.player);
                  context.go('/dashboard');
                },
                icon: Icon(Icons.person),
                label: Text('Demo als Speler'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🔐 Phase 2: Basic Auth

### 2.1 Minimal Auth Service
```dart
// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Simple magic link login
  Future<void> signInWithEmail(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'https://app.jo17manager.nl/auth/callback',
    );
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
```

### 2.2 Auth Provider
```dart
// lib/providers/auth_provider.dart
final authServiceProvider = Provider((ref) => AuthService());

final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenData((state) => state.session?.user).value;
});
```

## 🏢 Phase 3: Multi-tenancy

### 3.1 Organization Context Provider
```dart
// lib/providers/organization_provider.dart
final currentOrganizationProvider = Provider<String?>((ref) {
  final demoMode = ref.watch(demoModeProvider);
  if (demoMode.isActive) {
    return demoMode.organizationId;
  }

  // For MVP: single organization per user
  return 'default-org';
});
```

### 3.2 Updated Database Service
```dart
// lib/services/database_service.dart
class DatabaseService {
  final Ref ref;

  DatabaseService(this.ref);

  String? get organizationId => ref.read(currentOrganizationProvider);

  Future<List<Player>> getPlayers() async {
    final demo = ref.read(demoModeProvider);
    if (demo.isActive) {
      return DemoDataService.getDemoPlayers(demo.role!);
    }

    // For MVP: return mock data with org filter
    return _mockPlayers.where((p) => p.organizationId == organizationId).toList();
  }
}
```

## 🚀 Phase 4: Deployment

### 4.1 Netlify Configuration
```toml
# netlify.toml
[build]
  command = "flutter build web --release --web-renderer html"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### 4.2 Environment Setup
```bash
# .env (not committed)
SUPABASE_URL=https://ohdbsujaetmrztseqana.supabase.co
SUPABASE_ANON_KEY=your_anon_key
```

## 🔧 Technische Details

### Router Updates
```dart
// lib/config/router.dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final demoMode = ref.read(demoModeProvider);
    final isLoggedIn = ref.read(currentUserProvider) != null;

    // Allow demo mode without auth
    if (demoMode.isActive) return null;

    // Redirect to login if not authenticated
    if (!isLoggedIn && !state.location.startsWith('/login')) {
      return '/login';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    // ... existing routes
  ],
);
```

### Main App Updates
```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  await initializeDateFormatting('nl', null);

  // Initialize Supabase (but don't require it for demo)
  try {
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  } catch (e) {
    print('Supabase init failed, demo mode only: $e');
  }

  runApp(
    const ProviderScope(
      child: JO17TacticalManagerApp(),
    ),
  );
}
```

## 📝 Success Criteria

### MVP Launch (Week 3)
- ✅ Demo mode werkt voor 3 rollen
- ✅ Basic auth met magic links
- ✅ Organization isolation (soft)
- ✅ Deployed on Netlify
- ✅ 30 min demo sessions

### Post-MVP (Later)
- Real Supabase integration
- RLS policies
- User invitations
- Payment integration
- Email notifications

## 🎯 Conclusie

Deze herziene aanpak focust op **snelle waarde levering** door:
1. Demo mode als eerste prioriteit
2. Minimale auth implementatie
3. Soft multi-tenancy zonder complexe RLS
4. Quick deployment naar Netlify

**Geschatte doorlooptijd: 2-3 weken voor werkende demo**

---

*Plan herzien: December 2024*
