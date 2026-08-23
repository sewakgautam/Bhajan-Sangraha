import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/bhajan.dart';

class AttributionBlock extends StatelessWidget {
  const AttributionBlock({super.key, required this.bhajan});

  final Bhajan bhajan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <(String, String)>[
      if ((bhajan.sourceBook ?? '').isNotEmpty) (l10n.sourceBook, bhajan.sourceBook!),
      if ((bhajan.sourceAuthor ?? '').isNotEmpty) (l10n.sourceAuthor, bhajan.sourceAuthor!),
      if ((bhajan.sourcePublisher ?? '').isNotEmpty) (l10n.sourcePublisher, bhajan.sourcePublisher!),
      if ((bhajan.sourceYear ?? '').isNotEmpty) (l10n.sourceYear, bhajan.sourceYear!),
      if (bhajan.sourcePage != null) (l10n.sourcePage, '${bhajan.sourcePage}'),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        );
    final valueStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(text: '$label ', style: labelStyle),
                    TextSpan(text: value, style: valueStyle),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
