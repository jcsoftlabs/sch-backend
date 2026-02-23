import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// Design Tokens
// ============================================================================

class AppRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double full = 999;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppShadows {
  static List<BoxShadow> card(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.35)
            : Colors.black.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> elevated(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withOpacity(0.5)
            : Colors.black.withOpacity(0.10),
        blurRadius: 30,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> coloredPrimary = [
    BoxShadow(
      color: const Color(0xFF3B82F6).withOpacity(0.35),
      blurRadius: 20,
      offset: const Offset(0, 6),
      spreadRadius: -4,
    ),
  ];
}

// ============================================================================
// Color Constants (brand + semantic)
// ============================================================================

class AppColors {
  // Brand
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF06B6D4);

  // Stat Accents
  static const Color statPatients = Color(0xFF3B82F6);
  static const Color statConsultations = Color(0xFF10B981);
  static const Color statHouseholds = Color(0xFFF59E0B);
  static const Color statPending = Color(0xFF8B5CF6);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Urgency
  static const Color urgencyNormal = Color(0xFF10B981);
  static const Color urgencyUrgent = Color(0xFFF59E0B);
  static const Color urgencyCritical = Color(0xFFEF4444);

  // Quick Actions
  static const Color actionPatient = Color(0xFF3B82F6);
  static const Color actionHousehold = Color(0xFFF59E0B);
  static const Color actionReport = Color(0xFF10B981);
  static const Color actionUrgent = Color(0xFFF43F5E);

  // Light mode surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSidebar = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF374151); // WCAG AA ✅
  static const Color lightTextMuted = Color(0xFF64748B);    // WCAG AA ✅ (was #94A3B8, ratio ~2.8)

  // Dark mode surfaces
  static const Color darkBackground = Color(0xFF0B0F1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkSidebar = Color(0xFF0D1220);
  static const Color darkBorder = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF4B5563);

  // Legacy aliases (keep existing code working)
  static const Color primaryBlue = primary;
  static const Color primaryBlueDark = primaryDark;
  static const Color accentTeal = secondary;
  static const Color sidebarDark = Color(0xFF0F172A);
  static const Color sidebarSurface = Color(0xFF1E293B);
  static const Color backgroundLight = lightBackground;
  static const Color backgroundCard = lightSurface;
  static const Color backgroundMuted = Color(0xFFF1F5F9);
  static const Color textDark = lightTextPrimary;
  static const Color textMedium = lightTextSecondary;
  static const Color textLight = lightTextMuted;
  static const Color textMute = Color(0xFFCBD5E1);
}

// Keep backward-compat alias
typedef AppTheme = _AppTheme;

class _AppTheme {
  // ── Legacy static colour references (keep existing code compiling) ──────────
  static const Color primaryBlue = AppColors.primary;
  static const Color primaryBlueDark = AppColors.primaryDark;
  static const Color accentTeal = AppColors.secondary;
  static const Color sidebarDark = AppColors.sidebarDark;
  static const Color sidebarSurface = AppColors.sidebarSurface;
  static const Color backgroundLight = AppColors.lightBackground;
  static const Color backgroundCard = AppColors.lightSurface;
  static const Color backgroundMuted = AppColors.backgroundMuted;
  static const Color textDark = AppColors.lightTextPrimary;
  static const Color textMedium = AppColors.lightTextSecondary;
  static const Color textLight = AppColors.lightTextMuted;
  static const Color textMute = AppColors.textMute;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color error = AppColors.error;
  static const Color info = AppColors.info;
  static const Color urgencyNormal = AppColors.urgencyNormal;
  static const Color urgencyUrgent = AppColors.urgencyUrgent;
  static const Color urgencyCritical = AppColors.urgencyCritical;
  static const Color statPatients = AppColors.statPatients;
  static const Color statConsultations = AppColors.statConsultations;
  static const Color statHouseholds = AppColors.statHouseholds;
  static const Color statPending = AppColors.statPending;

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ── Text Styles ────────────────────────────────────────────────────────────
  static TextStyle headingStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
  }) =>
      GoogleFonts.syne(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) =>
      GoogleFonts.dmSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  // ── Base TextTheme (DM Sans body, Syne display) ────────────────────────────
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      // ── Display (Syne) ───────────────────────────────────────────────────
      displayLarge: GoogleFonts.syne(
        fontSize: 48, fontWeight: FontWeight.w800, color: textColor,
        letterSpacing: -1,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 36, fontWeight: FontWeight.w700, color: textColor,
        letterSpacing: -0.8,
      ),
      displaySmall: GoogleFonts.syne(
        fontSize: 28, fontWeight: FontWeight.w700, color: textColor,
        letterSpacing: -0.5,
      ),
      headlineLarge: GoogleFonts.syne(
        fontSize: 22, fontWeight: FontWeight.w700, color: textColor,
      ),
      headlineMedium: GoogleFonts.syne(
        fontSize: 19, fontWeight: FontWeight.w700, color: textColor,
      ),
      headlineSmall: GoogleFonts.syne(
        fontSize: 17, fontWeight: FontWeight.w700, color: textColor,
      ),
      // ── Titles (DM Sans, larger for field legibility) ────────────────────
      titleLarge: GoogleFonts.dmSans(
        fontSize: 17, fontWeight: FontWeight.w600, color: textColor,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: textColor,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 15, fontWeight: FontWeight.w500, color: textColor,
      ),
      // ── Body (DM Sans, 16px minimum for outdoor readability) ─────────────
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 17, fontWeight: FontWeight.w400, color: textColor,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w400, color: textColor,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 14, fontWeight: FontWeight.w400, color: textColor,
      ),
      // ── Labels ──────────────────────────────────────────────────────────
      labelLarge: GoogleFonts.dmSans(
        fontSize: 15, fontWeight: FontWeight.w600, color: textColor,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w600, color: textColor,
        letterSpacing: 0.2,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w500, color: textColor,
        letterSpacing: 0.3,
      ),
    );
  }

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        width: 400, // Constrain width on tablets
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: GoogleFonts.dmSans(
          color: AppColors.lightSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: _buildTextTheme(
        ThemeData.light().textTheme,
        AppColors.lightTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.04),
        titleTextStyle: GoogleFonts.syne(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.lightTextMuted),
        labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 0.5,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundMuted,
        labelStyle: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }

  // ── Dark Theme ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        width: 400, // Constrain width on tablets
        backgroundColor: AppColors.darkTextPrimary,
        contentTextStyle: GoogleFonts.dmSans(
          color: AppColors.darkSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: _buildTextTheme(
        ThemeData.dark().textTheme,
        AppColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: GoogleFonts.syne(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.darkTextMuted),
        labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 0.5,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        labelStyle: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
