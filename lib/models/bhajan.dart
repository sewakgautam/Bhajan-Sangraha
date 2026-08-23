import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'bhajan.g.dart';

@HiveType(typeId: 0)
class Bhajan extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int number;

  @HiveField(2)
  final String titleDevanagari;

  @HiveField(3)
  final String titleRoman;

  @HiveField(4)
  final String lyricsDevanagari;

  @HiveField(5)
  final String lyricsRoman;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final List<String> keywords;

  @HiveField(8)
  final String firstLineDevanagari;

  @HiveField(9)
  final String firstLineRoman;

  @HiveField(10)
  final String? sourceBook;

  @HiveField(11)
  final String? sourceAuthor;

  @HiveField(12)
  final String? sourcePublisher;

  @HiveField(13)
  final String? sourceYear;

  @HiveField(14)
  final int? sourcePage;

  @HiveField(15)
  final int updatedAt;

  @HiveField(16)
  final String? meaningDevanagari;

  @HiveField(17)
  final String? youtubeUrl;

  Bhajan({
    required this.id,
    required this.number,
    required this.titleDevanagari,
    required this.titleRoman,
    required this.lyricsDevanagari,
    required this.lyricsRoman,
    required this.category,
    required this.keywords,
    required this.firstLineDevanagari,
    required this.firstLineRoman,
    this.sourceBook,
    this.sourceAuthor,
    this.sourcePublisher,
    this.sourceYear,
    this.sourcePage,
    required this.updatedAt,
    this.meaningDevanagari,
    this.youtubeUrl,
  });

  factory Bhajan.fromFirestore(String id, Map<String, dynamic> data) {
    final updatedAtRaw = data['updated_at'];
    return Bhajan(
      id: id,
      number: data['number'] as int,
      titleDevanagari: data['title_devanagari'] as String,
      titleRoman: data['title_roman'] as String,
      lyricsDevanagari: data['lyrics_devanagari'] as String,
      lyricsRoman: data['lyrics_roman'] as String,
      category: data['category'] as String,
      keywords: List<String>.from(data['keywords'] as List? ?? const []),
      firstLineDevanagari: data['first_line_devanagari'] as String,
      firstLineRoman: data['first_line_roman'] as String,
      sourceBook: data['source_book'] as String?,
      sourceAuthor: data['source_author'] as String?,
      sourcePublisher: data['source_publisher'] as String?,
      sourceYear: data['source_year'] as String?,
      sourcePage: data['source_page'] as int?,
      updatedAt: updatedAtRaw is Timestamp ? updatedAtRaw.millisecondsSinceEpoch : 0,
      meaningDevanagari: data['meaning_devanagari'] as String?,
      youtubeUrl: data['youtube_url'] as String?,
    );
  }
}
