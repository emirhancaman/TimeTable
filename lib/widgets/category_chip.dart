import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/category_icon.dart';
import '../utils/localization.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const CategoryChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? null
              : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          gradient: isSelected ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryNavy.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : (isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: isSelected ? Colors.white : null),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final List<Category> categories;
  final VoidCallback? onAddPressed;
  final Function(Category)? onCategoryDelete;
  final VoidCallback? onAllCategoryDelete;
  final bool showAllCategory;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories,
    this.onAddPressed,
    this.onCategoryDelete,
    this.onAllCategoryDelete,
    this.showAllCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (showAllCategory) ...[
            CategoryChip(
              label: loc.get('category_all') == 'category_all'
                  ? 'Tümü'
                  : loc.get('category_all'),
              icon: Icons.view_agenda_outlined,
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
              onLongPress: onAllCategoryDelete,
            ),
            const SizedBox(width: 8),
          ],
          ...categories.map((category) {
            final catKey = 'category_${category.id.toLowerCase()}';
            final localizedName = loc.get(catKey) != catKey
                ? loc.get(catKey)
                : category.name;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                label: localizedName,
                icon: categoryIcon(category.id),
                isSelected: selectedCategory == category.id,
                onTap: () => onCategorySelected(category.id),
                onLongPress: onCategoryDelete != null
                    ? () => onCategoryDelete!(category)
                    : null,
              ),
            );
          }),
          if (onAddPressed != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryChip(
                label: loc.get('add'),
                icon: Icons.add_rounded,
                isSelected: false,
                onTap: onAddPressed!,
              ),
            ),
        ],
      ),
    );
  }
}
