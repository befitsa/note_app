import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/note_model.dart';
import '../../../services/notes_service.dart';
import '../../../shared/enums/note_enums.dart';

class SearchViewModel extends ReactiveViewModel {
  final _notesService = locator<NotesService>();
  final _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_notesService];

  String _query = '';
  String get query => _query;

  HomeFilter _scope = HomeFilter.all;
  HomeFilter get scope => _scope;

  List<NoteModel> get results =>
      _query.isEmpty ? [] : _notesService.search(_query, scope: _scope);

  void onQueryChanged(String value) {
    _query = value;
    notifyListeners();
  }

  void setScope(HomeFilter scope) {
    _scope = scope;
    notifyListeners();
  }

  void openNote(NoteModel note) => _navigationService.navigateTo(
        Routes.addEditNoteView,
        arguments: AddEditNoteViewArguments(noteId: note.id),
      );
}
