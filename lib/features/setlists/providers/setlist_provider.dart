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

  void addSong(String setlistId, String songId) {
    final setlists = [...state];

    final index =
        setlists.indexWhere((setlist) => setlist.id == setlistId);

    if (index == -1) return;

    final setlist = setlists[index];

    if (setlist.songIds.contains(songId)) {
      return;
    }

    final updated = setlist.copyWith(
      songIds: [
        ...setlist.songIds,
        songId,
      ],
    );

    setlists[index] = updated;

    state = setlists;
  }

  // ===========================
  // SUPPRESSION
  // ===========================

  void removeSong(String setlistId, String songId) {
    final setlists = [...state];

    final index =
        setlists.indexWhere((setlist) => setlist.id == setlistId);

    if (index == -1) return;

    final setlist = setlists[index];

    final updated = setlist.copyWith(
      songIds: setlist.songIds
          .where((id) => id != songId)
          .toList(),
    );

    setlists[index] = updated;

    state = setlists;
  }

  // ===========================
  // RÉORGANISATION
  // ===========================

  void reorderSongs(
    String setlistId,
    int oldIndex,
    int newIndex,
  ) {
    final setlists = [...state];

    final index =
        setlists.indexWhere((setlist) => setlist.id == setlistId);

    if (index == -1) return;

    final setlist = setlists[index];

    final songs = [...setlist.songIds];

    if (newIndex > oldIndex) {
      newIndex--;
    }

    final item = songs.removeAt(oldIndex);

    songs.insert(newIndex, item);

    setlists[index] = setlist.copyWith(
      songIds: songs,
    );

    state = setlists;
  }
}

final setlistProvider =
    StateNotifierProvider<SetlistNotifier, List<Setlist>>(
  (ref) => SetlistNotifier(),
);