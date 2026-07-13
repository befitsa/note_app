import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/note_model.dart';
import '../../../services/notes_service.dart';
import '../../../services/theme_service.dart';
import '../../common/app_strings.dart';
import '../../../shared/enums/note_enums.dart';

class HomeViewModel extends ReactiveViewModel {
  final _notesService = locator<NotesService>();
  final _themeService = locator<ThemeService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_notesService, _themeService];

  int _bottomNavIndex = 0;
  int get bottomNavIndex => _bottomNavIndex;

  HomeFilter _filter = HomeFilter.all;
  HomeFilter get filter => _filter;

  String _query = '';
  String get query => _query;

  bool _multiSelectMode = false;
  bool get multiSelectMode => _multiSelectMode;

  final Set<String> _selectedIds = {};
  Set<String> get selectedIds => _selectedIds;

  bool get isGridView => _themeService.isGridView;
  SortOption get sortOption => _themeService.sortOption;

  String get appName => AppStrings.appName;

  List<NoteModel> get pinnedNotes => _notesService.pinnedNotes;
  List<NoteModel> get recentNotes => _notesService.recentNotes;

  List<NoteModel> get visibleNotes {
    final filtered = _notesService.search(_query, scope: _filter);
    return _notesService.sorted(filtered, sortOption);
  }

  bool get hasAnyNotes => _notesService.allNotes.isNotEmpty;

  void onSearchChanged(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilter(HomeFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setBottomNavIndex(int index) {
    _bottomNavIndex = index;
    switch (index) {
      case 0:
        _filter = HomeFilter.all;
        break;
      case 1:
        _filter = HomeFilter.favorites;
        break;
      case 2:
        _filter = HomeFilter.archived;
        break;
      case 3:
        notifyListeners();
        try {
          _navigationService.navigateTo(Routes.settingsView);
        } catch (_) {
        }
        return;
    }
    notifyListeners();
  }

  void setSortOption(SortOption option) => _themeService.setSortOption(option);

  void toggleGridView() => _themeService.setGridView(!isGridView);

  void openSearch() => _navigationService.navigateTo(Routes.searchView);

  void openDashboard() => _navigationService.navigateTo(Routes.dashboardView);

  void openAddNote() => _navigationService.navigateTo(
        Routes.addEditNoteView,
        arguments: const AddEditNoteViewArguments(),
      );

  void openNote(NoteModel note) => _navigationService.navigateTo(
        Routes.addEditNoteView,
        arguments: AddEditNoteViewArguments(noteId: note.id),
      );

  Future<void> togglePin(String id) => _notesService.togglePin(id);

  Future<void> toggleFavorite(String id) => _notesService.toggleFavorite(id);

  void _safeSnackbar(String message) {
    try {
      _snackbarService.showSnackbar(
        message: message,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
    }
  }

  Future<void> archiveNote(NoteModel note) async {
    if (note.isArchived) return;
    final response = await _dialogService.showConfirmationDialog(
      title: AppStrings.archiveNoteTitle,
      description: AppStrings.archiveNoteBody,
      confirmationTitle: 'Archive',
      cancelTitle: 'Cancel',
    );
    if (response?.confirmed == true) {
      await _notesService.archiveNote(note.id);
      _safeSnackbar('Note archived');
    }
  }

  Future<void> restoreNote(NoteModel note) async {
    await _notesService.restoreNote(note.id);
    _safeSnackbar('Note restored');
  }

  Future<void> deletePermanently(NoteModel note) async {
    final response = await _dialogService.showConfirmationDialog(
      title: AppStrings.deletePermanentTitle,
      description: AppStrings.deletePermanentBody,
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (response?.confirmed == true) {
      await _notesService.deletePermanently(note.id);
      _safeSnackbar('Note deleted permanently');
    }
  }


  void enterMultiSelect(String firstId) {
    _multiSelectMode = true;
    _selectedIds.add(firstId);
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    if (_selectedIds.isEmpty) _multiSelectMode = false;
    notifyListeners();
  }

  void cancelMultiSelect() {
    _multiSelectMode = false;
    _selectedIds.clear();
    notifyListeners();
  }

  Future<void> archiveSelected() async {
    final count = _selectedIds.length;
    for (final id in _selectedIds) {
      await _notesService.archiveNote(id);
    }
    _safeSnackbar('$count notes archived');
    cancelMultiSelect();
  }

  Future<void> deleteSelectedPermanently() async {
    final response = await _dialogService.showConfirmationDialog(
      title: AppStrings.deletePermanentTitle,
      description: AppStrings.deletePermanentBody,
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (response?.confirmed == true) {
      await _notesService.deleteMultiplePermanently(_selectedIds);
      _safeSnackbar('Notes deleted permanently');
      cancelMultiSelect();
    }
  }
}