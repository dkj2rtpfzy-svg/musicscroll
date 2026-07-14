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
}

final setlistProvider =
    StateNotifierProvider<SetlistNotifier, List<Setlist>>(
  (ref) => SetlistNotifier(),
);