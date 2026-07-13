import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../common/app_strings.dart';
import '../../../services/notes_service.dart';
import '../../../services/theme_service.dart';
import '../../../shared/enums/note_enums.dart';

class SettingsViewModel extends ReactiveViewModel {
  final _themeService = locator<ThemeService>();
  final _notesService = locator<NotesService>();

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_themeService, _notesService];

  ThemeMode get themeMode => _themeService.themeMode;
  bool get isGridView => _themeService.isGridView;
  SortOption get sortOption => _themeService.sortOption;

  String get appVersion => AppStrings.appVersion;
  String get developer => AppStrings.developer;

  int get totalNotes => _notesService.statistics.totalNotes;
  String get storageLabel => _notesService.statistics.storageLabel;

  void setThemeMode(ThemeMode mode) => _themeService.setThemeMode(mode);
  void setGridView(bool isGrid) => _themeService.setGridView(isGrid);
  void setSortOption(SortOption option) => _themeService.setSortOption(option);
}
