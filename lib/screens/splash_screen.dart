import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  Future<void> _sync() async {
    setState(() => _failed = false);
    try {
      await SyncService.instance.firstRunSync();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RootShell()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devanagariTextTheme =
        AppTheme.devanagariTextTheme(Theme.of(context).textTheme);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/branding/logo.png',
                width: 140,
                height: 140,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'भजन संग्रह',
              style: devanagariTextTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            if (_failed)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.syncFailedMessage),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _sync,
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              )
            else
              CircularProgressIndicator(color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
