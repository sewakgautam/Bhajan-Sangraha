import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateCheckResult {
  const UpdateCheckResult.ok() : mustUpdate = false, message = null, storeUrl = null;

  const UpdateCheckResult.blocked({required this.message, required this.storeUrl})
    : mustUpdate = true;

  final bool mustUpdate;
  final String? message;
  final String? storeUrl;
}

/// Gates app startup on a remotely-configured minimum build number, read
/// from Firestore `app_config/android` (fields: `min_build_number` (int),
/// `update_message` (string), `play_store_url` (string) — see README/ops
/// notes for how to publish a forced update).
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  static const String _defaultStoreUrl =
      'https://play.google.com/store/apps/details?id=com.pahadilabs.bhajan_sangraha';

  /// Any failure here (offline, missing config doc, bad data) resolves to
  /// "no update required" — this check must never be the reason someone
  /// can't open the app.
  Future<UpdateCheckResult> check() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('android')
          .get();
      final minBuild = doc.data()?['min_build_number'] as int?;
      if (minBuild == null) return const UpdateCheckResult.ok();

      final info = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(info.buildNumber) ?? 0;
      if (currentBuild >= minBuild) return const UpdateCheckResult.ok();

      return UpdateCheckResult.blocked(
        message: (doc.data()?['update_message'] as String?) ??
            'A new version of Bhajan Sangraha is required to continue.',
        storeUrl: (doc.data()?['play_store_url'] as String?) ?? _defaultStoreUrl,
      );
    } catch (_) {
      return const UpdateCheckResult.ok();
    }
  }
}
