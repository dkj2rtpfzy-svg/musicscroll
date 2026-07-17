import 'package:hive_flutter/hive_flutter.dart';

import '../features/setlists/models/setlist.dart';
import '../shared/models/song.dart';

class StorageService {
  static const String songsBoxName = 'songs';
  static const String setlistsBoxName = 'setlists';

  static Future<void> initialize() async {
    await Hive.openBox(songsBoxName);
    await Hive.openBox(setlistsBoxName);
  }

  static Box get _songsBox => Hive.box(songsBoxName);
  static Box get _setlistsBox => Hive.box(setlistsBoxName);

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
}