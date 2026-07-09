import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 0, 20, 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.35 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final Selected = index == currentIndex;
                final item = items[index];
                return GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical:8),
                    decoration: BoxDecoration(
                      color: Selected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Selected ? item.activeIcon : item.icon,
                          color: Selected ? AppColors.primary : context.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: AppTextStyles.caption.copyWith(
                            color: Selected 
                            ? AppColors.primary
                            : context.textSecondary,
                            fontWeight: Selected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                    ),
                );
              }),
            ),
          )),
    );
  }
}
