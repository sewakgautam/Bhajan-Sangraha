import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/force_update_screen.dart';
import 'screens/gita_quotes_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart';
import 'services/auth_service.dart';
import 'services/bookmark_service.dart';
import 'services/festival_service.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'services/prefs_service.dart';
import 'services/sync_service.dart';
import 'services/update_service.dart';
import 'theme/app_theme.dart';
import 'widgets/banner_ad_widget.dart';
import 'widgets/bottom_nav.dart';

void main() {
  // Catches anything that reaches neither FlutterError.onError (framework
  // errors) nor PlatformDispatcher.onError (platform-dispatched async
  // errors) — e.g. errors thrown outside a Flutter callback. Firebase isn't
  // guaranteed to be initialized yet when one of these fires, so guard the
  // Crashlytics call.
  //
  // WidgetsFlutterBinding.ensureInitialized() and runApp() must run in this
  // same zone — calling ensureInitialized() outside runZonedGuarded (even
  // as the very first line of main()) trips Flutter's "Zone mismatch"
  // assertion, since the binding then belongs to the root zone while runApp
  // runs in this one.
  runZonedGuarded(() {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // Keeps the OS splash up past Flutter's first frame so there's no blank
    // flash before our own splash below takes over.
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    runApp(const _AppBootstrap());
  }, (error, stack) {
    if (Firebase.apps.isNotEmpty) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint('Uncaught error before Firebase init: $error\n$stack');
    }
  });
}

/// Renders our exact splash.jpg as Flutter's first frame, then swaps to the
/// real app once ready. Needed because Android 12+'s native splash API can
/// only show a small centered icon on a color — never an arbitrary fullscreen
/// image — so relying on the OS splash alone means most devices never see
/// the actual designed splash image at all.
class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  bool _ready = false;
  bool _hasBhajans = false;
  UpdateCheckResult? _forceUpdate;

  @override
  void initState() {
    super.initState();
    // Our splash below is now Flutter's first frame — hand off from the OS
    // splash to it immediately rather than waiting on init.
    WidgetsBinding.instance.addPostFrameCallback((_) => FlutterNativeSplash.remove());
    // Devotees read lyrics or watch an aarti video for minutes without
    // touching the screen — keep the display on for as long as the app is
    // in the foreground instead of letting the OS dim/lock it.
    unawaited(WakelockPlus.enable());
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Runs alongside init rather than after it, so we never wait longer than
    // necessary — total splash time is max(init time, 2s), not init time + 2s.
    final minSplashDuration = Future<void>.delayed(const Duration(seconds: 2));

    // ThemeController and LocaleController read Hive synchronously the
    // instant BhajanSangrahaApp first builds (see below), so Hive must be
    // ready before anything else runs — kept outside the try block below so
    // an unrelated failure there (flaky network on the update check or
    // Firestore) can never leave it uninitialized and take the whole app
    // down with it.
    await HiveService.instance.init();
    await HiveService.instance.migrateBookmarksIfNeeded();

    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      // Routes framework errors (widget build/layout/paint) to Crashlytics
      // as fatal from here on. Must come after Firebase init since
      // Crashlytics needs a live app to report through.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      final updateCheck = await UpdateService.instance.check();
      if (updateCheck.mustUpdate) {
        await minSplashDuration;
        if (!mounted) return;
        setState(() {
          _forceUpdate = updateCheck;
          _ready = true;
        });
        return;
      }

      unawaited(AdService.instance.initialize());
      await FestivalService.instance.loadFestivals();
      unawaited(NotificationService.instance.init());

      final hasBhajans = HiveService.instance.hasBhajans;
      if (hasBhajans) {
        unawaited(SyncService.instance.incrementalSync());
      }

      final currentUser = AuthService.instance.currentUser;
      if (currentUser != null) {
        unawaited(BookmarkService.instance.reconcile(currentUser.uid));
        // Awaited (unlike the bookmark reconcile above) so Settings and the
        // bhajan detail screen read the account's font size on their very
        // first build instead of flashing the device's last local value.
        await PrefsService.instance.syncFontSizeOnSignIn(currentUser.uid);
      }

      await minSplashDuration;
      if (!mounted) return;
      setState(() {
        _hasBhajans = hasBhajans;
        _ready = true;
      });
    } catch (error, stack) {
      // A failure anywhere above (bad festivals.json, Firebase init failure,
      // a flaky network call, ...) used to leave the app stuck on the splash
      // image forever with nothing recorded anywhere. Report it, then still
      // let the user through — RootShell/SplashScreen already handle an
      // empty or failed data state on their own. Hive itself is guaranteed
      // ready by this point (initialized above, outside this try block).
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      await minSplashDuration;
      if (!mounted) return;
      setState(() {
        _hasBhajans = false;
        _ready = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Must not touch ThemeController/LocaleController before Hive is ready —
    // they read from it synchronously on first access — so this stays a
    // plain, self-contained MaterialApp until _ready flips.
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SizedBox.expand(
            child: Image(
              image: AssetImage('assets/splash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    final forceUpdate = _forceUpdate;
    if (forceUpdate != null) {
      return ForceUpdateScreen(
        message: forceUpdate.message!,
        storeUrl: forceUpdate.storeUrl!,
      );
    }
    return BhajanSangrahaApp(hasBhajans: _hasBhajans);
  }
}

class BhajanSangrahaApp extends StatelessWidget {
  const BhajanSangrahaApp({super.key, required this.hasBhajans});

  final bool hasBhajans;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ThemeController.instance, LocaleController.instance]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Bhajan Sangraha',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeController.instance.mode,
          locale: LocaleController.instance.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: hasBhajans ? const RootShell() : const SplashScreen(),
        );
      },
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    const screens = [
      HomeScreen(),
      BookmarksScreen(),
      GitaQuotesScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          BottomNav(
            currentIndex: _index,
            onTap: (index) => setState(() => _index = index),
          ),
        ],
      ),
    );
  }
}
