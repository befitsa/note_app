import 'package:flutter/material.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.headline.copyWith(color: context.textPrimary),
        ),
        if(actionLabel != null )
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel!,
            style: AppTextStyles.bodyStrong
            .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
