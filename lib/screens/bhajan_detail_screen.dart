import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/bhajan.dart';
import '../services/auth_service.dart';
import '../services/bookmark_service.dart';
import '../services/prefs_service.dart';
import '../services/share_service.dart';
import '../theme/app_theme.dart';
import '../widgets/attribution_block.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/font_controls.dart';
import '../widgets/youtube_player_section.dart';

class BhajanDetailScreen extends StatefulWidget {
  const BhajanDetailScreen({
    super.key,
    required this.bhajans,
    this.initialIndex = 0,
  });

  /// The list this bhajan was opened from (home, a category filter,
  /// bookmarks, search results, ...) — swiping left/right moves within it.
  final List<Bhajan> bhajans;
  final int initialIndex;

  @override
  State<BhajanDetailScreen> createState() => _BhajanDetailScreenState();
}

class _BhajanDetailScreenState extends State<BhajanDetailScreen> {
  late double _fontSize;
  late ViewMode _viewMode;
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _fontSize = PrefsService.instance.getFontSize();
    _viewMode = PrefsService.instance.getViewMode();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _setFontSize(double size) {
    setState(() => _fontSize = size);
    PrefsService.instance.setFontSize(size, uid: AuthService.instance.currentUser?.uid);
  }

  void _setViewMode(ViewMode mode) {
    setState(() => _viewMode = mode);
    PrefsService.instance.setViewMode(mode);
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
      setState(() => _fontSize = PrefsService.instance.getFontSize());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.signedInAndSynced(user.displayName ?? ''),
          ),
        ),
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
    final bhajan = widget.bhajans[_currentIndex];
    final devanagariTextTheme =
        AppTheme.devanagariTextTheme(Theme.of(context).textTheme);
    final signedInUid = AuthService.instance.currentUser?.uid;

    final isBookmarked = signedInUid != null &&
        BookmarkService.instance.isBookmarked(bhajan.id, uid: signedInUid);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleIconButton(
            icon: Icons.chevron_left,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${bhajan.number}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
            ),
            Text(
              bhajan.titleDevanagari,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: devanagariTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        // Same warm glow + gold hairline treatment as the home app bar.
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
          CircleIconButton(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            accent: isBookmarked,
            tooltip: isBookmarked ? l10n.bookmarkRemove : l10n.bookmarkAdd,
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final uid = await _ensureSignedInUid();
              if (uid == null) return;
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
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: Icons.share,
            tooltip: l10n.shareTooltip,
            onPressed: () => ShareService.share(bhajan),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.fontSize,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      FontControls(
                        fontSize: _fontSize,
                        onChanged: _setFontSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ViewMode>(
                    showSelectedIcon: false,
                    expandedInsets: EdgeInsets.zero,
                    style: SegmentedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                      selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
                      side: BorderSide.none,
                    ),
                    segments: [
                      ButtonSegment(
                        value: ViewMode.devanagari,
                        label: Text(l10n.viewModeDevanagari),
                      ),
                      ButtonSegment(value: ViewMode.roman, label: Text(l10n.viewModeRoman)),
                      ButtonSegment(value: ViewMode.both, label: Text(l10n.viewModeBoth)),
                    ],
                    selected: {_viewMode},
                    onSelectionChanged: (selection) => _setViewMode(selection.first),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.bhajans.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final pageBhajan = widget.bhajans[index];
                  final youtubeUrl = pageBhajan.youtubeUrl;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (youtubeUrl != null && youtubeUrl.isNotEmpty) ...[
                          YoutubePlayerSection(
                            key: ValueKey(pageBhajan.id),
                            youtubeUrl: youtubeUrl,
                          ),
                          const SizedBox(height: 16),
                          _buildOrnament(context),
                          const SizedBox(height: 16),
                        ],
                        _buildLyrics(pageBhajan, devanagariTextTheme),
                      ],
                    ),
                  );
                },
              ),
            ),
            AttributionBlock(bhajan: bhajan),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  /// A thin gold hairline with a centered diamond mark — the manuscript-style
  /// separator used between the video and the lyrics, and between the
  /// Devanagari and Roman blocks in "both" view mode.
  Widget _buildOrnament(BuildContext context) {
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final line = Container(height: 1, color: tertiary.withValues(alpha: 0.3));
    return Row(
      children: [
        Expanded(child: line),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('◆', style: TextStyle(fontSize: 11, color: tertiary)),
        ),
        Expanded(child: line),
      ],
    );
  }

  Widget _buildLyrics(Bhajan bhajan, TextTheme devanagariTextTheme) {
    final colorScheme = Theme.of(context).colorScheme;
    final devanagariStyle =
        devanagariTextTheme.bodyLarge?.copyWith(fontSize: _fontSize, height: 1.85);
    final romanStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontSize: _fontSize * 0.85, height: 1.75, color: colorScheme.onSurfaceVariant);
    final meaningStyle = devanagariTextTheme.bodyMedium?.copyWith(
      fontSize: _fontSize * 0.85,
      height: 1.6,
      color: colorScheme.onSurface.withValues(alpha: 0.85),
    );

    final meaning = bhajan.meaningDevanagari;
    final meaningSection = (meaning == null || meaning.isEmpty)
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_outlined, size: 14, color: colorScheme.secondary),
                      const SizedBox(width: 6),
                      Text(
                        'अर्थ',
                        style: devanagariTextTheme.titleSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(meaning, style: meaningStyle),
                ],
              ),
            ),
          );

    final Widget lyricsText;
    switch (_viewMode) {
      case ViewMode.devanagari:
        lyricsText = Text(bhajan.lyricsDevanagari, style: devanagariStyle);
      case ViewMode.roman:
        lyricsText = Text(bhajan.lyricsRoman, style: romanStyle);
      case ViewMode.both:
        lyricsText = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bhajan.lyricsDevanagari, style: devanagariStyle),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: _buildOrnament(context),
            ),
            Text(bhajan.lyricsRoman, style: romanStyle),
          ],
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: lyricsText,
        ),
        meaningSection,
      ],
    );
  }
}
