import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/song_provider.dart';
import '../providers/setlist_provider.dart';

class SetlistDetailScreen extends ConsumerWidget {
  final String setlistId;

  const SetlistDetailScreen({
    super.key,
    required this.setlistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songProvider);
    final setlists = ref.watch(setlistProvider);

    final setlist = setlists.firstWhere(
      (setlist) => setlist.id == setlistId,
    );

    final setlistSongs = setlist.songIds
        .map(
          (id) => songs.firstWhere(
            (song) => song.id == id,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(setlist.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Réorganisation disponible au prochain sprint.",
              ),
            ),
          );
        },
        child: const Icon(Icons.reorder),
      ),
      body: setlistSongs.isEmpty
          ? const Center(
              child: Text(
                "Cette setlist ne contient encore aucun morceau.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: setlistSongs.length,
              itemBuilder: (context, index) {
                final song = setlistSongs[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text("${index + 1}"),
                    ),
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    trailing: Text(
                      song.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}