import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Draft keys — one per form that supports auto-save
class DraftKeys {
  static const String patient = 'draft_patient';
  static const String household = 'draft_household';
  static const String caseReport = 'draft_case_report';
}

/// Lightweight service to auto-save and restore form drafts via SharedPreferences.
///
/// Usage:
///   final draft = DraftService(DraftKeys.patient);
///   await draft.init();                // call in initState
///   draft.scheduleSave({'firstName': '...'}); // call on form change
///   final data = draft.data;           // null if no draft
///   await draft.clear();               // call after successful submit
class DraftService {
  final String _key;

  Timer? _debounce;
  Map<String, dynamic>? _data;
  SharedPreferences? _prefs;

  DraftService(this._key);

  /// Must be called once in initState (await inside addPostFrameCallback).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_key);
    if (raw != null) {
      try {
        _data = json.decode(raw) as Map<String, dynamic>;
      } catch (_) {
        // Corrupted draft — ignore
        _data = null;
      }
    }
  }

  /// Returns the restored draft data, or null if none exists.
  Map<String, dynamic>? get data => _data;

  /// Whether a draft is available for restoration.
  bool get hasDraft => _data != null;

  /// Schedule a save with 2-second debounce.
  /// [snapshot] is a map of all current form field values.
  void scheduleSave(Map<String, dynamic> snapshot) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      await _prefs?.setString(_key, json.encode(snapshot));
    });
  }

  /// Immediately save (e.g., on page navigation away).
  Future<void> saveNow(Map<String, dynamic> snapshot) async {
    _debounce?.cancel();
    await _prefs?.setString(_key, json.encode(snapshot));
  }

  /// Clear the draft after a successful submit.
  Future<void> clear() async {
    _debounce?.cancel();
    await _prefs?.remove(_key);
    _data = null;
  }

  void dispose() {
    _debounce?.cancel();
  }
}
