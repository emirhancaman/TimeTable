import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/plan.dart';
import '../providers/plan_provider.dart';
import '../theme/app_theme.dart';
import '../utils/localization.dart';

class AddPlanScreen extends StatefulWidget {
  final Plan? planToEdit;
  final String? initialCategory;
  final String? initialSubCategory;

  const AddPlanScreen({
    super.key,
    this.planToEdit,
    this.initialCategory,
    this.initialSubCategory,
  });

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubCategory;
  int _priority = 2;
  DateTime? _dueDate;
  bool get isEditing => widget.planToEdit != null;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

    if (isEditing) {
      final plan = widget.planToEdit!;
      _titleController.text = plan.title;
      _descriptionController.text = plan.description ?? '';
      _selectedCategory = plan.category;
      _selectedSubCategory = plan.subCategory;
      _priority = plan.priority;
      _dueDate = plan.dueDate;
    } else {
      if (widget.initialCategory != null) {
        _selectedCategory = widget.initialCategory;
      }
      if (widget.initialSubCategory != null) {
        _selectedSubCategory = widget.initialSubCategory;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _savePlan() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir kategori seçin')),
        );
        return;
      }

      final provider = context.read<PlanProvider>();

      try {
        if (isEditing) {
          final updatedPlan = widget.planToEdit!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: _selectedCategory,
            subCategory: _selectedSubCategory,
            priority: _priority,
            dueDate: _dueDate,
            emoji: '',
            planType: PlanType.oneTime,
            repeatDays: null,
          );
          await provider.updatePlan(updatedPlan);
        } else {
          await provider.addPlan(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: _selectedCategory!,
            subCategory: _selectedSubCategory,
            priority: _priority,
            dueDate: _dueDate,
            emoji: '',
            planType: PlanType.oneTime,
            repeatDays: null,
          );
        }

        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Plan güncellendi' : 'Plan eklendi'),
            backgroundColor: AppTheme.successMint,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata oluştu: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Planı Düzenle' : 'New Plan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.darkCardLight
                            : AppTheme.lightCardAlt,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Form card
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.darkCard
                              : AppTheme.lightCard,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusXLarge,
                          ),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Title field
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1A1A1C)
                                    : AppTheme.lightCardAlt,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMedium,
                                ),
                              ),
                              child: TextFormField(
                                controller: _titleController,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.35),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Lütfen bir başlık girin';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Description field
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1A1A1C)
                                    : AppTheme.lightCardAlt,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusMedium,
                                ),
                              ),
                              child: TextFormField(
                                controller: _descriptionController,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.35),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category
                      _buildSectionLabel('Category'),
                      const SizedBox(height: 10),
                      Consumer<PlanProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: provider.categories.map((category) {
                                  final isSelected =
                                      _selectedCategory == category.id;
                                  final loc = AppLocalizations.of(context);
                                  final catKey =
                                      'category_${category.id.toLowerCase()}';
                                  final localizedName =
                                      loc.get(catKey) != catKey
                                      ? loc.get(catKey)
                                      : category.name;

                                  return GestureDetector(
                                    onTap: () => setState(() {
                                      _selectedCategory = category.id;
                                      _selectedSubCategory = null;
                                    }),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : (isDark
                                                  ? AppTheme.darkCard
                                                  : AppTheme.lightCard),
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMedium,
                                        ),
                                        border: isSelected
                                            ? null
                                            : Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.08),
                                              ),
                                        boxShadow: isDark
                                            ? null
                                            : [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.04),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                      ),
                                      child: Text(
                                        localizedName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // SubCategories
                              if (_selectedCategory != null)
                                Builder(
                                  builder: (context) {
                                    try {
                                      final category = provider.categories
                                          .firstWhere(
                                            (c) => c.id == _selectedCategory,
                                          );
                                      if (category.subCategories.isEmpty) {
                                        return const SizedBox.shrink();
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          _buildSectionLabel('Alt Kategori'),
                                          const SizedBox(height: 10),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: category.subCategories.map((
                                              sub,
                                            ) {
                                              final isSelected =
                                                  _selectedSubCategory == sub;
                                              return GestureDetector(
                                                onTap: () => setState(() {
                                                  _selectedSubCategory =
                                                      isSelected ? null : sub;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.8)
                                                        : (isDark
                                                              ? AppTheme
                                                                    .darkCard
                                                              : AppTheme
                                                                    .lightCard),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: isSelected
                                                        ? null
                                                        : Border.all(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onSurface
                                                                    .withOpacity(
                                                                      0.08,
                                                                    ),
                                                          ),
                                                  ),
                                                  child: Text(
                                                    sub,
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Theme.of(context)
                                                                .colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    } catch (e) {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Priority
                      _buildSectionLabel('Priority'),
                      const SizedBox(height: 10),
                      Row(
                        children: [1, 2, 3].map((priority) {
                          final isSelected = _priority == priority;
                          final color = AppTheme.getPriorityColor(priority);
                          final label = AppTheme.getPriorityLabel(priority);
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: priority < 3 ? 8 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _priority = priority),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color.withOpacity(0.15)
                                        : (isDark
                                              ? AppTheme.darkCard
                                              : AppTheme.lightCard),
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusMedium,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? color
                                          : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.08),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? color
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Due Date
                      _buildSectionLabel('Bitiş Tarihi (İsteğe bağlı)'),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkCard
                                : AppTheme.lightCard,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMedium,
                            ),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                color: _dueDate != null
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.35),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _dueDate != null
                                    ? DateFormat(
                                        'd MMMM yyyy',
                                        'tr_TR',
                                      ).format(_dueDate!)
                                    : 'Tarih seçin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _dueDate != null
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            // Save Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: GestureDetector(
                    onTap: _savePlan,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isEditing ? 'Güncelle' : 'Add Plan',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        letterSpacing: 0.3,
      ),
    );
  }
}
