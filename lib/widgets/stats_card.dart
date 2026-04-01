import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  final int totalPlans;
  final int completedPlans;
  final int pendingPlans;
  final double completionRate;

  const StatsCard({
    super.key,
    required this.totalPlans,
    required this.completedPlans,
    required this.pendingPlans,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple.withOpacity(0.3),
                  AppTheme.darkCard.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              border: Border.all(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bugünkü İlerleme',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(completionRate * 100).toInt()}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                height: 1,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8, left: 4),
                              child: Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryPurpleLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Circular progress
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 8,
                              backgroundColor: AppTheme.darkCard,
                              valueColor: AlwaysStoppedAnimation(
                                AppTheme.textMuted.withOpacity(0.2),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: completionRate),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 8,
                                  strokeCap: StrokeCap.round,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.successMint,
                                  ),
                                );
                              },
                            ),
                          ),
                          Center(
                            child: Text(
                              '✨',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Stats row
                Row(
                  children: [
                    _buildStatItem(
                      'Toplam',
                      totalPlans.toString(),
                      AppTheme.primaryPurpleLight,
                    ),
                    _buildDivider(),
                    _buildStatItem(
                      'Tamamlanan',
                      completedPlans.toString(),
                      AppTheme.successMint,
                    ),
                    _buildDivider(),
                    _buildStatItem(
                      'Bekleyen',
                      pendingPlans.toString(),
                      AppTheme.accentCoral,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppTheme.textMuted.withOpacity(0.2),
    );
  }
}
