import 'package:flutter/material.dart';
import '../common/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? label;

  const LoadingWidget({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          if(label != null) ...[
            const SizedBox(height: 16),
            Text(label !, style: const TextStyle(color: AppColors.lightTextPrimary),)
          ],
        ],
      ),
    );
  }
}
