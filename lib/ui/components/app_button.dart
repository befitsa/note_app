import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_sizes.dart';
import '../common/app_text_styles.dart';

enum AppButtonStyle { primary, secondary, danger, ghost }

/// A single, reusable button that covers every button style needed across
/// NotesHub (primary CTA, secondary, destructive, ghost/text).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(style);

    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation(colors.foreground),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSizes.iconSm, color: colors.foreground),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: colors.foreground),
                ),
              ],
            ),
    );

    return SizedBox(
      width: expand ? double.infinity : null,
      height: 52,
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              border: colors.border != null
                  ? Border.all(color: colors.border!)
                  : null,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }

  _ButtonColors _colorsFor(AppButtonStyle style) {
    switch (style) {
      case AppButtonStyle.primary:
        return _ButtonColors(AppColors.primary, Colors.white, null);
      case AppButtonStyle.secondary:
        return _ButtonColors(
            AppColors.primary.withValues(alpha: 0.12), AppColors.primary, null);
      case AppButtonStyle.danger:
        return _ButtonColors(AppColors.danger, Colors.white, null);
      case AppButtonStyle.ghost:
        return _ButtonColors(
            Colors.transparent, AppColors.primary, AppColors.lightBorder);
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;
  _ButtonColors(this.background, this.foreground, this.border);
}
