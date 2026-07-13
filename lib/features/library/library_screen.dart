import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../songs/song_detail_screen.dart';
import '../songs/song_form_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliothèque"),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter un morceau",
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SongFormScreen(),
            ),
          );
        },
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  song.favorite
                      ? Icons.star
                      : Icons.music_note,
                ),
              ),
              title: Text(song.title),
              subtitle: Text(song.artist),
              trailing: Text(
                song.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongDetailScreen(
                      song: song,
                      songIndex: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}