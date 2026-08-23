import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:hive/hive.dart';

import 'hive_service.dart';

enum ViewMode { devanagari, roman, both }

class PrefsService {
  PrefsService._();
  static final PrefsService instance = PrefsService._();

  static const double defaultFontSize = 18.0;
  static const double minFontSize = 14.0;
  static const double maxFontSize = 32.0;

  Box get _metaBox => HiveService.instance.metaBox;

  DocumentReference<Map<String, dynamic>> _remoteUserDoc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  double getFontSize() =>
      (_metaBox.get('font_size') as double?) ?? defaultFontSize;

  /// Writes locally first so the UI never waits on a network round-trip;
  /// when signed in, the value is also pushed to the account in the
  /// background so it follows the user across sign-outs and devices.
  Future<void> setFontSize(double size, {String? uid}) async {
    final clamped = size.clamp(minFontSize, maxFontSize);
    await _metaBox.put('font_size', clamped);
    if (uid != null) {
      unawaited(_pushFontSize(uid, clamped));
    }
  }

  Future<void> _pushFontSize(String uid, double size) async {
    try {
      await _remoteUserDoc(uid).set({'font_size': size}, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Font size sync failed: $e');
    }
  }

  /// Runs on sign-in: applies the font size saved to this account, if any,
  /// so a returning user gets their preference back on any device. If the
  /// account has no saved font size yet (first sign-in), pushes the current
  /// local value up instead so it becomes the account's baseline.
  Future<void> syncFontSizeOnSignIn(String uid) async {
    try {
      final doc = await _remoteUserDoc(uid).get();
      final remoteSize = (doc.data()?['font_size'] as num?)?.toDouble();
      if (remoteSize != null) {
        await _metaBox.put('font_size', remoteSize.clamp(minFontSize, maxFontSize));
      } else {
        await _pushFontSize(uid, getFontSize());
      }
    } catch (e) {
      debugPrint('Font size pull failed: $e');
    }
  }

  ViewMode getViewMode() {
    final value = _metaBox.get('view_mode') as String?;
    return ViewMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ViewMode.both,
    );
  }

  Future<void> setViewMode(ViewMode mode) async {
    await _metaBox.put('view_mode', mode.name);
  }

  ThemeMode getThemeMode() {
    final value = _metaBox.get('theme_mode') as String?;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _metaBox.put('theme_mode', mode.name);
  }

  /// App display language. Defaults to Nepali.
  Locale getLocale() {
    final value = _metaBox.get('app_locale') as String?;
    return Locale(value ?? 'ne');
  }

  Future<void> setLocale(Locale locale) async {
    await _metaBox.put('app_locale', locale.languageCode);
  }
}

/// Lets the Settings screen change the theme mode and have it take effect
/// immediately, without a state-management package — a plain ChangeNotifier.
class ThemeController extends ChangeNotifier {
  ThemeController._() : _mode = PrefsService.instance.getThemeMode();
  static final ThemeController instance = ThemeController._();

  ThemeMode _mode;
  ThemeMode get mode => _mode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    await PrefsService.instance.setThemeMode(mode);
  }
}

/// Lets the Settings screen change the app language and have it take effect
/// immediately, without a state-management package — a plain ChangeNotifier.
class LocaleController extends ChangeNotifier {
  LocaleController._() : _locale = PrefsService.instance.getLocale();
  static final LocaleController instance = LocaleController._();

  Locale _locale;
  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await PrefsService.instance.setLocale(locale);
  }
}
