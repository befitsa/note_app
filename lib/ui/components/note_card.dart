import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../../shared/enums/note_enums.dart';
import '../common/app_text_styles.dart';
import '../common/ui_helpers.dart';
import 'category_chip.dart';
import 'favorite_icon.dart';
import 'pinned_badge.dart';

/// Card representing a single note in a list/grid, with swipe-to-archive
/// and swipe-to-favorite gestures.
class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onArchive;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTogglePin;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool>? onSelectChanged;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onArchive,
    required this.onToggleFavorite,
    required this.onTogglePin,
    this.selectable = false,
    this.selected = false,
    this.onSelectChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(note.colorValue);

    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: const Icon(Icons.archive_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        onArchive();
        return false; // we handle removal via the service/list rebuild
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          color: note.colorValue == 0xFFFFFFFF ? context.surfaceColor : bgColor,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: selectable
                ? () => onSelectChanged?.call(!selected)
                : onTap,
            onLongPress: () => onSelectChanged?.call(!selected),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: selected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2)
                    : Border.all(color: context.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (note.isPinned) const PinnedBadge(),
                      if (note.isPinned) const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          note.title.isEmpty ? 'Untitled' : note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title
                              .copyWith(color: context.textPrimary),
                        ),
                      ),
                      FavoriteIcon(
                        isFavorite: note.isFavorite,
                        onTap: onToggleFavorite,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.content.isEmpty ? 'No additional text' : note.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CategoryChip(category: note.category),
                      const Spacer(),
                      Text(
                        timeAgo(note.updatedAt),
                        style: AppTextStyles.caption
                            .copyWith(color: context.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
