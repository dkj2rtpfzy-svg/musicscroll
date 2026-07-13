import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/models/song.dart';

class SongNotifier extends StateNotifier<List<Song>> {
  SongNotifier()
      : super([
          const Song(
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
            title: "Hallelujah",
            artist: "Leonard Cohen",
            key: "C",
            bpm: 72,
          ),
          const Song(
            title: "Hosanna",
            artist: "Hillsong",
            key: "D",
            bpm: 128,
          ),
        ]);

  void addSong(Song song) {
    state = [...state, song];
  }

  void updateSong(int index, Song song) {
    final songs = [...state];
    songs[index] = song;
    state = songs;
  }

  void removeSong(int index) {
    final songs = [...state];
    songs.removeAt(index);
    state = songs;
  }

  void toggleFavorite(int index) {
    final songs = [...state];

    songs[index] = songs[index].copyWith(
      favorite: !songs[index].favorite,
    );

    state = songs;
  }
}

final songProvider =
    StateNotifierProvider<SongNotifier, List<Song>>(
  (ref) => SongNotifier(),
);