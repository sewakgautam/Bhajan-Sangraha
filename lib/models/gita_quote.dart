import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'gita_quote.g.dart';

@HiveType(typeId: 3)
class GitaQuote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int number;

  @HiveField(2)
  final String textDevanagari;

  @HiveField(3)
  final String? textRoman;

  @HiveField(4)
  final String? meaningDevanagari;

  @HiveField(5)
  final String? chapterVerse;

  @HiveField(6)
  final int updatedAt;

  /// Numeric chapter/verse, kept separately from [chapterVerse] (the
  /// Devanagari display string) so the list can be sorted correctly —
  /// [chapterVerse] alone can't be sorted numerically since its digits are
  /// Devanagari, not ASCII.
  @HiveField(7)
  final int chapter;

  @HiveField(8)
  final int verse;

  GitaQuote({
    required this.id,
    required this.number,
    required this.textDevanagari,
    this.textRoman,
    this.meaningDevanagari,
    this.chapterVerse,
    required this.updatedAt,
    required this.chapter,
    required this.verse,
  });

  factory GitaQuote.fromFirestore(String id, Map<String, dynamic> data) {
    final updatedAtRaw = data['updated_at'];
    return GitaQuote(
      id: id,
      number: data['number'] as int,
      textDevanagari: data['text_devanagari'] as String,
      textRoman: data['text_roman'] as String?,
      meaningDevanagari: data['meaning_devanagari'] as String?,
      chapterVerse: data['chapter_verse'] as String?,
      updatedAt: updatedAtRaw is Timestamp ? updatedAtRaw.millisecondsSinceEpoch : 0,
      chapter: data['chapter'] as int? ?? 0,
      verse: data['verse'] as int? ?? 0,
    );
  }
}
