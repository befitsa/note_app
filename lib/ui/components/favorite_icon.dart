import 'package:flutter/material.dart';
import '../common/app_colors.dart';

class FavoriteIcon extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;


  const FavoriteIcon({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 22,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => 
        ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(isFavorite),
          color: isFavorite ? AppColors.danger : Colors.grey,
          size: size,
        ),
        ),
    );
  }
}
