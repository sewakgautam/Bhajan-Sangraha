import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'firebase_service.dart';
import 'hive_service.dart';

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  Future<void> firstRunSync() async {
    final bhajans = await FirebaseService.instance.fetchAllPublishedBhajans();
    final categories = await FirebaseService.instance.fetchAllCategories();
    final quotes = await FirebaseService.instance.fetchAllGitaQuotes();
    await HiveService.instance.upsertBhajans(bhajans);
    await HiveService.instance.setCategories(categories);
    await HiveService.instance.setGitaQuotes(quotes);
    await HiveService.instance
        .setLastSyncedAt(DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> incrementalSync() async {
    if (!await _hasConnectivity()) return;
    try {
      final lastSyncedAt = HiveService.instance.getLastSyncedAt() ?? 0;
      final updatedBhajans =
          await FirebaseService.instance.fetchBhajansUpdatedAfter(lastSyncedAt);
      final categories = await FirebaseService.instance.fetchAllCategories();
      final quotes = await FirebaseService.instance.fetchAllGitaQuotes();
      await HiveService.instance.upsertBhajans(updatedBhajans);
      await HiveService.instance.setCategories(categories);
      await HiveService.instance.setGitaQuotes(quotes);
      await HiveService.instance
          .setLastSyncedAt(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Incremental sync failed: $e');
    }
  }

  Future<void> forceRefresh() async {
    try {
      final bhajans = await FirebaseService.instance.fetchAllPublishedBhajans();
      final categories = await FirebaseService.instance.fetchAllCategories();
      final quotes = await FirebaseService.instance.fetchAllGitaQuotes();
      await HiveService.instance.upsertBhajans(bhajans);
      await HiveService.instance.setCategories(categories);
      await HiveService.instance.setGitaQuotes(quotes);
      await HiveService.instance
          .setLastSyncedAt(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Force refresh failed: $e');
    }
  }

  Future<bool> _hasConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
