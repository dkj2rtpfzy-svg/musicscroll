import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/song_provider.dart';
import '../models/setlist.dart';

class SetlistDetailScreen extends ConsumerWidget {
  final Setlist setlist;

  const SetlistDetailScreen({
    super.key,
    required this.setlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(setlist.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Ajout de morceaux disponible au prochain sprint.",
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: setlist.songIndexes.isEmpty
          ? const Center(
              child: Text(
                "Cette setlist ne contient encore aucun morceau.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: setlist.songIndexes.length,
              itemBuilder: (context, index) {
                final songIndex = setlist.songIndexes[index];

                if (songIndex >= songs.length) {
                  return const SizedBox.shrink();
                }

                final song = songs[songIndex];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.music_note),
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