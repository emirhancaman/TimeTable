import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/plan.dart';
import '../models/category.dart';
import '../services/database_service.dart';
import '../services/home_widget_service.dart';

class PlanProvider extends ChangeNotifier {
  List<Plan> _plans = [];
  List<Category> _categories = [];
  String? _selectedCategory;
  String? _selectedSubCategory;
  bool _showCompleted = true;

  List<Plan> get plans => _getFilteredPlans();
  List<Plan> get allPlans => _plans;
  List<Category> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubCategory => _selectedSubCategory;
  bool get showCompleted => _showCompleted;

  // Statistics
  int get totalPlans => _plans.length;
  int get completedPlans => _plans.where((p) => p.isCompleted).length;
  int get pendingPlans => _plans.where((p) => !p.isCompleted).length;
  double get completionRate => totalPlans > 0 ? completedPlans / totalPlans : 0;
  List<Plan> get favoritePlans => _plans.where((p) => p.isFavorite).toList();

  PlanProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _categories = DatabaseService.getAllCategories();
    _plans = DatabaseService.getAllPlans();

    // Seed default categories if empty
    if (_categories.isEmpty) {
      await _seedDefaultCategories();
    }

    await _loadFocusSettings();

    // Default to first category if available
    if (_selectedCategory == null && _categories.isNotEmpty) {
      _selectedCategory = _categories.first.id;
    }

    _sortPlans();
    HomeWidgetService.updateWidget(_plans);
    notifyListeners();
  }

  Future<void> _seedDefaultCategories() async {
    final defaults = [
      Category(id: 'work', name: 'İş', emoji: ''),
      Category(id: 'personal', name: 'Kişisel', emoji: ''),
      Category(id: 'health', name: 'Sağlık', emoji: ''),
      Category(id: 'education', name: 'Eğitim', emoji: ''),
      Category(id: 'shopping', name: 'Alışveriş', emoji: ''),
      Category(id: 'other', name: 'Diğer', emoji: ''),
    ];
    for (var cat in defaults) {
      await DatabaseService.addCategory(cat);
    }
    _categories = DatabaseService.getAllCategories();
  }

  void _sortPlans() {
    _plans.sort((a, b) {
      // Completed items at the bottom
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Then by priority (high to low)
      if (a.priority != b.priority) {
        return b.priority.compareTo(a.priority);
      }
      // Then by due date
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      // Then by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  List<Plan> _getFilteredPlans() {
    var filtered = _plans.toList();

    if (_selectedCategory != null) {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();

      if (_selectedSubCategory != null) {
        filtered = filtered
            .where((p) => p.subCategory == _selectedSubCategory)
            .toList();
      }
    }

    if (!_showCompleted) {
      filtered = filtered.where((p) => !p.isCompleted).toList();
    }

    return filtered;
  }

  Future<void> addPlan({
    required String title,
    String? description,
    DateTime? dueDate,
    required String category,
    String? subCategory,
    int priority = 2,
    String emoji = '',
    PlanType planType = PlanType.oneTime,
    List<int>? repeatDays,
  }) async {
    final plan = Plan(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      category: category,
      subCategory: subCategory,
      priority: priority,
      emoji: emoji,
      planType: planType,
      repeatDays: repeatDays,
    );

    await DatabaseService.addPlan(plan);
    _plans.add(plan);

    // Automatically switch to the new plan's category so it becomes immediately visible on the Home Screen.
    _selectedCategory = category;
    _selectedSubCategory = subCategory;

    _sortPlans();
    HomeWidgetService.updateWidget(_plans);
    notifyListeners();
  }

  Future<void> updatePlan(Plan plan) async {
    await DatabaseService.updatePlan(plan);
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _plans[index] = plan;
      _sortPlans();
      HomeWidgetService.updateWidget(_plans);
      notifyListeners();
    }
  }

  Future<void> deletePlan(String id) async {
    await DatabaseService.deletePlan(id);
    _plans.removeWhere((p) => p.id == id);
    HomeWidgetService.updateWidget(_plans);
    notifyListeners();
  }

  Future<void> togglePlanCompletion(String id) async {
    final plan = _plans.firstWhere((p) => p.id == id);
    final updatedPlan = plan.copyWith(isCompleted: !plan.isCompleted);
    await updatePlan(updatedPlan);
  }

  Future<void> togglePlanFavorite(String id) async {
    final plan = _plans.firstWhere((p) => p.id == id);
    final updatedPlan = plan.copyWith(isFavorite: !plan.isFavorite);
    await updatePlan(updatedPlan);
  }

  Future<void> addCategory(String name, String emoji) async {
    final category = Category(id: const Uuid().v4(), name: name, emoji: emoji);
    await DatabaseService.addCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> addSubCategory(String categoryId, String subCategoryName) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      final category = _categories[index];
      category.subCategories.add(subCategoryName);
      await category.save();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    await DatabaseService.deleteCategory(id);
    _categories.removeWhere((c) => c.id == id);
    // Reset selection if deleted
    if (_selectedCategory == id) {
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first.id;
      } else {
        _selectedCategory = null;
      }
      _selectedSubCategory = null;
    }

    // Reset Focus if deleted
    if (_focusCategoryId == id) {
      _focusCategoryId = null;
      _focusSubCategory = null;
      final box = DatabaseService.settingsBox;
      box.delete('focusCategoryId');
      box.delete('focusSubCategory');
    }

    notifyListeners();
  }

  Future<void> deleteSubCategory(
    String categoryId,
    String subCategoryName,
  ) async {
    final index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      final category = _categories[index];
      category.subCategories.remove(subCategoryName);
      await category.save();

      if (_selectedCategory == categoryId &&
          _selectedSubCategory == subCategoryName) {
        _selectedSubCategory = null;
      }
      notifyListeners();
    }
  }

  void setCategory(String? categoryId) {
    _selectedCategory = categoryId;
    _selectedSubCategory = null; // Reset subcategory when category changes
    notifyListeners();
  }

  void setSubCategory(String? subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void toggleShowCompleted() {
    _showCompleted = !_showCompleted;
    notifyListeners();
  }

  void refresh() {
    _loadData();
  }

  // Helper to get emoji
  String getCategoryEmoji(String categoryId) {
    final category = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(id: 'unknown', name: 'Unknown', emoji: ''),
    );
    return category.emoji;
  }

  String getCategoryName(String categoryId) {
    final category = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(id: 'unknown', name: 'Unknown', emoji: ''),
    );
    return category.name;
  }

  // Focus Tracking
  String? _focusCategoryId;
  String? _focusSubCategory;

  String? get focusCategoryId => _focusCategoryId;
  String? get focusSubCategory => _focusSubCategory;

  void setFocus(String? categoryId, String? subCategory) {
    _focusCategoryId = categoryId;
    _focusSubCategory = subCategory;

    // Persist to hive settings
    final box = DatabaseService.settingsBox;
    box.put('focusCategoryId', categoryId);
    box.put('focusSubCategory', subCategory);

    notifyListeners();
  }

  Map<String, dynamic> getFocusStats(String categoryId, String? subCategory) {
    // Get all plans matching category/subcategory
    final allRelevant = _plans.where((p) {
      bool catMatch = p.category == categoryId;
      bool subMatch = subCategory == null || p.subCategory == subCategory;
      return catMatch && subMatch;
    }).toList();

    final completedCount = allRelevant.where((p) => p.isCompleted).length;

    return {'completed': completedCount, 'total': allRelevant.length};
  }

  Future<void> _loadFocusSettings() async {
    final box = DatabaseService.settingsBox;
    _focusCategoryId = box.get('focusCategoryId') as String?;
    _focusSubCategory = box.get('focusSubCategory') as String?;
  }
}
