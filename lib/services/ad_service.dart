import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob wiring for Bhajan Sangraha (app ID in AndroidManifest.xml).
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  /// Real "Below Banner" unit from the AdMob console — used for both
  /// banner placements (bottom nav strip and below the bhajan detail).
  static const String bannerAdUnitId = 'ca-app-pub-2688863535038451/2218635031';

  /// Real "Bhajan Native" unit from the AdMob console.
  static const String nativeAdUnitId = 'ca-app-pub-2688863535038451/9713981678';

  /// Devices that should only ever receive test creatives, even though the
  /// app now uses real ad unit IDs above. Tapping/viewing real ads from your
  /// own dev device counts as invalid traffic and risks an AdMob suspension.
  ///
  /// Run the app once, then search logcat for a line like "Use
  /// RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("ABCDEF..."))
  /// to get test ads on this device" and add that hex ID here.
  static const List<String> testDeviceIds = ['130C73ACAE91E7EBB39EB88DB545FDB7'];

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: testDeviceIds),
    );
  }
}
