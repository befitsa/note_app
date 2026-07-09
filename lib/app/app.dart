import 'package:note_app_2/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:note_app_2/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:note_app_2/ui/views/home/home_view.dart';
import 'package:note_app_2/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:note_app_2/ui/views/dashboard/dashboard_view.dart';
import 'package:note_app_2/ui/views/add_edit_note/add_edit_note_view.dart';
import 'package:note_app_2/ui/views/search/search_view.dart';
import 'package:note_app_2/ui/views/settings/settings_view.dart';
import 'package:note_app_2/services/storage_service.dart';
import 'package:note_app_2/services/theme_service.dart';
import 'package:note_app_2/services/notes_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: AddEditNoteView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: SettingsView),
// @stacked-route
  ],
 dependencies: [
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: SnackbarService),

  LazySingleton(classType: StorageService),
  LazySingleton(classType: ThemeService),
  LazySingleton(classType: NotesService),

  // @stacked-service
],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
