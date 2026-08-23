import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/bookmark_service.dart';
import '../services/prefs_service.dart';
import '../theme/app_theme.dart';
import '../widgets/branded_app_bar_title.dart';
import '../widgets/font_controls.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _fontSize = PrefsService.instance.getFontSize();

  Future<void> _signIn() async {
    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user == null) return; // cancelled by user
      await BookmarkService.instance.reconcile(user.uid);
      await PrefsService.instance.syncFontSizeOnSignIn(user.uid);
      if (!mounted) return;
      setState(() => _fontSize = PrefsService.instance.getFontSize());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.signedInAndSynced(user.displayName ?? ''),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.signInFailed)),
      );
    }
  }

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await AuthService.instance.signOut();
    if (mounted) setState(() {});
  }

  void _setFontSize(double size) {
    setState(() => _fontSize = size);
    PrefsService.instance.setFontSize(size, uid: AuthService.instance.currentUser?.uid);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = AuthService.instance.currentUser;
    final devanagariTextTheme = AppTheme.devanagariTextTheme(Theme.of(context).textTheme);

    return Scaffold(
      appBar: AppBar(
        title: BrandedAppBarTitle(
          title: l10n.navSettings,
          style: devanagariTextTheme.headlineSmall,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              user != null ? (user.displayName ?? user.email ?? l10n.signIn) : l10n.notSignedIn,
            ),
            subtitle: user != null ? Text(user.email ?? '') : null,
            trailing: user == null
                ? FilledButton(onPressed: _signIn, child: Text(l10n.signIn))
                : null,
          ),
          if (user != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.signOut),
              onTap: _signOut,
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.fontSize, style: Theme.of(context).textTheme.titleMedium),
                FontControls(fontSize: _fontSize, onChanged: _setFontSize),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AnimatedBuilder(
              animation: ThemeController.instance,
              builder: (context, _) => SegmentedButton<ThemeMode>(
                style: SegmentedButton.styleFrom(minimumSize: const Size(0, 48)),
                segments: [
                  ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
                  ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
                ],
                selected: {ThemeController.instance.mode},
                onSelectionChanged: (selection) =>
                    ThemeController.instance.setThemeMode(selection.first),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: AnimatedBuilder(
              animation: LocaleController.instance,
              builder: (context, _) => SegmentedButton<String>(
                style: SegmentedButton.styleFrom(minimumSize: const Size(0, 48)),
                segments: const [
                  ButtonSegment(value: 'ne', label: Text('नेपाली')),
                  ButtonSegment(value: 'en', label: Text('English')),
                ],
                selected: {LocaleController.instance.locale.languageCode},
                onSelectionChanged: (selection) =>
                    LocaleController.instance.setLocale(Locale(selection.first)),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/branding/logo.png',
                width: 40,
                height: 40,
              ),
            ),
            title: Text(l10n.about),
            subtitle: const Text('Bhajan Sangraha · v1.0.0'),
            // Debug-only: confirms the Crashlytics pipeline (Gradle plugin,
            // Firebase project wiring, upload) actually works end-to-end
            // without waiting on a real user to hit a real bug. Never
            // reachable in a release build.
            onLongPress: kDebugMode
                ? () => FirebaseCrashlytics.instance.crash()
                : null,
          ),
        ],
      ),
    );
  }
}
