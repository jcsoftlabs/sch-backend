import 'package:flutter/material.dart';
import 'breakpoints.dart';

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

/// Adaptive navigation that switches between BottomNavigationBar, NavigationRail, and NavigationDrawer
class AdaptiveNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenType = context.screenType;

    switch (screenType) {
      case ScreenType.mobile:
        return _buildMobileLayout(context);
      case ScreenType.tablet:
        return _buildTabletLayout(context);
      case ScreenType.desktop:
        return _buildDesktopLayout(context);
    }
  }

  // Mobile: Bottom Navigation Bar
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map((dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  selectedIcon: Icon(dest.selectedIcon),
                  label: dest.label,
                ))
            .toList(),
      ),
    );
  }

  // Tablet: Navigation Rail
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: destinations
                .map((dest) => NavigationRailDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(dest.selectedIcon),
                      label: Text(dest.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  // Desktop: Permanent Navigation Drawer
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
                child: Text(
                  'ASCP-Connect',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ...destinations.map((dest) => NavigationDrawerDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.selectedIcon),
                    label: Text(dest.label),
                  )),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
