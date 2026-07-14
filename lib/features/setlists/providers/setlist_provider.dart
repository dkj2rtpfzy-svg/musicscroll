import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/setlist.dart';

class SetlistNotifier extends StateNotifier<List<Setlist>> {
  SetlistNotifier() : super(const []);

  void addSetlist(String name) {
    final setlist = Setlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    state = [...state, setlist];
  }

  void removeSetlist(String id) {
    state = state.where((setlist) => setlist.id != id).toList();
  }

  void renameSetlist(String id, String newName) {
    state = state.map((setlist) {
      if (setlist.id == id) {
        return setlist.copyWith(name: newName);
      }
      return setlist;
    }).toList();
  }

  // ===========================
  // AJOUT D'UN MORCEAU
  // ===========================

  void addSong(int setlistIndex, int songIndex) {
    final setlists = [...state];

    final setlist = setlists[setlistIndex];

    // Empêche les doublons
    if (setlist.songIndexes.contains(songIndex)) {
      return;
    }

    final updated = setlist.copyWith(
      songIndexes: [
        ...setlist.songIndexes,
        songIndex,
      ],
    );

    setlists[setlistIndex] = updated;

    state = setlists;
  }

  // ===========================
  // SUPPRESSION D'UN MORCEAU
  // ===========================

  void removeSong(int setlistIndex, int songIndex) {
    final setlists = [...state];

    final setlist = setlists[setlistIndex];

    final updated = setlist.copyWith(
      songIndexes: setlist.songIndexes
          .where((index) => index != songIndex)
          .toList(),
    );

    setlists[setlistIndex] = updated;

    state = setlists;
  }
}

final setlistProvider =
    StateNotifierProvider<SetlistNotifier, List<Setlist>>(
  (ref) => SetlistNotifier(),
);