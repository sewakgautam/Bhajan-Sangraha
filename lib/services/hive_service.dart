import 'package:hive_flutter/hive_flutter.dart';

import '../models/bhajan.dart';
import '../models/bookmark.dart';
import '../models/category.dart';
import '../models/gita_quote.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  static const String bhajansBoxName = 'bhajans';
  static const String metaBoxName = 'meta';
  static const String bookmarksBoxName = 'bookmarks';

  late Box<Bhajan> _bhajansBox;
  late Box _metaBox;
  late Box<Bookmark> _bookmarksBox;

  Box get metaBox => _metaBox;
  Box<Bookmark> get bookmarksBox => _bookmarksBox;

  /// [testPath], when provided, initializes Hive against a plain directory
  /// instead of going through Hive.initFlutter()'s path_provider platform
  /// channel — lets tests run against the real HiveService/BookmarkService
  /// code path without mocking platform channels.
  Future<void> init({String? testPath}) async {
    if (testPath != null) {
      Hive.init(testPath);
    } else {
      await Hive.initFlutter();
    }
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BhajanAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CategoryAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BookmarkAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(GitaQuoteAdapter());
    _bhajansBox = await Hive.openBox<Bhajan>(bhajansBoxName);
    _metaBox = await Hive.openBox(metaBoxName);
    _bookmarksBox = await Hive.openBox<Bookmark>(bookmarksBoxName);
  }

  bool get hasBhajans => _bhajansBox.isNotEmpty;

  List<Bhajan> getAllBhajans() => _bhajansBox.values.toList();

  Future<void> upsertBhajans(List<Bhajan> bhajans) async {
    await _bhajansBox.putAll({for (final b in bhajans) b.id: b});
  }

  List<Category> getCategories() {
    final raw = _metaBox.get('categories') as List?;
    if (raw == null) return [];
    return raw.cast<Category>();
  }

  Future<void> setCategories(List<Category> categories) async {
    await _metaBox.put('categories', categories);
  }

  List<GitaQuote> getGitaQuotes() {
    final raw = _metaBox.get('gita_quotes') as List?;
    if (raw == null) return [];
    return raw.cast<GitaQuote>();
  }

  Future<void> setGitaQuotes(List<GitaQuote> quotes) async {
    await _metaBox.put('gita_quotes', quotes);
  }

  int? getLastSyncedAt() => _metaBox.get('last_synced_at') as int?;

  Future<void> setLastSyncedAt(int millis) async {
    await _metaBox.put('last_synced_at', millis);
  }

  String? getUserUid() => _metaBox.get('user_uid') as String?;
  String? getUserEmail() => _metaBox.get('user_email') as String?;
  String? getUserDisplayName() => _metaBox.get('user_display_name') as String?;

  Future<void> setUserSession({
    required String uid,
    String? email,
    String? displayName,
  }) async {
    await _metaBox.put('user_uid', uid);
    await _metaBox.put('user_email', email);
    await _metaBox.put('user_display_name', displayName);
  }

  Future<void> clearUserSession() async {
    await _metaBox.delete('user_uid');
    await _metaBox.delete('user_email');
    await _metaBox.delete('user_display_name');
  }

  int? getLastBookmarkSyncAt() => _metaBox.get('last_bookmark_sync_at') as int?;

  Future<void> setLastBookmarkSyncAt(int millis) async {
    await _metaBox.put('last_bookmark_sync_at', millis);
  }

  List<String> getPendingDeletes() =>
      (_metaBox.get('pending_deletes') as List?)?.cast<String>() ?? [];

  Future<void> setPendingDeletes(List<String> bhajanIds) async {
    await _metaBox.put('pending_deletes', bhajanIds);
  }

  /// Bookmark keys used to be bare bhajan IDs shared across every account on
  /// the device — one account could read and delete another's bookmarks.
  /// Keys are now namespaced as "uid:bhajanId". Old un-scoped keys can't be
  /// safely re-attributed to any one account, so this wipes them once.
  Future<void> migrateBookmarksIfNeeded() async {
    final alreadyMigrated =
        _metaBox.get('bookmarks_scoped_v1', defaultValue: false) as bool;
    if (alreadyMigrated) return;

    final unscopedKeys =
        _bookmarksBox.keys.where((k) => !k.toString().contains(':')).toList();
    if (unscopedKeys.isNotEmpty) {
      await _bookmarksBox.deleteAll(unscopedKeys);
    }
    await _metaBox.put('bookmarks_scoped_v1', true);
  }
}
