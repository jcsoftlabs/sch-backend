import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'breakpoints.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Navigation destination data
class NavigationDestinationData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationDestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Adaptive navigation — phones get BottomNav, tablets get PremiumSidebar
class AdaptiveNavigation extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<NavigationDestinationData> destinations;
  final Widget body;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenType = context.screenType;

    switch (screenType) {
      case ScreenType.mobile:
        return _buildMobileLayout(context);
      case ScreenType.tablet:
      case ScreenType.desktop:
        return _buildTabletLayout(context, ref);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations
            .map((dest) => NavigationDestination(
                  icon: Icon(dest.icon, size: 22),
                  selectedIcon:
                      Icon(dest.selectedIcon, size: 22, color: AppColors.primary),
                  label: dest.label,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return Scaffold(
      body: Row(
        children: [
          _PremiumSidebar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations,
            userName: authState.user?.name,
            userRole: authState.user?.role,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ============================================================================
// Premium Sidebar
// ============================================================================

class _PremiumSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final List<NavigationDestinationData> destinations;
  final String? userName;
  final String? userRole;

  const _PremiumSidebar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.userName,
    this.userRole,
  });

  @override
  State<_PremiumSidebar> createState() => _PremiumSidebarState();
}

class _PremiumSidebarState extends State<_PremiumSidebar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _onlineIndicatorController;

  @override
  void initState() {
    super.initState();
    _onlineIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _onlineIndicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg =
        isDark ? AppColors.darkSidebar : AppColors.lightSidebar;
    final divColor =
        isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.07);

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Logo ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'ASCP-Connect',
                      style: GoogleFonts.syne(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Divider(color: divColor, height: 1),
            ),

            // ── Nav Items ───────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: widget.destinations.length,
                itemBuilder: (context, index) =>
                    _SidebarNavItem(
                  dest: widget.destinations[index],
                  isSelected: index == widget.selectedIndex,
                  onTap: () => widget.onDestinationSelected(index),
                  isDark: isDark,
                ),
              ),
            ),

            // ── Doctor Profile Card ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Divider(color: divColor, height: 1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: _DoctorProfileCard(
                name: widget.userName ?? 'Agent ASCP',
                role: widget.userRole ?? 'Agent',
                isDark: isDark,
                onlineAnimation: _onlineIndicatorController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Nav Item ──────────────────────────────────────────────────────────────────

class _SidebarNavItem extends StatefulWidget {
  final NavigationDestinationData dest;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _SidebarNavItem({
    required this.dest,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isDark = widget.isDark;

    final textColor = isSelected
        ? (isDark ? Colors.white : AppColors.primary)
        : (isDark
            ? Colors.white.withOpacity(0.55)
            : AppColors.lightTextSecondary);
    final iconColor = isSelected
        ? (isDark ? Colors.white : AppColors.primary)
        : (isDark
            ? Colors.white.withOpacity(0.45)
            : AppColors.lightTextMuted);
    final bgColor = isSelected
        ? AppColors.primary.withOpacity(isDark ? 0.15 : 0.08)
        : _hovered
            ? AppColors.primary.withOpacity(0.05)
            : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                // Active vertical bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 3,
                  height: 20,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                Icon(
                  isSelected ? widget.dest.selectedIcon : widget.dest.icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.dest.label,
                    style: GoogleFonts.dmSans(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
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

// ── Doctor Profile Card ───────────────────────────────────────────────────────

class _DoctorProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final bool isDark;
  final AnimationController onlineAnimation;

  const _DoctorProfileCard({
    required this.name,
    required this.role,
    required this.isDark,
    required this.onlineAnimation,
  });

  String _formatRole(String role) {
    switch (role.toUpperCase()) {
      case 'DOCTOR':
        return 'Médecin';
      case 'NURSE':
        return 'Infirmier(ère)';
      case 'AGENT':
        return 'Agent ASCP';
      case 'ADMIN':
        return 'Administrateur';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor =
        isDark ? AppColors.darkSurface : Colors.white;
    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'A';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.syne(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: onlineAnimation,
                      builder: (_, __) => AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            AppColors.success,
                            AppColors.success.withOpacity(0.4),
                            onlineAnimation.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _formatRole(role),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
