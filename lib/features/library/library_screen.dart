
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'apple_music_search_screen.dart';
import '../../providers/song_provider.dart';
import '../../shared/models/song.dart';
import '../songs/song_detail_screen.dart';
import '../songs/song_form_screen.dart';
import '../setlists/models/setlist.dart';
import '../setlists/services/setlist_share_service.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _shareSong(Song song) async {
    try {
      final link = await SetlistShareService.createShareLink(
        setlist: Setlist(
          id: 'single-${song.id}',
          name: song.title,
          songIds: [song.id],
        ),
        allSongs: [song],
      );

      await SetlistShareService.shareLink(
        link: link,
        setlistName: song.title,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Impossible de partager : $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songProvider);

    final filteredSongs = songs.where((song) {
      final q = search.toLowerCase();

      return song.title.toLowerCase().contains(q) ||
          song.artist.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliothèque"),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music),
            tooltip: "Rechercher dans le catalogue Apple Music",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppleMusicSearchScreen(),
                ),
              );
            },
          ),
        ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un morceau...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                final originalIndex = songs.indexOf(song);

                return Dismissible(
                  key: ValueKey("${song.title}-$originalIndex"),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    ref.read(songProvider.notifier).removeSong(originalIndex);

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("${song.title} supprimé"),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: "ANNULER",
                            onPressed: () {
                              ref
                                  .read(songProvider.notifier)
                                  .insertSong(originalIndex, song);
                            },
                          ),
                        ),
                      );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.music_note),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share),
                            tooltip: "Partager ce morceau",
                            onPressed: () => _shareSong(song),
                          ),
                          IconButton(
                            icon: Icon(
                              song.favorite
                                  ? Icons.star
                                  : Icons.star_border,
                              color: song.favorite
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              ref
                                  .read(songProvider.notifier)
                                  .toggleFavorite(originalIndex);
                            },
                          ),
                          Text(
                            song.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongDetailScreen(
                              song: song,
                              songIndex: originalIndex,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
