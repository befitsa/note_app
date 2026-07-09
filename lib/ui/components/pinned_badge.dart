import 'package:flutter/material.dart';
import '../common/app_colors.dart';

class PinnedBadge extends StatelessWidget {
  const PinnedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.push_pin_rounded,
      size: 14,
      color: AppColors.secondary,
    );
  }
}