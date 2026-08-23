import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/bookmark_service.dart';
import '../services/hive_service.dart';
import '../services/prefs_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bhajan_card.dart';
import '../widgets/branded_app_bar_title.dart';
import 'bhajan_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  Future<void> _signIn() async {
    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user == null) return; // cancelled by user
      await BookmarkService.instance.reconcile(user.uid);
      await PrefsService.instance.syncFontSizeOnSignIn(user.uid);
      if (!mounted) return;
      setState(() {});
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

  String _categoryLabel(BuildContext context, String categoryId) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';
    for (final category in HiveService.instance.getCategories()) {
      if (category.id == categoryId) {
        return isNepali ? category.nameDevanagari : category.nameEnglish;
      }
    }
    return categoryId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uid = AuthService.instance.currentUser?.uid;
    final devanagariTextTheme = AppTheme.devanagariTextTheme(Theme.of(context).textTheme);
    final appBarTitle = BrandedAppBarTitle(
      title: l10n.navBookmarks,
      style: devanagariTextTheme.headlineSmall,
    );

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: appBarTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_border,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.signInToViewBookmarks,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                FilledButton(onPressed: _signIn, child: Text(l10n.signIn)),
              ],
            ),
          ),
        ),
      );
    }

    final bhajanById = {
      for (final bhajan in HiveService.instance.getAllBhajans()) bhajan.id: bhajan,
    };
    final bookmarks = BookmarkService.instance.getAll(uid: uid)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final bookmarkedBhajans = [
      for (final bookmark in bookmarks)
        if (bhajanById[bookmark.bhajanId] != null) bhajanById[bookmark.bhajanId]!,
    ];

    return Scaffold(
      appBar: AppBar(title: appBarTitle),
      body: bookmarkedBhajans.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noBookmarksYet,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          : ReorderableListView.builder(
              itemCount: bookmarkedBhajans.length,
              onReorderItem: (oldIndex, newIndex) async {
                final reordered = [...bookmarkedBhajans];
                final moved = reordered.removeAt(oldIndex);
                reordered.insert(newIndex, moved);
                await BookmarkService.instance.reorder(
                  [for (final bhajan in reordered) bhajan.id],
                  uid: uid,
                );
                if (mounted) setState(() {});
              },
              itemBuilder: (context, index) {
                final bhajan = bookmarkedBhajans[index];
                return BhajanCard(
                  key: ValueKey(bhajan.id),
                  bhajan: bhajan,
                  categoryLabel: _categoryLabel(context, bhajan.category),
                  isBookmarked: true,
                  onBookmarkToggle: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final nowBookmarked =
                        await BookmarkService.instance.toggle(bhajan.id, uid: uid);
                    if (!mounted) return;
                    setState(() {});
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(nowBookmarked ? l10n.bookmarkAdded : l10n.bookmarkRemoved),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BhajanDetailScreen(
                          bhajans: bookmarkedBhajans,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
