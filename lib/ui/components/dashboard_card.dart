import 'package:flutter/material.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';
import 'app_card.dart';

class DashboardCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.toDouble()),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return AppCard(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon,color: color, size: 22),
                ),
                const SizedBox(height: 14),
                Text(
                  animatedValue.round().toString(),
                  style: AppTextStyles.statNumber.copyWith(
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: context.textSecondary,
                  ),
                )
              ],
            ),
          );
        },
        );
  }
}
