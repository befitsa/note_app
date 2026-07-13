import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../../shared/enums/note_enums.dart';
import '../../common/app_text_styles.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_text_field.dart';
import '../../common/ui_helpers.dart';
import 'add_edit_note_viewmodel.dart';

class AddEditNoteView extends StackedView<AddEditNoteViewModel> {
  final String? noteId;
  const AddEditNoteView({super.key, this.noteId});

  @override
  Widget builder(
      BuildContext context, AddEditNoteViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: CustomAppBar(
        title: viewModel.isEditing ? 'Edit Note' : 'New Note',
        actions: [
          IconButton(
            icon: Icon(
              viewModel.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: viewModel.isPinned ? AppColors.primary : context.textSecondary,
            ),
            onPressed: viewModel.togglePin,
          ),
          IconButton(
            icon: Icon(
              viewModel.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: viewModel.isFavorite ? AppColors.danger : context.textSecondary,
            ),
            onPressed: viewModel.toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: context.textSecondary),
            onPressed: viewModel.deleteNote,
          ),
          horizontalSpaceSmall,
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            CustomTextField(
              controller: viewModel.titleController,
              hint: 'Title',
              style: AppTextStyles.headline.copyWith(color: context.textPrimary),
              showBorder: false,
              autofocus: !viewModel.isEditing,
            ),
            const SizedBox(height: AppSpacing.sm),
            _CategoryDropdown(viewModel: viewModel),
            const SizedBox(height: AppSpacing.sm),
            _ColorPicker(viewModel: viewModel),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: viewModel.contentController,
              hint: 'Start writing...',
              maxLines: 14,
              showBorder: false,
            ),
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${viewModel.characterCount} characters',
                style: AppTextStyles.caption.copyWith(color: context.textSecondary),
              ),
            ),
          ],
        ),
        
      ),
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(56),
  child: SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton.icon(
      onPressed: viewModel.saveAndClose,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: const Icon(
        Icons.check_rounded),
      label: const Text(
        'Save Note',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),
),
     
    );
  }

  @override
  AddEditNoteViewModel viewModelBuilder(BuildContext context) =>
      AddEditNoteViewModel();

  @override
  void onViewModelReady(AddEditNoteViewModel viewModel) =>
      viewModel.init(noteId);
}

class _CategoryDropdown extends StatelessWidget {
  final AddEditNoteViewModel viewModel;
  const _CategoryDropdown({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<NoteCategory>(
          value: viewModel.category,
          isExpanded: true,
          icon: Icon(Icons.expand_more_rounded, color: context.textSecondary),
          items: NoteCategory.values
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.label,
                        style: TextStyle(color: context.textPrimary)),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) viewModel.setCategory(value);
          },
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final AddEditNoteViewModel viewModel;
  const _ColorPicker({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.noteSwatches.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final color = AppColors.noteSwatches[index];
          final selected = color.value == viewModel.colorValue;
          return GestureDetector(
            onTap: () => viewModel.setColor(color.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : context.borderColor,
                  width: selected ? 3 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
