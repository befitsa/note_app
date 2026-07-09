import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../models/app_settings.dart';

/// Thin wrapper around [SharedPreferences] responsible for reading and
/// writing everything NotesHub needs to persist: notes and app settings.
///
/// Keeping all raw key names and JSON encode/decode logic in one place
/// means the rest of the app never has to know how persistence works.
class StorageService {
  static const String _kNotesKey = 'noteshub.notes';
  static const String _kSettingsKey = 'noteshub.settings';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('StorageService.init() must be called before use.');
    }
    return prefs;
  }

  // Notes

  Future<void> saveNotes(List<NoteModel> notes) async {
    final raw = jsonEncode(notes.map((n) => n.toJson()).toList());
    await _instance.setString(_kNotesKey, raw);
  }

  List<NoteModel> loadNotes() {
    final raw = _instance.getString(_kNotesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Settings

  Future<void> saveSettings(AppSettings settings) async {
    await _instance.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }

  AppSettings loadSettings() {
    final raw = _instance.getString(_kSettingsKey);
    if (raw == null || raw.isEmpty) return AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return AppSettings();
    }
  }
}
