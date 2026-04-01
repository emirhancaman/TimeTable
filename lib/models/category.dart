import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String emoji;

  @HiveField(3)
  List<String> subCategories;

  Category({
    required this.id,
    required this.name,
    this.emoji = '📁',
    List<String>? subCategories,
  }) : subCategories = subCategories ?? [];

  Category copyWith({
    String? id,
    String? name,
    String? emoji,
    List<String>? subCategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}
