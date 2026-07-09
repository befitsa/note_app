import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_edit_note_viewmodel.dart';

class AddEditNoteView extends StackedView<AddEditNoteViewModel> {
  final String? noteId;

  const AddEditNoteView({
    Key? key,
    this.noteId,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddEditNoteViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: Text(
            noteId == null
                ? "Add New Note"
                : "Edit Note ID: $noteId",
          ),
        ),
      ),
    );
  }

  @override
  AddEditNoteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddEditNoteViewModel();
}