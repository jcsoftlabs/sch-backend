import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/accessibility_provider.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local notifications
  await NotificationService().init();
  // Default: allow all orientations (user can lock in settings)
  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a11y = ref.watch(accessibilityProvider);

    // Apply high-contrast overlay if enabled
    final lightTheme = a11y.highContrast
        ? applyHighContrast(AppTheme.lightTheme)
        : AppTheme.lightTheme;
    final darkTheme = a11y.highContrast
        ? applyHighContrast(AppTheme.darkTheme)
        : AppTheme.darkTheme;

    return MaterialApp.router(
      title: 'ASCP-Connect',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // Primary language
        Locale('en', 'US'), // Fallback
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      // ── Global text scale clamping ──────────────────────────────────────
      // Respects system accessibility settings but caps at 1.3×
      // so that layouts don't break in field conditions.
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        // Calculate a flattened scale factor to avoid ClampedTextScaler assertion chains in DatePickerDialog
        double currentScale = mediaQuery.textScaler.scale(1) / 1.0;
        final targetScale = a11y.largeText ? 1.2 : 1.0;
        if (currentScale < targetScale) currentScale = targetScale;
        if (currentScale > 1.3) currentScale = 1.3;
        
        final finalScaler = TextScaler.linear(currentScale);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: finalScaler),
          child: child!,
        );
      },
    );
  }
}
