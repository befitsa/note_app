import 'package:flutter/material.dart';
import 'package:note_app_2/shared/enums/note_enums.dart';
import '../common/app_colors.dart';
import '../common/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final NoteCategory category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  Color get _color {
    switch (category) {
      case NoteCategory.personal:
        return AppColors.accent;
      case NoteCategory.work:
        return AppColors.primary;
      case NoteCategory.ideas:
        return AppColors.secondary;
      case NoteCategory.todo:
        return AppColors.danger;
      case NoteCategory.other:
        return AppColors.lightTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
  
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          category.label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
