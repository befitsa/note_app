import 'package:flutter/material.dart';
import '../shared/enums/note_enums.dart';

class AppSettings {
  ThemeMode themeMode;
  bool isGridView;
  SortOption sortOption;

  AppSettings({
    this.themeMode = ThemeMode.system,
    this.isGridView = false,
    this.sortOption = SortOption.dateModified,
  });
  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? isGridView,
    SortOption? sortOption,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      isGridView: isGridView ?? this.isGridView,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'isGridview': isGridView,
        'SortOption': sortOption.index,
      };
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: ThemeMode.values[(json['themeMode'] as int?) ?? 0],
      isGridView: json['isGridView'] as bool? ?? false,
      sortOption: SortOption.values[(json['sortOption'] as int?) ?? 0],
    );
  }
}
