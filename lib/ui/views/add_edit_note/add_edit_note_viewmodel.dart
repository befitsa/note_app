import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../common/app_colors.dart';
import '../../common/app_strings.dart';
import '../../../models/note_model.dart';
import '../../../services/notes_service.dart';
import '../../../shared/enums/note_enums.dart';
import '../../../shared/utils/app_snackbar.dart';

class AddEditNoteViewModel extends BaseViewModel {
  final _notesService = locator<NotesService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String? _noteId;
  bool get isEditing => _noteId != null;

  NoteCategory _category = NoteCategory.other;
  NoteCategory get category => _category;

  int _colorValue = AppColors.noteSwatches.first.value;
  int get colorValue => _colorValue;

  bool _isPinned = false;
  bool get isPinned => _isPinned;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Timer? _autoSaveTimer;
  bool _dirty = false;

  int get characterCount => contentController.text.length;

  void init(String? noteId) {
    _noteId = noteId;
    if (noteId != null) {
      final note = _notesService.getById(noteId);
      if (note != null) {
        titleController.text = note.title;
        contentController.text = note.content;
        _category = note.category;
        _colorValue = note.colorValue;
        _isPinned = note.isPinned;
        _isFavorite = note.isFavorite;
      }
    }
    titleController.addListener(_scheduleAutoSave);
    contentController.addListener(_scheduleAutoSave);
  }

  void _scheduleAutoSave() {
    _dirty = true;
    notifyListeners(); // keep the character counter live
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 1, milliseconds: 200), () {
      if (_dirty && (titleController.text.isNotEmpty || contentController.text.isNotEmpty)) {
        _save(showSnackbar: false);
      }
    });
  }

  void setCategory(NoteCategory value) {
    _category = value;
    notifyListeners();
    _scheduleAutoSave();
  }

  void setColor(int value) {
    _colorValue = value;
    notifyListeners();
    _scheduleAutoSave();
  }

  void togglePin() {
    _isPinned = !_isPinned;
    notifyListeners();
    _scheduleAutoSave();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
    _scheduleAutoSave();
  }

  Future<void> saveAndClose() async {
    await _save();
    _navigationService.back();
  }

  Future<void> _save({bool showSnackbar = true}) async {
    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      return;
    }
    _dirty = false;
    if (_noteId == null) {
      final note = await _notesService.createNote(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        category: _category,
        colorValue: _colorValue,
      );
      _noteId = note.id;
      if (_isPinned || _isFavorite) {
        await _notesService.updateNote(
          note.id,
          isPinned: _isPinned,
          isFavorite: _isFavorite,
        );
      }
    } else {
      await _notesService.updateNote(
        _noteId!,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        category: _category,
        colorValue: _colorValue,
        isPinned: _isPinned,
        isFavorite: _isFavorite,
      );
    }
    if (showSnackbar) {
      try {
        showAppSnackbar('Note saved successfully');
      } catch (_) {
      }
    }
  }

  Future<void> deleteNote() async {
    if (_noteId == null) {
      _navigationService.back();
      return;
    }
    final response = await _dialogService.showConfirmationDialog(
      title: AppStrings.deleteNoteTitle,
      description: AppStrings.deleteNoteBody,
      confirmationTitle: 'Archive',
      cancelTitle: 'Cancel',
    );
    if (response?.confirmed == true) {
      await _notesService.archiveNote(_noteId!);
      try {
        showAppSnackbar('Note archived');
      } catch (_) {
      }
      _navigationService.back();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    if (_dirty) {
      _save(showSnackbar: false);
    }
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}