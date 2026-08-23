import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onPressed,
  });

  final bool isBookmarked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: isBookmarked ? l10n.bookmarkRemove : l10n.bookmarkAdd,
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Theme.of(context).colorScheme.tertiary : null,
      ),
      onPressed: onPressed,
    );
  }
}
