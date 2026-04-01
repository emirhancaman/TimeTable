import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_provider.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/localization.dart';

class FocusTrackerCard extends StatefulWidget {
  const FocusTrackerCard({super.key});

  @override
  State<FocusTrackerCard> createState() => _FocusTrackerCardState();
}

class _FocusTrackerCardState extends State<FocusTrackerCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, provider, child) {
        final focusCategoryId = provider.focusCategoryId;
        final focusSubCategory = provider.focusSubCategory;

        if (focusCategoryId == null) {
          return _buildEmptyState(context);
        }

        final stats = provider.getFocusStats(focusCategoryId, focusSubCategory);
        final completed = stats['completed'] as int;
        final total = stats['total'] as int;
        final progress = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
        final loc = AppLocalizations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        String title = provider.getCategoryName(focusCategoryId);
        final catKey = 'category_${focusCategoryId.toLowerCase()}';
        if (loc.get(catKey) != catKey) {
          title = loc.get(catKey);
        }
        if (focusSubCategory != null) {
          title += ' > $focusSubCategory';
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            border: Border.all(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              width: 1,
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onLongPress: () => _showFocusSelectionDialog(context, provider),
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryPurple.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    provider.getCategoryEmoji(focusCategoryId),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completed/$total',
                          style: const TextStyle(
                            color: AppTheme.primaryPurpleLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDark
                            ? AppTheme.darkBackground
                            : AppTheme.lightCardAlt,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryPurple,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              _showFocusSelectionDialog(context, context.read<PlanProvider>()),
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.center_focus_strong_rounded,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.25),
                  size: 26,
                ),
                const SizedBox(height: 8),
                Text(
                  loc.get('select_focus'),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  loc.get('tap_to_track'),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.35),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFocusSelectionDialog(BuildContext context, PlanProvider provider) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        title: Text(
          loc.get('select_focus'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (provider.focusCategoryId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        provider.setFocus(null, null);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('Odağı Kaldır'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorRed,
                        side: BorderSide(
                          color: AppTheme.errorRed.withOpacity(0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    final catKey = 'category_${category.id.toLowerCase()}';
                    final catName = loc.get(catKey) != catKey
                        ? loc.get(catKey)
                        : category.name;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Text(
                            category.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                          title: Text(
                            catName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          dense: true,
                          onTap: () {
                            provider.setFocus(category.id, null);
                            Navigator.pop(context);
                          },
                        ),
                        ...category.subCategories.map((sub) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 52),
                            title: Text(
                              sub,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                            dense: true,
                            onTap: () {
                              provider.setFocus(category.id, sub);
                              Navigator.pop(context);
                            },
                          );
                        }),
                        if (index < provider.categories.length - 1)
                          Divider(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.08),
                            height: 1,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
