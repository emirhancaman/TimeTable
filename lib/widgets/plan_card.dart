import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/plan_provider.dart';
import 'package:intl/intl.dart';
import '../models/plan.dart';
import '../theme/app_theme.dart';

class PlanCard extends StatefulWidget {
  final Plan plan;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _animationController.forward();
  void _onTapUp(TapUpDetails details) => _animationController.reverse();
  void _onTapCancel() => _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final dateFormat = DateFormat('d MMM', 'tr_TR');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Slidable(
        key: ValueKey(plan.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Sil',
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
          ],
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: plan.isCompleted
                  ? Border(
                      left: const BorderSide(
                        color: AppTheme.successMint,
                        width: 3,
                      ),
                      top: BorderSide(
                        color: AppTheme.successMint.withOpacity(0.15),
                        width: 0.5,
                      ),
                      right: BorderSide(
                        color: AppTheme.successMint.withOpacity(0.15),
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: AppTheme.successMint.withOpacity(0.15),
                        width: 0.5,
                      ),
                    )
                  : (isDark
                        ? null
                        : Border.all(
                            color: Colors.black.withOpacity(0.04),
                            width: 1,
                          )),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: widget.onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: plan.isCompleted
                          ? const LinearGradient(
                              colors: [AppTheme.successMint, Color(0xFF16A34A)],
                            )
                          : null,
                      color: plan.isCompleted ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      border: plan.isCompleted
                          ? null
                          : Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.25),
                              width: 1.5,
                            ),
                    ),
                    child: plan.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (plan.emoji.isNotEmpty) ...[
                            Text(
                              plan.emoji,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              plan.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: plan.isCompleted
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.4)
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Star
                          GestureDetector(
                            onTap: () {
                              context.read<PlanProvider>().togglePlanFavorite(
                                plan.id,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                plan.isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: plan.isFavorite
                                    ? AppTheme.warningYellow
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.2),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (plan.description != null &&
                          plan.description!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          plan.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface
                                .withOpacity(plan.isCompleted ? 0.3 : 0.5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Consumer<PlanProvider>(
                            builder: (context, provider, _) {
                              String categoryLabel = plan.category;
                              try {
                                final category = provider.categories.firstWhere(
                                  (c) => c.id == plan.category,
                                );
                                categoryLabel = category.name;
                              } catch (_) {}
                              if (plan.subCategory != null &&
                                  plan.subCategory!.isNotEmpty) {
                                categoryLabel += ' > ${plan.subCategory}';
                              }
                              return _buildTag(
                                categoryLabel,
                                AppTheme.primaryPurple.withOpacity(0.12),
                                AppTheme.primaryPurpleLight,
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          _buildPriorityIndicator(plan.priority),
                          if (plan.dueDate != null) ...[
                            const SizedBox(width: 6),
                            _buildTag(
                              dateFormat.format(plan.dueDate!),
                              _getDueDateColor(plan.dueDate!).withOpacity(0.12),
                              _getDueDateColor(plan.dueDate!),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (!plan.isCompleted)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.2),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(int priority) {
    final color = AppTheme.getPriorityColor(priority);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 3,
          height: 10,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: index < priority ? color : color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = due.difference(today).inDays;

    if (difference < 0) return AppTheme.errorRed;
    if (difference == 0) return AppTheme.warningYellow;
    if (difference <= 3) return AppTheme.accentCoral;
    return AppTheme.textSecondary;
  }
}
