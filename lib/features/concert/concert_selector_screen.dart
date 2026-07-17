import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import 'concert_screen.dart';

class ConcertSelectorScreen extends ConsumerWidget {
  const ConcertSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir un morceau"),
      ),
      body: songs.isEmpty
          ? const Center(
              child: Text(
                "Aucun morceau disponible.",
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.separated(
              itemCount: songs.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final song = songs[index];

                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConcertScreen(song: song),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}