import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class SignInBanner extends StatelessWidget {
  const SignInBanner({super.key, required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surface,
              border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.35)),
            ),
            child: Icon(Icons.cloud_sync_outlined, size: 15, color: colorScheme.tertiary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.signInToSync,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onSignIn,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            child: Text(l10n.signIn),
          ),
        ],
      ),
    );
  }
}
