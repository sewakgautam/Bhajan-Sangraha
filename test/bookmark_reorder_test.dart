import 'dart:io';

import 'package:bhajan_sangraha/models/bookmark.dart';
import 'package:bhajan_sangraha/services/bookmark_service.dart';
import 'package:bhajan_sangraha/services/hive_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('bookmark_reorder_test');
    await HiveService.instance.init(testPath: tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    tempDir.deleteSync(recursive: true);
  });

  const uid = 'user_a';

  Future<void> seedBookmark(String bhajanId, int bookmarkedAt, {String forUid = uid}) async {
    await HiveService.instance.bookmarksBox.put(
      '$forUid:$bhajanId',
      Bookmark(bhajanId: bhajanId, bookmarkedAt: bookmarkedAt),
    );
  }

  test('new bookmarks default to newest-first order', () async {
    await seedBookmark('a', 1000);
    await seedBookmark('b', 2000);
    await seedBookmark('c', 3000);

    final ordered = BookmarkService.instance.getAll(uid: uid)
      ..sort((x, y) => x.sortOrder.compareTo(y.sortOrder));
    expect(ordered.map((b) => b.bhajanId).toList(), ['c', 'b', 'a']);
  });

  test('reorder persists the dragged position', () async {
    await seedBookmark('a', 1000);
    await seedBookmark('b', 2000);
    await seedBookmark('c', 3000);
    // Default order is [c, b, a]; drag "a" to the top.
    await BookmarkService.instance.reorder(['a', 'c', 'b'], uid: uid);

    final ordered = BookmarkService.instance.getAll(uid: uid)
      ..sort((x, y) => x.sortOrder.compareTo(y.sortOrder));
    expect(ordered.map((b) => b.bhajanId).toList(), ['a', 'c', 'b']);
  });

  test('a bookmark added after a manual reorder still sorts first', () async {
    await seedBookmark('a', 1000);
    await seedBookmark('b', 2000);
    await BookmarkService.instance.reorder(['a', 'b'], uid: uid);

    await seedBookmark('c', 3000);

    final ordered = BookmarkService.instance.getAll(uid: uid)
      ..sort((x, y) => x.sortOrder.compareTo(y.sortOrder));
    expect(ordered.map((b) => b.bhajanId).toList(), ['c', 'a', 'b']);
  });

  test('bookmarks are isolated per user', () async {
    await seedBookmark('a', 1000, forUid: uid);
    await seedBookmark('x', 5000, forUid: 'user_b');

    expect(BookmarkService.instance.getAll(uid: uid).map((b) => b.bhajanId), ['a']);
    expect(BookmarkService.instance.getAll(uid: 'user_b').map((b) => b.bhajanId), ['x']);
    expect(BookmarkService.instance.isBookmarked('x', uid: uid), isFalse);
    expect(BookmarkService.instance.isBookmarked('x', uid: 'user_b'), isTrue);

    // Reordering user_b's list must not touch user_a's bookmark.
    await BookmarkService.instance.reorder(['x'], uid: 'user_b');
    expect(BookmarkService.instance.getAll(uid: uid).map((b) => b.bhajanId), ['a']);
  });
}
