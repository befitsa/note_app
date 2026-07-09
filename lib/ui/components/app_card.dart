import 'package:flutter/material.dart';
import '../common/app_sizes.dart';
import '../common/ui_helpers.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final double radius;

  const AppCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.color,
      this.onTap,
      this.radius = AppSizes.CardRadius});

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.surfaceColor;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDark ? 0.25 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: child,
        ),
      ),

    );
  }
}
