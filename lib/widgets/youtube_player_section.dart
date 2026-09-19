import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../l10n/app_localizations.dart';

/// Lazy-loaded YouTube embed shown on the bhajan detail screen when a
/// bhajan has a `youtube_url`. Uses [YoutubePlayerThumbnail] so the WebView
/// (and network request) is only created after the user taps play — the
/// detail screen swipes through a whole list of bhajans via [PageView], so
/// eagerly building a player per page would be wasteful.
///
/// Shown as a full-width 16:9 preview card — tapping it plays inline within
/// that same card; the player's own fullscreen button (enabled below) is
/// how it's actually watched comfortably.
class YoutubePlayerSection extends StatefulWidget {
  const YoutubePlayerSection({super.key, required this.youtubeUrl});

  final String youtubeUrl;

  @override
  State<YoutubePlayerSection> createState() => _YoutubePlayerSectionState();
}

class _YoutubePlayerSectionState extends State<YoutubePlayerSection> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayerController.convertUrlToId(widget.youtubeUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayerThumbnail(
              controller: controller,
              thumbnailQuality: ThumbnailQuality.high,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.smart_display_outlined, size: 16, color: colorScheme.tertiary),
              const SizedBox(width: 6),
              Text(
                l10n.watchOnYoutube,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
