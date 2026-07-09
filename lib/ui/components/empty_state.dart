import 'package:flutter/material.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';

/// Friendly illustration + message shown when a list has nothing to show
/// (no notes, no search results, empty archive/favorites...).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: context.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.headline.copyWith(color: context.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(color: context.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
