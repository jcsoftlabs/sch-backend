import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── State ─────────────────────────────────────────────────────────────────────
class AccessibilityState {
  final bool highContrast;
  final bool portraitLock;
  final bool largeText; // textScaleFactor 1.2 vs system default

  const AccessibilityState({
    this.highContrast = false,
    this.portraitLock = false,
    this.largeText = false,
  });

  AccessibilityState copyWith({
    bool? highContrast,
    bool? portraitLock,
    bool? largeText,
  }) =>
      AccessibilityState(
        highContrast: highContrast ?? this.highContrast,
        portraitLock: portraitLock ?? this.portraitLock,
        largeText: largeText ?? this.largeText,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class AccessibilityNotifier extends Notifier<AccessibilityState> {
  static const _keyHighContrast = 'a11y_high_contrast';
  static const _keyPortraitLock = 'a11y_portrait_lock';
  static const _keyLargeText = 'a11y_large_text';

  @override
  AccessibilityState build() {
    _load();
    return const AccessibilityState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = AccessibilityState(
      highContrast: prefs.getBool(_keyHighContrast) ?? false,
      portraitLock: prefs.getBool(_keyPortraitLock) ?? false,
      largeText: prefs.getBool(_keyLargeText) ?? false,
    );
    state = s;
    _applyOrientation(s.portraitLock);
  }

  void _applyOrientation(bool portrait) {
    if (portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }

  Future<void> toggleHighContrast() async {
    final next = !state.highContrast;
    state = state.copyWith(highContrast: next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHighContrast, next);
  }

  Future<void> togglePortraitLock() async {
    final next = !state.portraitLock;
    state = state.copyWith(portraitLock: next);
    _applyOrientation(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPortraitLock, next);
  }

  Future<void> toggleLargeText() async {
    final next = !state.largeText;
    state = state.copyWith(largeText: next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLargeText, next);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final accessibilityProvider =
    NotifierProvider<AccessibilityNotifier, AccessibilityState>(
  AccessibilityNotifier.new,
);

// ── High-contrast color overrides ─────────────────────────────────────────────
/// Returns a ThemeData with boosted contrast for field use.
/// Keeps the same hue family but darkens muted colors and fattens fonts.
ThemeData applyHighContrast(ThemeData base) {
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      // Darker surface for better text contrast
      surface: base.brightness == Brightness.light
          ? const Color(0xFFF0F4F8)
          : const Color(0xFF0A0E14),
    ),
    textTheme: base.textTheme.apply(
      fontSizeFactor: 1.05,
    ),
    iconTheme: base.iconTheme.copyWith(size: 26),
  );
}
