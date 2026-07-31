import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plan_provider.dart';
import '../models/plan.dart';
import '../theme/app_theme.dart';
import '../utils/category_icon.dart';
import 'package:intl/intl.dart';
import '../utils/localization.dart';

class PinnedPlanList extends StatelessWidget {
  const PinnedPlanList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, provider, child) {
        final pinnedPlans = provider.favoritePlans;

        if (pinnedPlans.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header "Önemliler" removed as requested
            const SizedBox(height: 10), // Adding small spacing manually instead
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: pinnedPlans.length,
                itemBuilder: (context, index) {
                  return _PinnedCard(plan: pinnedPlans[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PinnedCard extends StatelessWidget {
  final Plan plan;

  const _PinnedCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(
      'd MMM',
      Localizations.localeOf(context).toString(),
    );

    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardTheme.color, // Solid color, removed gradient
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.warningYellow.withValues(alpha: 0.3),
          width: 1,
        ),
        // Shadow removed
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          onTap: () {
            // Option to edit or view details
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      categoryIcon(plan.category),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    InkWell(
                      onTap: () {
                        context.read<PlanProvider>().togglePlanFavorite(
                          plan.id,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.warningYellow.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppTheme.warningYellow,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  plan.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (plan.dueDate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      dateFormat.format(plan.dueDate!),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  )
                else
                  Text(
                    AppLocalizations.of(context).get('no_date'),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textMuted.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
