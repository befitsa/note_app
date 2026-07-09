import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../models/dashboard_statistics.dart';
import '../../../models/note_model.dart';
import '../../../services/notes_service.dart';

/// Supplies the aggregated numbers shown on the Dashboard screen.
class DashboardViewModel extends ReactiveViewModel {
  final _notesService = locator<NotesService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_notesService];

  DashboardStatistics get statistics => _notesService.statistics;

  List<NoteModel> get recentNotes => _notesService.recentNotes;
}
