import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/festival.dart';

class FestivalBanner extends StatelessWidget {
  const FestivalBanner({
    super.key,
    required this.festival,
    required this.festivalName,
    required this.categoryLabel,
    required this.onTap,
  });

  final Festival festival;
  final String festivalName;
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
          colors: [colorScheme.tertiaryContainer, colorScheme.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.16)),
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
                  color: colorScheme.tertiary.withValues(alpha: 0.12),
                ),
                child: Icon(
                  Icons.celebration_outlined,
                  size: 19,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.festivalGreeting(festivalName),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      l10n.festivalCta(categoryLabel),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onTertiaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
