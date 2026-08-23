import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';

/// A native ad styled with Google's built-in "small" template — sized and
/// margined to match [BhajanCard] rows so it reads as part of the list
/// rather than a banner interruption. Collapses to nothing until loaded,
/// and again on failure.
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _nativeAd;
  bool _requestedThemedAd = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reads Theme.of(context), so the ad is themed correctly on first
    // build; guarded so a later theme change doesn't reload the ad mid-list.
    if (!_requestedThemedAd) {
      _requestedThemedAd = true;
      _loadAd();
    }
  }

  void _loadAd() {
    final colorScheme = Theme.of(context).colorScheme;
    final nativeAd = NativeAd(
      adUnitId: AdService.nativeAdUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: colorScheme.surfaceContainerHighest,
        cornerRadius: 16,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          style: NativeTemplateFontStyle.bold,
          size: 12,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          size: 12,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          size: 11,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _nativeAd = ad as NativeAd);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    nativeAd.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    if (ad == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(height: 100, child: AdWidget(ad: ad)),
    );
  }
}
