import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../songs/song_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songProvider);
    final favorites = songs.where((song) => song.favorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoris"),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "Aucun favori",
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites[index];

                return ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: Text(song.key),
                  onTap: () {
                    final songIndex =
                        songs.indexWhere((s) => s.id == song.id);

                    if (songIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Impossible d'ouvrir ce morceau.",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongDetailScreen(
                          song: song,
                          songIndex: songIndex,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}