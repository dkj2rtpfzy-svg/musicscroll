import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/storage_service.dart';
import '../shared/models/song.dart';

class SongNotifier extends StateNotifier<List<Song>> {
  SongNotifier() : super(_loadSongs());

  static List<Song> _loadSongs() {
    final songs = StorageService.loadSongs();

    if (songs.isNotEmpty) {
      return songs;
    }

    final defaultSongs = [
      const Song(
        id: "song_001",
        title: "Amazing Grace",
        artist: "Traditionnel",
        key: "G",
        bpm: 90,
        lyrics: """
Amazing Grace
How sweet the sound
That saved a wretch like me.
""",
        favorite: true,
      ),
      const Song(
        id: "song_002",
        title: "Hallelujah",
        artist: "Leonard Cohen",
        key: "C",
        bpm: 72,
      ),
      const Song(
        id: "song_003",
        title: "Hosanna",
        artist: "Hillsong",
        key: "D",
        bpm: 128,
      ),
    ];

    StorageService.saveSongs(defaultSongs);

    return defaultSongs;
  }

  void _save() {
    StorageService.saveSongs(state);
  }

  void addSong(Song song) {
    state = [...state, song];
    _save();
  }

  void updateSong(int index, Song song) {
    final songs = [...state];
    songs[index] = song;
    state = songs;
    _save();
  }

  void removeSong(int index) {
    final songs = [...state];
    songs.removeAt(index);
    state = songs;
    _save();
  }

  void toggleFavorite(int index) {
    final songs = [...state];

    songs[index] = songs[index].copyWith(
      favorite: !songs[index].favorite,
    );

    state = songs;
    _save();
  }
}

final songProvider = StateNotifierProvider<SongNotifier, List<Song>>(
  (ref) => SongNotifier(),
);