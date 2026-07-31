import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/category.dart';
import '../models/plan.dart';
import '../providers/plan_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/plan_card.dart';
import '../widgets/focus_tracker_card.dart';
import 'add_plan_screen.dart';
import 'settings_screen.dart';
import '../utils/localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _showAddPlanSheet() {
    final provider = context.read<PlanProvider>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      backgroundColor: Colors.transparent,
      builder: (context) => AddPlanScreen(
        initialCategory: provider.selectedCategory,
        initialSubCategory: provider.selectedSubCategory,
      ),
    );
  }

  void _showEditPlanSheet(Plan plan) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 640),
      backgroundColor: Colors.transparent,
      builder: (context) => AddPlanScreen(planToEdit: plan),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String planId) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        title: Text(
          loc.get('delete_plan'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          loc.get('delete_confirm'),
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PlanProvider>().deletePlan(planId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${loc.get('delete_plan')} ${loc.get('completed')}',
                  ),
                  backgroundColor: AppTheme.errorRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: Text(loc.get('delete')),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, Category category) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          loc.get('delete'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          '${category.name} ${loc.get('delete_confirm')}',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PlanProvider>().deleteCategory(category.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: Text(loc.get('delete')),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final textController = TextEditingController();
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          loc.get('add'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: loc.get('category_name_label'),
                labelStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<PlanProvider>().addCategory(
                  textController.text,
                  '',
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(loc.get('add')),
          ),
        ],
      ),
    );
  }

  void _showDeleteSubCategoryDialog(
    BuildContext context,
    String categoryId,
    String subCategoryName,
  ) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          loc.get('delete'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          '$subCategoryName: ${loc.get('delete_confirm')}',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PlanProvider>().deleteSubCategory(
                categoryId,
                subCategoryName,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: Text(loc.get('delete')),
          ),
        ],
      ),
    );
  }

  void _showAddSubCategoryDialog(BuildContext context, String categoryId) {
    final textController = TextEditingController();
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          loc.get('add'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: TextField(
          controller: textController,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: loc.get('subcategory_name_label'),
            labelStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.get('cancel'),
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                context.read<PlanProvider>().addSubCategory(
                  categoryId,
                  textController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(loc.get('add')),
          ),
        ],
      ),
    );
  }

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    final loc = AppLocalizations.of(context);

    if (hour >= 6 && hour < 12) {
      return loc.get('greeting_morning');
    } else if (hour >= 12 && hour < 18) {
      return loc.get('greeting_day');
    } else if (hour >= 18 && hour < 22) {
      return loc.get('greeting_evening');
    } else {
      return loc.get('greeting_night');
    }
  }

  Widget _buildEmptyState() {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.event_note_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            loc.get('empty_state'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.get('empty_state_desc'),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Consumer<PlanProvider>(
              builder: (context, planProvider, child) {
                return AnimationLimiter(
                  child: CustomScrollView(
                    slivers: [
                      // App Bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    () {
                                      if (planProvider.selectedCategory ==
                                          null) {
                                        return loc.get('my_plans');
                                      }
                                      final catId =
                                          planProvider.selectedCategory!;
                                      final catKey =
                                          'category_${catId.toLowerCase()}';
                                      if (loc.get(catKey) != catKey) {
                                        return loc.get(catKey);
                                      }
                                      return planProvider.getCategoryName(
                                        catId,
                                      );
                                    }(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton.filledTonal(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings_rounded,
                                  size: 20,
                                ),
                                tooltip: loc.get('settings_title'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Pinned Plans removed per user request
                      // Focus Tracker
                      const SliverToBoxAdapter(child: FocusTrackerCard()),
                      // Category Filter
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CategoryFilter(
                                selectedCategory: planProvider.selectedCategory,
                                onCategorySelected: planProvider.setCategory,
                                categories: planProvider.categories,
                                showAllCategory: false,
                                onAddPressed: () =>
                                    _showAddCategoryDialog(context),
                                onCategoryDelete: (category) =>
                                    _showDeleteCategoryDialog(
                                      context,
                                      category,
                                    ),
                              ),
                              if (planProvider.selectedCategory != null) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    children: [
                                      // SubCategories
                                      Builder(
                                        builder: (context) {
                                          try {
                                            final category = planProvider
                                                .categories
                                                .firstWhere(
                                                  (c) =>
                                                      c.id ==
                                                      planProvider
                                                          .selectedCategory,
                                                );
                                            return Row(
                                              children: [
                                                ...category.subCategories.map((
                                                  sub,
                                                ) {
                                                  final isSelected =
                                                      planProvider
                                                          .selectedSubCategory ==
                                                      sub;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 8,
                                                        ),
                                                    child: GestureDetector(
                                                      onLongPress: () =>
                                                          _showDeleteSubCategoryDialog(
                                                            context,
                                                            category.id,
                                                            sub,
                                                          ),
                                                      child: ChoiceChip(
                                                        label: Text(sub),
                                                        selected: isSelected,
                                                        onSelected: (selected) {
                                                          planProvider
                                                              .setSubCategory(
                                                                selected
                                                                    ? sub
                                                                    : null,
                                                              );
                                                        },
                                                        backgroundColor:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? AppTheme.darkCard
                                                            : AppTheme
                                                                  .lightCard,
                                                        selectedColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                        labelStyle: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onSurface
                                                                    .withValues(
                                                                      alpha:
                                                                          0.6,
                                                                    ),
                                                          fontSize: 13,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        side: BorderSide.none,
                                                      ),
                                                    ),
                                                  );
                                                }),
                                                // Add SubCategory Button
                                                ActionChip(
                                                  label: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                  backgroundColor:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? AppTheme.darkCard
                                                      : AppTheme.lightCard,
                                                  onPressed: () =>
                                                      _showAddSubCategoryDialog(
                                                        context,
                                                        category.id,
                                                      ),
                                                  shape: const CircleBorder(),
                                                  side: BorderSide.none,
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            );
                                          } catch (e) {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // Plans List
                      if (planProvider.plans.isEmpty)
                        SliverFillRemaining(child: _buildEmptyState())
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final plan = planProvider.plans[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: PlanCard(
                                      plan: plan,
                                      onToggle: () => planProvider
                                          .togglePlanCompletion(plan.id),
                                      onDelete: () => _showDeleteConfirmation(
                                        context,
                                        plan.id,
                                      ),
                                      onTap: () => _showEditPlanSheet(plan),
                                    ),
                                  ),
                                ),
                              );
                            }, childCount: planProvider.plans.length),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: MouseRegion(
        onEnter: (_) => _fabController.forward(),
        onExit: (_) => _fabController.reverse(),
        child: ScaleTransition(
          scale: _fabScaleAnimation,
          child: FloatingActionButton.extended(
            onPressed: _showAddPlanSheet,
            tooltip: loc.get('new_plan'),
            icon: const Icon(Icons.add_rounded, size: 24),
            label: Text(
              loc.get('new_plan'),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
