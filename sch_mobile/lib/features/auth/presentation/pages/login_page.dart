import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/responsive/breakpoints.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    await ref.read(authStateProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isTablet = !context.isMobile;

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/home');
        });
      }
      if (next.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.error!),
                backgroundColor: AppColors.error,
              ),
            );
            ref.read(authStateProvider.notifier).clearError();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: isTablet
              ? _buildTabletLayout(context, authState)
              : _buildMobileLayout(context, authState),
        ),
      ),
    );
  }

  // ─── Tablet: Two-column layout ─────────────────────────────────────────────
  Widget _buildTabletLayout(BuildContext context, AuthState authState) {
    return Row(
      children: [
        // ── Left: image + overlay + content ────────────────────────────────
        Expanded(
          flex: 5,
          child: _LeftPanel(),
        ),

        // ── Right: login form (white card) ─────────────────────────────────
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 52, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _buildForm(context, authState),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Mobile: Dark background + form ────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context, AuthState authState) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          'assets/images/login_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF0B1A35),
          ),
        ),
        // Dark gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xB0050D1F),
                Color(0xEE0A1530),
              ],
            ),
          ),
        ),
        // Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppShadows.coloredPrimary,
                ),
                child: const Icon(Icons.health_and_safety_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                'ASCP-Connect',
                style: GoogleFonts.syne(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Santé communautaire pour Haïti',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 40),
              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: _buildForm(context, authState),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Shared form ────────────────────────────────────────────────────────────
  Widget _buildForm(BuildContext context, AuthState authState) {
    final isTablet = !context.isMobile;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTablet) ...[
            Text(
              'Connexion',
              style: GoogleFonts.syne(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Connectez-vous à votre compte agent',
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
          ],

          // Email field
          _fieldLabel('Adresse email', dark: isTablet),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !authState.isLoading,
            style: GoogleFonts.dmSans(
                fontSize: 15, color: const Color(0xFF0F172A)),
            decoration: const InputDecoration(
              hintText: 'agent@sante.ht',
              prefixIcon:
                  Icon(Icons.email_outlined, size: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Veuillez entrer votre email';
              if (!value.contains('@')) return 'Email invalide';
              return null;
            },
          ),
          const SizedBox(height: 18),

          // Password field
          _fieldLabel('Mot de passe', dark: isTablet),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !authState.isLoading,
            style: GoogleFonts.dmSans(
                fontSize: 15, color: const Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.lightTextMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Veuillez entrer votre mot de passe';
              if (value.length < 8) return 'Minimum 8 caractères';
              return null;
            },
          ),
          const SizedBox(height: 6),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              child: Text(
                'Mot de passe oublié ?',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Login button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: authState.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                textStyle: GoogleFonts.dmSans(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Se connecter'),
            ),
          ),
          const SizedBox(height: 20),

          // Offline badge
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                    color: AppColors.success.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Mode hors ligne disponible',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isTablet) ...[
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© 2026 Système de Santé Communautaire d\'Haïti',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.lightTextMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _fieldLabel(String label, {bool dark = true}) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: dark ? const Color(0xFF0F172A) : Colors.white,
      ),
    );
  }
}

// ============================================================================
// Left Panel (tablet) — background image + overlay + content
// ============================================================================

class _LeftPanel extends StatelessWidget {
  const _LeftPanel();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background image ────────────────────────────────────────────────
        Image.asset(
          'assets/images/login_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF0B1A35),
          ),
        ),

        // ── Gradient overlay (dark navy on top of photo) ────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xCC050D1F),
                const Color(0xBB0B1A35),
                const Color(0x883B82F6).withOpacity(0.25),
              ],
            ),
          ),
        ),

        // ── Content ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.health_and_safety_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'ASCP-Connect',
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Big stat number
              Text(
                '247',
                style: GoogleFonts.syne(
                  color: Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -4,
                  shadows: [
                    Shadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 32,
                    ),
                  ],
                ),
              ),
              Text(
                'agents actifs\nà travers Haïti',
                style: GoogleFonts.syne(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Une plateforme conçue pour les agents de santé\ncommunautaire sur le terrain.',
                style: GoogleFonts.dmSans(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 48),

              // Feature pillars
              _FeaturePillar(
                icon: Icons.wifi_off_rounded,
                text: 'Fonctionne hors ligne',
              ),
              const SizedBox(height: 14),
              _FeaturePillar(
                icon: Icons.home_rounded,
                text: 'Recensement des ménages',
              ),
              const SizedBox(height: 14),
              _FeaturePillar(
                icon: Icons.warning_amber_rounded,
                text: 'Alertes urgentes',
              ),

              const SizedBox(height: 48),

              // Bottom copyright
              Text(
                '© 2026 SCH · Système de Santé Communautaire d\'Haïti',
                style: GoogleFonts.dmSans(
                  color: Colors.white.withOpacity(0.28),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Feature Pillar ─────────────────────────────────────────────────────────

class _FeaturePillar extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeaturePillar({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.secondary, size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.dmSans(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
