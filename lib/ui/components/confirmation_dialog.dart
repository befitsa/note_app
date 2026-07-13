import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';
import 'app_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final bool destructive;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.body,
    required this.onConfirm,
    required this.onCancel,
    this.confirmLabel = 'Confirm',
    this.destructive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              destructive ? Icons.warning_rounded : Icons.info_rounded,
              color: destructive ? AppColors.danger : AppColors.primary,
              size: 36,
            ),
            const SizedBox(height: 16),
            Text(title,
                style:
                    AppTextStyles.headline.copyWith(color: context.textPrimary)),
            const SizedBox(height: 8),
            Text(body,
                style:
                    AppTextStyles.body.copyWith(color: context.textSecondary)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    style: AppButtonStyle.ghost,
                    onPressed: onCancel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: confirmLabel,
                    style: destructive
                        ? AppButtonStyle.danger
                        : AppButtonStyle.primary,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
