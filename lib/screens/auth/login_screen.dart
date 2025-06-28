import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/demo_mode_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _startDemoMode(DemoRole role) {
    ref.read(demoModeProvider.notifier).startDemo(
          role: role,
          organizationId: 'demo-org-1',
          userId: 'demo-user-${role.name}',
          userName: 'Demo User',
        );
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo placeholder
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.sports_soccer,
                            size: 60,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'JO17 Tactical Manager',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Professioneel Team Management',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Email login section
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'voornaam@club.nl',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabled: false, // Disabled for MVP
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: null, // Disabled for MVP
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Login met Email (Coming Soon)'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OF',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Demo section
                        Text(
                          'Probeer Direct',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kies een rol voor de demo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Demo buttons - Management roles
                        _DemoRoleButton(
                          icon: Icons.business,
                          label: 'Demo als Club Admin',
                          subtitle: 'Volledige toegang tot alle functies',
                          onPressed: () => _startDemoMode(DemoRole.clubAdmin),
                          isPrimary: true,
                        ),
                        const SizedBox(height: 12),

                        _DemoRoleButton(
                          icon: Icons.groups,
                          label: 'Demo als Bestuurder',
                          subtitle: 'Beheer teams en spelers',
                          onPressed: () => _startDemoMode(DemoRole.boardMember),
                        ),
                        const SizedBox(height: 12),

                        _DemoRoleButton(
                          icon: Icons.analytics,
                          label: 'Demo als Technische Commissie',
                          subtitle: 'Analyseer prestaties en ontwikkeling',
                          onPressed: () =>
                              _startDemoMode(DemoRole.technicalCommittee),
                        ),
                        const SizedBox(height: 12),

                        // Demo buttons - Coaching roles
                        _DemoRoleButton(
                          icon: Icons.sports,
                          label: 'Demo als Hoofdtrainer',
                          subtitle: 'Plan trainingen en wedstrijden',
                          onPressed: () => _startDemoMode(DemoRole.coach),
                          isPrimary: true,
                        ),
                        const SizedBox(height: 12),

                        _DemoRoleButton(
                          icon: Icons.assistant,
                          label: 'Demo als Assistent Trainer',
                          subtitle: 'Ondersteun de hoofdtrainer',
                          onPressed: () =>
                              _startDemoMode(DemoRole.assistantCoach),
                        ),
                        const SizedBox(height: 12),

                        // Demo button - Player role
                        _DemoRoleButton(
                          icon: Icons.person,
                          label: 'Demo als Speler',
                          subtitle: 'Bekijk je schema en statistieken',
                          onPressed: () => _startDemoMode(DemoRole.player),
                          isOutlined: true,
                        ),

                        const SizedBox(height: 24),

                        // Demo info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Demo sessies zijn 30 minuten geldig',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoRoleButton extends StatelessWidget {
  const _DemoRoleButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
    this.isPrimary = false,
    this.isOutlined = false,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _buildContent(theme),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? null : theme.colorScheme.secondaryContainer,
        foregroundColor:
            isPrimary ? null : theme.colorScheme.onSecondaryContainer,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) => Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      );
}
