import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nameDevanagari;

  @HiveField(2)
  final String nameEnglish;

  @HiveField(3)
  final int sortOrder;

  @HiveField(4)
  final String? icon;

  Category({
    required this.id,
    required this.nameDevanagari,
    required this.nameEnglish,
    required this.sortOrder,
    this.icon,
  });

  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      nameDevanagari: data['name_devanagari'] as String,
      nameEnglish: data['name_english'] as String,
      sortOrder: data['sort_order'] as int,
      icon: data['icon'] as String?,
    );
  }
}
