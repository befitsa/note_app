import 'package:stacked/stacked.dart';
import '../models/note_model.dart';
import '../models/dashboard_statistics.dart';
import '../shared/enums/note_enums.dart';
import '../shared/utils/change_signal.dart';
import 'storage_service.dart';


class NotesService with ListenableServiceMixin {
  final StorageService _storageService;

  NotesService(this._storageService) {
    listenToReactiveValues([_signal]);
  }

  final List<NoteModel> _notes = [];
  final ChangeSignal _signal = ChangeSignal();

  void _bump() => _signal.bump();

  bool _initialized = false;

  // All notes, most-recently-updated first, unfiltered.

  List<NoteModel> get allNotes => List.unmodifiable(_notes);

  List<NoteModel> get activeNotes =>
      _notes.where((n) => !n.isArchived).toList();

  List<NoteModel> get archivedNotes =>
      _notes.where((n) => n.isArchived).toList();

  List<NoteModel> get pinnedNotes =>
      _notes.where((n) => n.isPinned && !n.isArchived).toList();

  List<NoteModel> get favoriteNotes =>
      _notes.where((n) => n.isFavorite && !n.isArchived).toList();

  List<NoteModel> get recentNotes {
    final list = activeNotes;
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list.take(5).toList();
  }

  DashboardStatistics get statistics {
    final active = activeNotes;
    final totalChars =
        _notes.fold<int>(0, (sum, n) => sum + n.characterCount);
    return DashboardStatistics(
      totalNotes: active.length,
      pinnedNotes: pinnedNotes.length,
      archivedNotes: archivedNotes.length,
      favoriteNotes: favoriteNotes.length,
      totalCharacters: totalChars,
    );
  }

  Future<void> initialise() async {
    if (_initialized) return;
    final saved = _storageService.loadNotes();
    _notes
      ..clear()
      ..addAll(saved);
    _initialized = true;
    _bump();
  }

  Future<void> _persist() => _storageService.saveNotes(_notes);

  // CRUD

  Future<NoteModel> createNote({
    required String title,
    required String content,
    NoteCategory category = NoteCategory.other,
    required int colorValue,
  }) async {
    final now = DateTime.now();
    final note = NoteModel(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      category: category,
      colorValue: colorValue,
      createdAt: now,
      updatedAt: now,
    );
    _notes.insert(0, note);
    _bump();
    await _persist();
    return note;
  }

  Future<void> updateNote(
    String id, {
    String? title,
    String? content,
    NoteCategory? category,
    int? colorValue,
    bool? isPinned,
    bool? isFavorite,
  }) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      title: title,
      content: content,
      category: category,
      colorValue: colorValue,
      isPinned: isPinned,
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );
    _bump();
    await _persist();
  }

  Future<void> archiveNote(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      isArchived: true,
      isPinned: false,
      updatedAt: DateTime.now(),
    );
    _bump();
    await _persist();
  }

  Future<void> restoreNote(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      isArchived: false,
      updatedAt: DateTime.now(),
    );
    _bump();
    await _persist();
  }

  Future<void> deletePermanently(String id) async {
    _notes.removeWhere((n) => n.id == id);
    _bump();
    await _persist();
  }

  Future<void> deleteMultiplePermanently(Iterable<String> ids) async {
    _notes.removeWhere((n) => ids.contains(n.id));
    _bump();
    await _persist();
  }

  Future<void> togglePin(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index]
        .copyWith(isPinned: !_notes[index].isPinned, updatedAt: DateTime.now());
    _bump();
    await _persist();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _notes.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notes[index] = _notes[index].copyWith(
      isFavorite: !_notes[index].isFavorite,
      updatedAt: DateTime.now(),
    );
    _bump();
    await _persist();
  }

  NoteModel? getById(String id) {
    try {
      return _notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------
  // Search / filter / sort
  // ---------------------------------------------------------------------

  List<NoteModel> search(
    String query, {
    HomeFilter scope = HomeFilter.all,
  }) {
    final q = query.trim().toLowerCase();
    Iterable<NoteModel> source;
    switch (scope) {
      case HomeFilter.pinned:
        source = pinnedNotes;
        break;
      case HomeFilter.favorites:
        source = favoriteNotes;
        break;
      case HomeFilter.archived:
        source = archivedNotes;
        break;
      case HomeFilter.all:
        source = activeNotes;
        break;
    }
    if (q.isEmpty) return source.toList();
    return source
        .where((n) =>
            n.title.toLowerCase().contains(q) ||
            n.content.toLowerCase().contains(q))
        .toList();
  }

  List<NoteModel> sorted(List<NoteModel> notes, SortOption option) {
    final list = List<NoteModel>.from(notes);
    switch (option) {
      case SortOption.dateModified:
        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOption.dateCreated:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.title:
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.category:
        list.sort((a, b) => a.category.index.compareTo(b.category.index));
        break;
    }
    // Pinned notes always float to the top regardless of sort option.
    list.sort((a, b) {
      if (a.isPinned == b.isPinned) return 0;
      return a.isPinned ? -1 : 1;
    });
    return list;
  }
}
