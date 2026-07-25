import 'package:hive_flutter/hive_flutter.dart';

import '../settings/app_settings.dart';
import '../../features/setlists/models/setlist.dart';
import '../../shared/models/song.dart';

class StorageService {
  static const String songsBoxName = 'songs';
  static const String setlistsBoxName = 'setlists';
  static const String settingsBoxName = 'settings';

  static Future<void> initialize() async {
    await Hive.openBox(songsBoxName);
    await Hive.openBox(setlistsBoxName);
    await Hive.openBox(settingsBoxName);
  }

  static Box get _songsBox => Hive.box(songsBoxName);
  static Box get _setlistsBox => Hive.box(setlistsBoxName);
  static Box get _settingsBox => Hive.box(settingsBoxName);

  // ===========================
  // SONGS
  // ===========================

  static List<Song> loadSongs() {
    final values = _songsBox.values.cast<Map>().toList();

    return values
        .map(
          (song) => Song.fromMap(
            Map<String, dynamic>.from(song),
          ),
        )
        .toList();
  }

  static Future<void> saveSongs(List<Song> songs) async {
    await _songsBox.clear();

    for (var i = 0; i < songs.length; i++) {
      await _songsBox.put(
        i,
        songs[i].toMap(),
      );
    }
  }

  // ===========================
  // SETLISTS
  // ===========================

  static List<Setlist> loadSetlists() {
    final values = _setlistsBox.values.cast<Map>().toList();

    return values
        .map(
          (setlist) => Setlist.fromMap(
            Map<String, dynamic>.from(setlist),
          ),
        )
        .toList();
  }

  static Future<void> saveSetlists(List<Setlist> setlists) async {
    await _setlistsBox.clear();

    for (var i = 0; i < setlists.length; i++) {
      await _setlistsBox.put(
        i,
        setlists[i].toMap(),
      );
    }
  }

  // ===========================
  // SETTINGS
  // ===========================

  static AppSettings loadSettings() {
    final map = _settingsBox.get('settings');

    if (map == null) {
      return AppSettings.defaults;
    }

    return AppSettings.fromMap(
      Map<String, dynamic>.from(map),
    );
  }

  static Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put(
      'settings',
      settings.toMap(),
    );
  }
}