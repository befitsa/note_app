import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_sizes.dart';

/// Floating action button with a gentle scale-in entrance and press
/// feedback, used for "Add Note".
class AnimatedFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const AnimatedFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
    lowerBound: 0.0,
    upperBound: 1.0,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: AppSizes.fabSize,
          width: AppSizes.fabSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
