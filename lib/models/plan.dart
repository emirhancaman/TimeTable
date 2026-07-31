import 'package:hive/hive.dart';

part 'plan.g.dart';

@HiveType(typeId: 2)
enum PlanType {
  @HiveField(0)
  oneTime,
  @HiveField(1)
  weekly,
  @HiveField(2)
  selectedDays,
}

@HiveType(typeId: 0)
class Plan extends HiveObject {
  static const Object _unset = Object();

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String category;

  @HiveField(7)
  int priority; // 1 = Low, 2 = Medium, 3 = High

  @HiveField(9)
  String? subCategory;

  @HiveField(10)
  String emoji;

  @HiveField(11)
  bool isFavorite;

  @HiveField(12, defaultValue: PlanType.oneTime)
  PlanType planType;

  @HiveField(13)
  List<int>? repeatDays; // 1 = Monday, 7 = Sunday

  Plan({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    required this.category,
    this.subCategory,
    this.priority = 2,
    this.emoji = '📋',
    this.isFavorite = false,
    this.planType = PlanType.oneTime,
    this.repeatDays,
  });

  Plan copyWith({
    String? id,
    String? title,
    Object? description = _unset,
    DateTime? createdAt,
    Object? dueDate = _unset,
    bool? isCompleted,
    String? category,
    Object? subCategory = _unset,
    int? priority,
    String? emoji,
    bool? isFavorite,
    PlanType? planType,
    Object? repeatDays = _unset,
  }) {
    return Plan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      createdAt: createdAt ?? this.createdAt,
      dueDate: identical(dueDate, _unset) ? this.dueDate : dueDate as DateTime?,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      subCategory: identical(subCategory, _unset)
          ? this.subCategory
          : subCategory as String?,
      priority: priority ?? this.priority,
      emoji: emoji ?? this.emoji,
      isFavorite: isFavorite ?? this.isFavorite,
      planType: planType ?? this.planType,
      repeatDays: identical(repeatDays, _unset)
          ? this.repeatDays
          : repeatDays as List<int>?,
    );
  }
}
