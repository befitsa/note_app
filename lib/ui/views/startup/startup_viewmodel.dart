import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/notes_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _notesService = locator<NotesService>();

  Future<void> initialise() async {
    try {
      await _notesService.initialise();

      // Optional splash delay
      await Future.delayed(const Duration(milliseconds: 900));

      await _navigationService.replaceWithHomeView();
    } catch (e, s) {
      print('Startup error: $e');
      print(s);
    }
  }
}