import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/accessibility_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final a11y = ref.watch(accessibilityProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Agent',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role?.toUpperCase() ?? 'AGENT',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Info
          _ProfileInfoTile(
            icon: Icons.phone,
            label: 'Téléphone',
            value: user?.phone ?? 'Non renseigné',
          ),
          _ProfileInfoTile(
            icon: Icons.location_on,
            label: 'Zone',
            value: user?.zone ?? 'Non assignée',
          ),
          _ProfileInfoTile(
            icon: Icons.local_hospital,
            label: 'Centre de Santé',
            value: user?.healthCenterId ?? 'Non assigné',
          ),
          const SizedBox(height: 24),

          // ── Accessibilité ─────────────────────────────────────────────
          Semantics(
            header: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Accessibilité',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.lightTextMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          _A11yToggle(
            icon: Icons.contrast_rounded,
            label: 'Fort contraste',
            subtitle: 'Texte plus gras, surfaces plus foncées',
            value: a11y.highContrast,
            onChanged: (_) => ref
                .read(accessibilityProvider.notifier)
                .toggleHighContrast(),
          ),
          _A11yToggle(
            icon: Icons.text_fields_rounded,
            label: 'Texte agrandi',
            subtitle: 'Taille de police +20% (1.2×)',
            value: a11y.largeText,
            onChanged: (_) => ref
                .read(accessibilityProvider.notifier)
                .toggleLargeText(),
          ),
          _A11yToggle(
            icon: Icons.screen_lock_portrait_rounded,
            label: 'Orientation portrait',
            subtitle: 'Bloquer la rotation de l\'écran',
            value: a11y.portraitLock,
            onChanged: (_) => ref
                .read(accessibilityProvider.notifier)
                .togglePortraitLock(),
          ),
          const SizedBox(height: 16),
          _ProfileActionTile(
            icon: Icons.help_outline,
            label: 'Aide',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité à venir')),
              );
            },
          ),
          _ProfileActionTile(
            icon: Icons.info_outline,
            label: 'À propos',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ASCP-Connect',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.health_and_safety),
                children: [
                  const Text('Application mobile pour les agents de santé communautaire polyvalents (ASCP) en Haïti.'),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Semantics(
            button: true,
            label: 'Déconnexion',
            child: _ProfileActionTile(
              icon: Icons.logout,
              label: 'Déconnexion',
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg)),
                    title: const Text('Déconnexion'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: [
                      SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.error),
                          child: const Text('Déconnexion'),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref.read(authStateProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                }
              },
              isDestructive: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDestructive ? AppColors.error : null,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.lightTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Accessibility Toggle ──────────────────────────────────────────────────────
class _A11yToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _A11yToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: label,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: SwitchListTile(
          secondary: Icon(
            icon,
            color: value
                ? Theme.of(context).colorScheme.primary
                : AppColors.lightTextMuted,
            size: 24,
          ),
          title: Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle,
              style: TextStyle(
                  fontSize: 13, color: AppColors.lightTextMuted)),
          value: value,
          onChanged: onChanged,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }
}
