import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_edit_note_viewmodel.dart';

class AddEditNoteView extends StackedView<AddEditNoteViewModel> {
  const AddEditNoteView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddEditNoteViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("AddEditNoteView")),
      ),
    );
  }

  @override
  AddEditNoteViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddEditNoteViewModel();
}
