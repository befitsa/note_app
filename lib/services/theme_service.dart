import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../models/app_settings.dart';
import '../shared/enums/note_enums.dart';
import '../shared/utils/change_signal.dart';
import 'storage_service.dart';


class ThemeService with ListenableServiceMixin {
  final StorageService _storageService;

  ThemeService(this._storageService) {
    listenToReactiveValues([_signal]);
  }

  final ChangeSignal _signal = ChangeSignal();

  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  bool get isGridView => _settings.isGridView;
  SortOption get sortOption => _settings.sortOption;

  Future<void> initialise() async {
    _settings = _storageService.loadSettings();
    _signal.bump();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    _signal.bump();
    await _storageService.saveSettings(_settings);
  }

  Future<void> setGridView(bool isGrid) async {
    _settings = _settings.copyWith(isGridView: isGrid);
    _signal.bump();
    await _storageService.saveSettings(_settings);
  }

  Future<void> setSortOption(SortOption option) async {
    _settings = _settings.copyWith(sortOption: option);
    _signal.bump();
    await _storageService.saveSettings(_settings);
  }
}
