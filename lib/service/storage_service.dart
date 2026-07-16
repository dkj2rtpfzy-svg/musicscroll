import 'package:hive_flutter/hive_flutter.dart';

import '../shared/models/song.dart';

class StorageService {
  static const String songsBoxName = 'songs';

  static Future<void> initialize() async {
    await Hive.openBox(songsBoxName);
  }

  static Box get _songsBox => Hive.box(songsBoxName);

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
}