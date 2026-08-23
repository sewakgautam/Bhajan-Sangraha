import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/bhajan.dart';
import '../models/category.dart';
import '../models/festival.dart';
import '../models/greeting.dart';
import '../services/auth_service.dart';
import '../services/bookmark_service.dart';
import '../services/festival_service.dart';
import '../services/greeting_service.dart';
import '../services/hive_service.dart';
import '../services/prefs_service.dart';
import '../services/sync_service.dart';
import '../widgets/bhajan_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/festival_banner.dart';
import '../widgets/branded_app_bar_title.dart';
import '../widgets/greeting_card.dart';
import '../widgets/native_ad_card.dart';
import '../widgets/sign_in_banner.dart';
import 'bhajan_detail_screen.dart';
import 'search_screen.dart';

/// One native ad is blended in after every this-many bhajan rows.
const _nativeAdInterval = 8;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategoryId;

  /// Picked once per screen lifetime (app launch), not on every rebuild —
  /// otherwise it would flicker to a new greeting on unrelated state
  /// changes like a bookmark toggle.
  late final Greeting _greeting = GreetingService.instance.randomGreeting();

  List<Category> get _categories {
    final categories = HiveService.instance.getCategories();
    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }

  List<Bhajan> get _filteredBhajans {
    final all = HiveService.instance.getAllBhajans()
      ..sort((a, b) => a.number.compareTo(b.number));
    if (_selectedCategoryId == null) return all;
    return all.where((b) => b.category == _selectedCategoryId).toList();
  }

  String _categoryLabel(BuildContext context, String categoryId) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';
    for (final category in _categories) {
      if (category.id == categoryId) {
        return isNepali ? category.nameDevanagari : category.nameEnglish;
      }
    }
    return categoryId;
  }

  String _festivalName(BuildContext context, Festival festival) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';
    return isNepali ? festival.nameDevanagari : festival.nameEnglish;
  }

  String _greetingName(BuildContext context, Greeting greeting) {
    final isNepali = Localizations.localeOf(context).languageCode == 'ne';
    return isNepali ? greeting.nameDevanagari : greeting.nameEnglish;
  }

  Future<void> _onRefresh() async {
    await SyncService.instance.forceRefresh();
    setState(() {});
  }

  /// Bookmarking requires sign-in. Returns the signed-in uid, signing the
  /// user in first if needed; null if they cancelled or sign-in failed.
  Future<String?> _ensureSignedInUid() async {
    final existing = AuthService.instance.currentUser;
    if (existing != null) return existing.uid;

    try {
      final user = await AuthService.instance.signInWithGoogle();
      if (user == null) return null;
      await BookmarkService.instance.reconcile(user.uid);
      await PrefsService.instance.syncFontSizeOnSignIn(user.uid);
      if (!mounted) return user.uid;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.signedInAndSynced(user.displayName ?? ''))),
      );
      return user.uid;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.signInFailed)),
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final categories = _categories;
    final bhajans = _filteredBhajans;
    final activeFestival = FestivalService.instance.activeFestival();

    return Scaffold(
      appBar: AppBar(
        title: BrandedAppBarTitle(title: l10n.appTitle),
        // A soft saffron glow behind the wordmark plus a fine gold hairline
        // below — a temple-lamp warmth instead of a flat Material app bar.
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.7, -1.6),
              radius: 1.6,
              colors: [colorScheme.primary.withValues(alpha: 0.12), Colors.transparent],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: colorScheme.tertiary.withValues(alpha: 0.35)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleIconButton(
              icon: Icons.search,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GreetingCard(
            greeting: _greeting,
            greetingName: _greetingName(context, _greeting),
            categoryLabel: _categoryLabel(context, _greeting.categoryId),
            onTap: () => setState(() => _selectedCategoryId = _greeting.categoryId),
          ),
          if (AuthService.instance.currentUser == null)
            SignInBanner(
              onSignIn: () async {
                await _ensureSignedInUid();
                if (mounted) setState(() {});
              },
            ),
          if (activeFestival != null)
            FestivalBanner(
              festival: activeFestival,
              festivalName: _festivalName(context, activeFestival),
              categoryLabel: _categoryLabel(context, activeFestival.categoryId),
              onTap: () => setState(() => _selectedCategoryId = activeFestival.categoryId),
            ),
          CategoryChips(
            categories: categories,
            selectedCategoryId: _selectedCategoryId,
            onSelected: (id) => setState(() => _selectedCategoryId = id),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: bhajans.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(child: Text(l10n.noBhajansYet)),
                      ],
                    )
                  : ListView.builder(
                      // One extra row per full interval of bhajans, for the
                      // native ad slotted in after it.
                      itemCount:
                          bhajans.length + (bhajans.length ~/ _nativeAdInterval),
                      itemBuilder: (context, index) {
                        final adsBeforeThisRow = index ~/ (_nativeAdInterval + 1);
                        if ((index + 1) % (_nativeAdInterval + 1) == 0) {
                          return const NativeAdCard();
                        }
                        final bhajanIndex = index - adsBeforeThisRow;
                        final bhajan = bhajans[bhajanIndex];
                        final signedInUid = AuthService.instance.currentUser?.uid;
                        return BhajanCard(
                          bhajan: bhajan,
                          categoryLabel: _categoryLabel(context, bhajan.category),
                          isBookmarked: signedInUid != null &&
                              BookmarkService.instance
                                  .isBookmarked(bhajan.id, uid: signedInUid),
                          onBookmarkToggle: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final uid = await _ensureSignedInUid();
                            if (uid == null) return;
                            final nowBookmarked =
                                await BookmarkService.instance.toggle(bhajan.id, uid: uid);
                            if (!mounted) return;
                            setState(() {});
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  nowBookmarked ? l10n.bookmarkAdded : l10n.bookmarkRemoved,
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BhajanDetailScreen(
                                  bhajans: bhajans,
                                  initialIndex: bhajanIndex,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
