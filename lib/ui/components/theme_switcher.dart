import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

/// Segmented control for Light / Dark / System theme selection, used on
/// the Settings screen.
class ThemeSwitcher extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  const ThemeSwitcher({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: ThemeMode.values.map((mode) {
          final selected = mode == currentMode;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  _label(mode),
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: selected ? Colors.white : context.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}
