import 'package:flutter/material.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

class StatisticsTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const StatisticsTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: context.textSecondary),
            const SizedBox(width: 10),
          ],
          Text(label,
              style: AppTextStyles.body.copyWith(color: context.textSecondary)),
          const Spacer(),
          Text(value,
              style:
                  AppTextStyles.bodyStrong.copyWith(color: context.textPrimary)),
        ],
      ),
    );
  }
}
