import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/responsive/adaptive_navigation.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../shared/widgets/sync_widgets.dart';
import 'patients_page.dart';
import 'households_page.dart';
import '../../../triage/presentation/pages/case_reports_page.dart';
import 'profile_page.dart';
import '../../../../core/providers/sync_provider.dart';
import '../../../patients/presentation/providers/patient_provider.dart';
import '../../../households/presentation/providers/households_provider.dart';
import '../../../triage/presentation/providers/triage_providers.dart';

// ============================================================================
// Home Page — shell with adaptive navigation
// ============================================================================

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    PatientsPage(),
    HouseholdsPage(),
    CaseReportsPage(),
    ProfilePage(),
  ];

  final List<NavigationDestinationData> _destinations = const [
    NavigationDestinationData(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: 'Accueil',
    ),
    NavigationDestinationData(
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      label: 'Patients',
    ),
    NavigationDestinationData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Ménages',
    ),
    NavigationDestinationData(
      icon: Icons.list_alt_outlined,
      selectedIcon: Icons.list_alt_rounded,
      label: 'Rapports',
    ),
    NavigationDestinationData(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = !context.isMobile;
    return AdaptiveNavigation(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: _destinations,
      body: _currentIndex == 0
          ? _pages[_currentIndex]
          : Scaffold(
              backgroundColor:
                  isDark ? AppColors.darkBackground : AppColors.lightBackground,
              appBar: AppBar(
                title: Text(
                  _destinations[_currentIndex].label,
                  style: GoogleFonts.syne(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 20 : 18,
                  ),
                ),
                actions: const [
                  SyncStatusIndicator(),
                  SizedBox(width: 8),
                  SyncButton(),
                  SizedBox(width: 16),
                ],
              ),
              body: ConnectivityBanner(child: _pages[_currentIndex]),
            ),
    );
  }
}

// ============================================================================
// Dashboard Tab
// ============================================================================

class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab>
    with TickerProviderStateMixin {
  late final List<AnimationController> _statControllers;
  late final List<Animation<double>> _statSlides;
  late final List<Animation<double>> _statFades;

  late final List<AnimationController> _activityControllers;
  late final List<Animation<double>> _activitySlides;
  late final List<Animation<double>> _activityFades;

  late final AnimationController _syncSpinController;

  @override
  void initState() {
    super.initState();

    // Stat card animations
    _statControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      ),
    );
    _statSlides = _statControllers.map((ctrl) {
      return Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
      );
    }).toList();
    _statFades = _statControllers.map((ctrl) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
      );
    }).toList();

    // Stagger stat cards
    for (int i = 0; i < _statControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 80 + i * 70), () {
        if (mounted) _statControllers[i].forward();
      });
    }

    // Activity animation
    _activityControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _activitySlides = _activityControllers.map((ctrl) {
      return Tween<double>(begin: 40, end: 0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
      );
    }).toList();
    _activityFades = _activityControllers.map((ctrl) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
      );
    }).toList();

    for (int i = 0; i < _activityControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + i * 80), () {
        if (mounted) _activityControllers[i].forward();
      });
    }

    // Sync spin
    _syncSpinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    for (final c in _statControllers) c.dispose();
    for (final c in _activityControllers) c.dispose();
    _syncSpinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = !context.isMobile;
    final padding = isTablet ? 28.0 : 16.0;
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Stack(
      children: [
        // ── Ambient background halos ────────────────────────────────────────
        _AmbientBackground(isDark: isDark),

        // ── Scrollable content ──────────────────────────────────────────────
        Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _WelcomeHeader(
                  name: user?.name ?? 'Agent',
                  zone: user?.zone,
                  isDark: isDark,
                  isTablet: isTablet,
                  syncController: _syncSpinController,
                ),
                const SizedBox(height: 24),

                // Stat grid label
                _SectionLabel('Statistiques du jour', isDark: isDark),
                const SizedBox(height: 12),

                // Stat grid
                _StatGrid(
                  isTablet: isTablet,
                  isDark: isDark,
                  statSlides: _statSlides,
                  statFades: _statFades,
                ),
                const SizedBox(height: 28),

                // Quick actions + activity (responsive)
                if (isTablet)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _QuickActionsSection(isDark: isDark),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _ActivitySection(
                          isDark: isDark,
                          actSlides: _activitySlides,
                          actFades: _activityFades,
                        ),
                      ),
                    ],
                  )
                else ...[
                  _QuickActionsSection(isDark: isDark),
                  const SizedBox(height: 24),
                  _ActivitySection(
                    isDark: isDark,
                    actSlides: _activitySlides,
                    actFades: _activityFades,
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Ambient background halos
// ============================================================================

class _AmbientBackground extends StatelessWidget {
  final bool isDark;
  const _AmbientBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final haloOpacity = isDark ? 0.06 : 0.04;
    return IgnorePointer(
      child: Stack(
        children: [
          // Top-right blue halo
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(haloOpacity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-left cyan halo
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(haloOpacity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Section Label
// ============================================================================

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.syne(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }
}

// ============================================================================
// Welcome Header
// ============================================================================

class _WelcomeHeader extends StatelessWidget {
  final String name;
  final String? zone;
  final bool isDark;
  final bool isTablet;
  final AnimationController syncController;

  const _WelcomeHeader({
    required this.name,
    this.zone,
    required this.isDark,
    required this.isTablet,
    required this.syncController,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    final days = [
      '', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'
    ];
    final dateStr =
        '${days[now.weekday]} ${now.day} ${months[now.month]} ${now.year}';

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkSurface,
                  AppColors.primary.withOpacity(0.07),
                ]
              : [
                  Colors.white,
                  AppColors.primary.withOpacity(0.03),
                ],
        ),
        boxShadow: AppShadows.card(context),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: isTablet ? 52 : 44,
            height: isTablet ? 52 : 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: AppShadows.coloredPrimary,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'A',
              style: GoogleFonts.syne(
                color: Colors.white,
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name + zone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, $name 👋',
                  style: GoogleFonts.syne(
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        zone ?? 'Zone non assignée',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isTablet) ...[
                      const SizedBox(width: 10),
                      Text(
                        '· $dateStr',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Sync button + indicator
          const SyncStatusIndicator(),
          const SizedBox(width: 8),
          _SyncButton(controller: syncController),
        ],
      ),
    );
  }
}

// ── Animated Sync Button ──────────────────────────────────────────────────────

class _SyncButton extends ConsumerWidget {
  final AnimationController controller;
  const _SyncButton({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.refresh(manualSyncProvider);
        controller.repeat();
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, child) => Transform.rotate(
          angle: controller.value * 6.28,
          child: child,
        ),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            boxShadow: AppShadows.coloredPrimary,
          ),
          child: const Icon(Icons.sync_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ============================================================================
// Stat Grid
// ============================================================================

class _StatGrid extends ConsumerWidget {
  final bool isTablet;
  final bool isDark;
  final List<Animation<double>> statSlides;
  final List<Animation<double>> statFades;

  const _StatGrid({
    required this.isTablet,
    required this.isDark,
    required this.statSlides,
    required this.statFades,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsAsync = ref.watch(patientsProvider(null));
    final householdsAsync = ref.watch(householdsNotifierProvider);
    final pendingSyncAsync = ref.watch(pendingSyncCountProvider);
    final caseReportsAsync = ref.watch(caseReportsProvider);

    String val(AsyncValue<dynamic> av, {bool isCount = false}) {
      return av.when(
        data: (d) {
          if (isCount) return (d as int).toString();
          return (d as List).length.toString();
        },
        loading: () => '…',
        error: (_, __) => '-',
      );
    }

    final stats = [
      _StatData(
        icon: Icons.people_rounded,
        label: 'Patients',
        value: val(patientsAsync),
        color: AppColors.statPatients,
      ),
      _StatData(
        icon: Icons.medical_services_rounded,
        label: 'Consultations',
        value: val(caseReportsAsync),
        color: AppColors.statConsultations,
      ),
      _StatData(
        icon: Icons.home_rounded,
        label: 'Ménages',
        value: val(householdsAsync),
        color: AppColors.statHouseholds,
      ),
      _StatData(
        icon: Icons.sync_rounded,
        label: 'En attente',
        value: val(pendingSyncAsync, isCount: true),
        color: AppColors.statPending,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isTablet ? 1.25 : 1.1,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: statFades[index],
        builder: (_, child) => Opacity(
          opacity: statFades[index].value,
          child: Transform.translate(
            offset: Offset(0, statSlides[index].value),
            child: child,
          ),
        ),
        child: _StatCard(data: stats[index], isDark: isDark),
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatCard extends StatefulWidget {
  final _StatData data;
  final bool isDark;
  const _StatCard({required this.data, required this.isDark});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.97))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.card(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            children: [
              // Body
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon chip
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.data.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(
                        widget.data.icon,
                        color: widget.data.color,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    // Value — FittedBox prevents overflow at large text scales
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.data.value,
                        style: GoogleFonts.syne(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: widget.data.color,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Label
                    Text(
                      widget.data.label,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Bottom color bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: widget.data.color,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppRadius.lg),
                      bottomRight: Radius.circular(AppRadius.lg),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Quick Actions
// ============================================================================

class _QuickActionsSection extends StatelessWidget {
  final bool isDark;
  const _QuickActionsSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        icon: Icons.person_add_rounded,
        label: 'Nouveau Patient',
        sub: 'Ajouter un patient',
        color: AppColors.actionPatient,
        onTap: (ctx) => ctx.push('/patients/create'),
      ),
      _ActionData(
        icon: Icons.home_work_rounded,
        label: 'Nouveau Ménage',
        sub: 'Recenser un foyer',
        color: AppColors.actionHousehold,
        onTap: (ctx) => ctx.push('/households/create'),
      ),
      _ActionData(
        icon: Icons.assignment_add,
        label: 'Nouveau Rapport',
        sub: 'Créer un rapport',
        color: AppColors.actionReport,
        onTap: (ctx) => ctx.push('/triage/create'),
      ),
      _ActionData(
        icon: Icons.warning_amber_rounded,
        label: 'Cas Urgent',
        sub: 'Alerte immédiate',
        color: AppColors.actionUrgent,
        onTap: (ctx) => ScaffoldMessenger.of(ctx)
            .showSnackBar(const SnackBar(content: Text('Fonctionnalité à venir'))),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Actions rapides', isDark: isDark),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.0,
          children: actions
              .map((a) => _ActionTile(data: a, isDark: isDark))
              .toList(),
        ),
      ],
    );
  }
}

class _ActionData {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final void Function(BuildContext ctx) onTap;
  const _ActionData({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });
}

class _ActionTile extends StatefulWidget {
  final _ActionData data;
  final bool isDark;
  const _ActionTile({required this.data, required this.isDark});

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.data.onTap(context);
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          transform: Matrix4.translationValues(
            0,
            _pressed ? 1 : (_hovered ? -2 : 0),
            0,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hovered || _pressed
                  ? widget.data.color.withOpacity(0.4)
                  : borderColor,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.data.color.withOpacity(0.20),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: -4,
                    ),
                  ]
                : AppShadows.card(context),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(widget.data.icon, color: widget.data.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.label,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.data.sub,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Activity Section
// ============================================================================

class _ActivitySection extends StatelessWidget {
  final bool isDark;
  final List<Animation<double>> actSlides;
  final List<Animation<double>> actFades;

  const _ActivitySection({
    required this.isDark,
    required this.actSlides,
    required this.actFades,
  });

  @override
  Widget build(BuildContext context) {
    final activities = [
      _ActivityItem(
        icon: Icons.check_circle_rounded,
        text: 'Synchronisation terminée',
        time: "À l'instant",
        color: AppColors.success,
        badge: 'Succès',
      ),
      _ActivityItem(
        icon: Icons.login_rounded,
        text: 'Connexion réussie',
        time: 'Il y a 2 min',
        color: AppColors.primary,
        badge: 'Auth',
      ),
      _ActivityItem(
        icon: Icons.cloud_done_rounded,
        text: 'Données mises à jour',
        time: 'Il y a 15 min',
        color: AppColors.secondary,
        badge: 'Sync',
      ),
    ];

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Activité récente', isDark: isDark),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
            boxShadow: AppShadows.card(context),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: activities.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 0.5,
              indent: 60,
              color: borderColor,
            ),
            itemBuilder: (ctx, i) {
              final a = activities[i];
              return AnimatedBuilder(
                animation: actFades[i],
                builder: (_, child) => Opacity(
                  opacity: actFades[i].value,
                  child: Transform.translate(
                    offset: Offset(actSlides[i].value, 0),
                    child: child,
                  ),
                ),
                child: _ActivityRow(item: a, isDark: isDark),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final String text;
  final String time;
  final Color color;
  final String badge;
  const _ActivityItem({
    required this.icon,
    required this.text,
    required this.time,
    required this.color,
    required this.badge,
  });
}

class _ActivityRow extends StatelessWidget {
  final _ActivityItem item;
  final bool isDark;
  const _ActivityRow({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(item.icon, color: item.color, size: 18),
      ),
      title: Text(
        item.text,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              item.badge,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: item.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
