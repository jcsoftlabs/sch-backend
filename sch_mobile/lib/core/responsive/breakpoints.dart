import 'package:flutter/material.dart';

/// Screen size categories based on Material Design breakpoints
enum ScreenType {
  mobile,   // < 600px
  tablet,   // 600px - 1024px
  desktop,  // >= 1024px
}

/// Breakpoint values for responsive design
class Breakpoints {
  // Breakpoint values
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  // Get screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return ScreenType.mobile;
    if (width < tablet) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  // Check if screen is at least a certain size
  static bool isAtLeast(BuildContext context, ScreenType type) {
    final currentType = getScreenType(context);
    return currentType.index >= type.index;
  }

  // Get responsive value based on screen type
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Extension methods for responsive design
extension ResponsiveExtensions on BuildContext {
  /// Check if current screen is mobile
  bool get isMobile => MediaQuery.of(this).size.width < Breakpoints.mobile;

  /// Check if current screen is tablet
  bool get isTablet =>
      MediaQuery.of(this).size.width >= Breakpoints.mobile &&
      MediaQuery.of(this).size.width < Breakpoints.tablet;

  /// Check if current screen is desktop
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.tablet;

  /// Get current screen type
  ScreenType get screenType => Breakpoints.getScreenType(this);

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get responsive padding
  EdgeInsets get responsivePadding {
    if (isMobile) return const EdgeInsets.all(16);
    if (isTablet) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  /// Get responsive horizontal padding
  EdgeInsets get responsiveHorizontalPadding {
    if (isMobile) return const EdgeInsets.symmetric(horizontal: 16);
    if (isTablet) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  /// Get responsive content max width
  double get contentMaxWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 800;
    return 1200;
  }

  /// Get number of grid columns
  int get gridColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }
}
