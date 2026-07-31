import 'package:hive_flutter/hive_flutter.dart';
import '../models/plan.dart';
import '../models/category.dart';

class DatabaseService {
  static const String _planBoxName = 'plans';
  static const String _categoryBoxName = 'categories';
  static const String _settingsBoxName = 'settings';
  static Box<Plan>? _planBox;
  static Box<Category>? _categoryBox;
  static Box? _settingsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PlanAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PlanTypeAdapter());
    }
    _planBox = await Hive.openBox<Plan>(_planBoxName);
    _categoryBox = await Hive.openBox<Category>(_categoryBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  static Box<Plan> get planBox {
    if (_planBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _planBox!;
  }

  static Box<Category> get categoryBox {
    if (_categoryBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _categoryBox!;
  }

  static Box get settingsBox {
    if (_settingsBox == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _settingsBox!;
  }

  // CRUD Operations
  static Future<void> addPlan(Plan plan) async {
    await planBox.put(plan.id, plan);
  }

  static Future<void> updatePlan(Plan plan) async {
    await planBox.put(plan.id, plan);
  }

  static Future<void> deletePlan(String id) async {
    await planBox.delete(id);
  }

  static Plan? getPlan(String id) {
    return planBox.get(id);
  }

  static List<Plan> getAllPlans() {
    return planBox.values.toList();
  }

  static List<Plan> getPlansByCategory(String category) {
    return planBox.values.where((plan) => plan.category == category).toList();
  }

  static List<Plan> getCompletedPlans() {
    return planBox.values.where((plan) => plan.isCompleted).toList();
  }

  static List<Plan> getPendingPlans() {
    return planBox.values.where((plan) => !plan.isCompleted).toList();
  }

  // Category CRUD Operations
  static Future<void> addCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }

  static Future<void> updateCategory(Category category) async {
    await categoryBox.put(category.id, category);
  }

  static Future<void> deleteCategory(String id) async {
    await categoryBox.delete(id);
  }

  static List<Category> getAllCategories() {
    return categoryBox.values.toList();
  }
}
