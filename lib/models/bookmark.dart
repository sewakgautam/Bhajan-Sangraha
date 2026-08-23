import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 2)
class Bookmark extends HiveObject {
  @HiveField(0)
  final String bhajanId;

  @HiveField(1)
  final int bookmarkedAt;

  @HiveField(2)
  bool synced;

  /// Display position within the bookmarks list, ascending. Purely a local
  /// display preference — not synced remotely. Lower sorts first; new
  /// bookmarks get a value lower than any existing one so they appear at
  /// the top, matching the previous "most recently bookmarked first" order
  /// until the user drags something to reorder it.
  @HiveField(3)
  int sortOrder;

  Bookmark({
    required this.bhajanId,
    required this.bookmarkedAt,
    this.synced = false,
    int? sortOrder,
  }) : sortOrder = sortOrder ?? -bookmarkedAt;
}
