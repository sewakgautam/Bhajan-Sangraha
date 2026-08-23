class Greeting {
  const Greeting({
    required this.nameDevanagari,
    required this.nameEnglish,
    required this.categoryId,
  });

  final String nameDevanagari;
  final String nameEnglish;

  /// Must match a [Category.id] so tapping the card jumps straight to that
  /// deity's bhajans, same as [Festival.categoryId] does for festivals.
  final String categoryId;
}
