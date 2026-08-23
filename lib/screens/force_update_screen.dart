import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

/// Full-screen, non-dismissible gate shown instead of the app when
/// [UpdateService] reports the installed build is below the configured
/// minimum. Its own standalone MaterialApp because it can be shown before
/// the rest of bootstrap (theme controller, locale, etc.) has run.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, required this.message, required this.storeUrl});

  final String message;
  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.system_update_rounded, size: 64),
                    const SizedBox(height: 20),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: () => launchUrl(
                        Uri.parse(storeUrl),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text('Update Now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
