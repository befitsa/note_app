import 'package:flutter/material.dart';
import '../common/app_sizes.dart';
import '../common/ui_helpers.dart';

/// Reusable search field with a leading search icon and optional
/// trailing clear button. Used on Home and the dedicated Search screen.
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search your notes...',
    this.onFilterTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppSizes.inputRadius),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: context.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              style: TextStyle(color: context.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: context.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.close_rounded, color: context.textSecondary),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              );
            },
          ),
          if (onFilterTap != null)
            IconButton(
              icon: Icon(Icons.tune_rounded, color: context.textSecondary),
              onPressed: onFilterTap,
            ),
        ],
      ),
    );
  }
}
