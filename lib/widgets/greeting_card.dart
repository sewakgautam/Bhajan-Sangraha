import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/greeting.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({
    super.key,
    required this.greeting,
    required this.greetingName,
    required this.categoryLabel,
    required this.onTap,
  });

  final Greeting greeting;
  final String greetingName;
  final String categoryLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.secondaryContainer, colorScheme.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondary.withValues(alpha: 0.10),
                ),
                child: Icon(
                  Icons.volunteer_activism_outlined,
                  size: 19,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetingName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      l10n.festivalCta(categoryLabel),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSecondaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
