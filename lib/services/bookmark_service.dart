import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/bookmark.dart';
import 'hive_service.dart';

class BookmarkService {
  BookmarkService._();
  static final BookmarkService instance = BookmarkService._();

  CollectionReference<Map<String, dynamic>> _remoteFor(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('bookmarks');

  /// The Hive bookmarks box is shared by every account that has ever signed
  /// in on this device, so every key must be namespaced by uid — otherwise
  /// one account can read or delete another account's bookmarks. No raw key
  /// construction outside this helper.
  String _scopedKey(String uid, String bhajanId) => '$uid:$bhajanId';

  /// Bookmarking requires sign-in, so bookmark state is only meaningful
  /// while signed in. Callers must check auth state before displaying it.
  bool isBookmarked(String bhajanId, {required String uid}) =>
      HiveService.instance.bookmarksBox.containsKey(_scopedKey(uid, bhajanId));

  List<Bookmark> getAll({required String uid}) {
    final box = HiveService.instance.bookmarksBox;
    final prefix = '$uid:';
    return [
      for (final key in box.keys)
        if (key.toString().startsWith(prefix)) box.get(key)!,
    ];
  }

  /// Persists a user-dragged reorder of the bookmarks list. Purely local
  /// display state — not synced remotely.
  Future<void> reorder(List<String> bhajanIdsInNewOrder, {required String uid}) async {
    final box = HiveService.instance.bookmarksBox;
    for (var i = 0; i < bhajanIdsInNewOrder.length; i++) {
      final bookmark = box.get(_scopedKey(uid, bhajanIdsInNewOrder[i]));
      if (bookmark == null || bookmark.sortOrder == i) continue;
      bookmark.sortOrder = i;
      await bookmark.save();
    }
  }

  /// Returns the resulting state — true if now bookmarked, false if removed —
  /// so callers can show the right confirmation without a second lookup.
  Future<bool> toggle(String bhajanId, {required String uid}) async {
    if (isBookmarked(bhajanId, uid: uid)) {
      await remove(bhajanId, uid: uid);
      return false;
    }
    await add(bhajanId, uid: uid);
    return true;
  }

  /// The local Hive write is all the UI needs to update instantly, so only
  /// that is awaited — the Firestore push runs in the background. Awaiting
  /// the network round-trip here was making every star tap feel laggy.
  Future<void> add(String bhajanId, {required String uid}) async {
    final box = HiveService.instance.bookmarksBox;
    final bookmark = Bookmark(
      bhajanId: bhajanId,
      bookmarkedAt: DateTime.now().millisecondsSinceEpoch,
      synced: false,
    );
    await box.put(_scopedKey(uid, bhajanId), bookmark);
    unawaited(_pushAdd(bhajanId, uid, bookmark));
  }

  Future<void> _pushAdd(String bhajanId, String uid, Bookmark bookmark) async {
    try {
      await _remoteFor(uid).doc(bhajanId).set({
        'bhajan_id': bhajanId,
        'bookmarked_at': FieldValue.serverTimestamp(),
      });
      bookmark.synced = true;
      await bookmark.save();
    } catch (e) {
      debugPrint('Bookmark sync failed for $bhajanId: $e');
    }
  }

  Future<void> remove(String bhajanId, {required String uid}) async {
    await HiveService.instance.bookmarksBox.delete(_scopedKey(uid, bhajanId));
    unawaited(_pushRemove(bhajanId, uid));
  }

  Future<void> _pushRemove(String bhajanId, String uid) async {
    try {
      await _remoteFor(uid).doc(bhajanId).delete();
    } catch (e) {
      final pending = HiveService.instance.getPendingDeletes();
      if (!pending.contains(bhajanId)) {
        await HiveService.instance.setPendingDeletes([...pending, bhajanId]);
      }
    }
  }

  /// Runs on sign-in and on app open while signed in: pushes unsynced local
  /// bookmarks, retries queued deletes, then unions in remote bookmarks that
  /// aren't present locally. Bookmarks are additive by nature — no vector
  /// clocks needed, last-write-wins is fine.
  Future<void> reconcile(String uid) async {
    final box = HiveService.instance.bookmarksBox;
    final remote = _remoteFor(uid);

    final pending = HiveService.instance.getPendingDeletes();
    final stillPending = <String>[];
    for (final bhajanId in pending) {
      try {
        await remote.doc(bhajanId).delete();
      } catch (e) {
        stillPending.add(bhajanId);
      }
    }
    await HiveService.instance.setPendingDeletes(stillPending);

    for (final bookmark in getAll(uid: uid).where((b) => !b.synced).toList()) {
      try {
        await remote.doc(bookmark.bhajanId).set({
          'bhajan_id': bookmark.bhajanId,
          'bookmarked_at': FieldValue.serverTimestamp(),
        });
        bookmark.synced = true;
        await bookmark.save();
      } catch (e) {
        debugPrint('Push bookmark failed for ${bookmark.bhajanId}: $e');
      }
    }

    try {
      final snapshot = await remote.get();
      for (final doc in snapshot.docs) {
        final key = _scopedKey(uid, doc.id);
        if (!box.containsKey(key)) {
          await box.put(
            key,
            Bookmark(
              bhajanId: doc.id,
              bookmarkedAt: DateTime.now().millisecondsSinceEpoch,
              synced: true,
            ),
          );
        }
      }
      await HiveService.instance
          .setLastBookmarkSyncAt(DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Pull bookmarks failed: $e');
    }
  }

  /// BookmarkService holds no in-memory bookmark cache — every read goes
  /// straight to the Hive box — so this is a no-op today. It exists so the
  /// sign-out flow has a guaranteed hook to clear state if a cache is ever
  /// added later.
  void clearInMemoryCache() {}
}
