import 'package:flutter/material.dart';

import '../models/bhajan.dart';
import '../theme/app_theme.dart';
import 'bookmark_button.dart';

class BhajanCard extends StatelessWidget {
  const BhajanCard({
    super.key,
    required this.bhajan,
    required this.categoryLabel,
    required this.onTap,
    this.isBookmarked,
    this.onBookmarkToggle,
  });

  final Bhajan bhajan;
  final String categoryLabel;
  final VoidCallback onTap;
  final bool? isBookmarked;
  final VoidCallback? onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final devanagariTextTheme =
        AppTheme.devanagariTextTheme(Theme.of(context).textTheme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                  border: Border.all(color: colorScheme.tertiary.withValues(alpha: 0.4), width: 1.25),
                ),
                child: Text(
                  '${bhajan.number}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bhajan.titleDevanagari,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: devanagariTextTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            bhajan.titleRoman,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        Text(
                          '  •  ',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                        Flexible(
                          child: Text(
                            categoryLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (bhajan.youtubeUrl != null && bhajan.youtubeUrl!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.smart_display_outlined,
                              size: 14, color: colorScheme.secondary),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (onBookmarkToggle != null) ...[
                const SizedBox(width: 4),
                BookmarkButton(
                  isBookmarked: isBookmarked ?? false,
                  onPressed: onBookmarkToggle!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
