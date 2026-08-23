class Festival {
  const Festival({
    required this.id,
    required this.nameDevanagari,
    required this.nameEnglish,
    required this.categoryId,
    required this.date,
  });

  final String id;
  final String nameDevanagari;
  final String nameEnglish;

  /// Must match a [Category.id] so the app can jump straight to that filter.
  final String categoryId;

  final DateTime date;

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['id'] as String,
      nameDevanagari: json['name_devanagari'] as String,
      nameEnglish: json['name_english'] as String,
      categoryId: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
