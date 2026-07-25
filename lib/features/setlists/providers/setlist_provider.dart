import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/setlist.dart';
import '../../../core/service/storage_service.dart';

class SetlistNotifier extends StateNotifier<List<Setlist>> {
  SetlistNotifier() : super(StorageService.loadSetlists());

  void _save() {
    StorageService.saveSetlists(state);
  }

  void addSetlist(String name) {
    final setlist = Setlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    state = [...state, setlist];
    _save();
  }

  void removeSetlist(String id) {
    state = state.where((setlist) => setlist.id != id).toList();
    _save();
  }

  void renameSetlist(String id, String newName) {
    state = state.map((setlist) {
      if (setlist.id == id) {
        return setlist.copyWith(name: newName);
      }
      return setlist;
    }).toList();

    _save();
  }

  void addSong(String setlistId, String songId) {
    final setlists = [...state];

    final index =
        setlists.indexWhere((setlist) => setlist.id == setlistId);

    if (index == -1) return;

    final setlist = setlists[index];

    if (setlist.songIds.contains(songId)) {
      return;
    }

    setlists[index] = setlist.copyWith(
      songIds: [
        ...setlist.songIds,
        songId,
      ],
    );

    state = setlists;
    _save();
  }

  void removeSong(String setlistId, String songId) {
    final setlists = [...state];

    final index =
        setlists.indexWhere((setlist) => setlist.id == setlistId);

    if (index == -1) return;

    final setlist = setlists[index];

    setlists[index] = setlist.copyWith(
      songIds: setlist.songIds
          .where((id) => id != songId)
          .toList(),
    );

    state = setlists;
    _save();
  }

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
    _save();
  }
}

final setlistProvider =
    StateNotifierProvider<SetlistNotifier, List<Setlist>>(
  (ref) => SetlistNotifier(),
);