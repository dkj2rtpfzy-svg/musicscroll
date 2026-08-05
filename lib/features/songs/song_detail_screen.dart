import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/song.dart';
import '../../features/concert/concert_screen.dart';
import '../../features/setlists/widgets/select_setlist_dialog.dart';
import 'song_editor_screen.dart';
import '../../shared/widgets/chord_pro_viewer.dart';
class SongDetailScreen extends ConsumerWidget {
  final Song song;
  final int songIndex;

  const SongDetailScreen({
    super.key,
    required this.song,
    required this.songIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Modifier",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongEditorScreen(
                    song: song,
                    songIndex: songIndex,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            song.title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.artist,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => SelectSetlistDialog(
                        songId: song.id,
                      ),
                    );
                  },
                  icon: const Icon(Icons.queue_music),
                  label: const Text("Setlist"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConcertScreen(
                          song: song,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text("Concert"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Tonalité"),
              trailing: Text(song.key),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.speed),
              title: const Text("Tempo"),
              trailing: Text("${song.bpm} BPM"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(
                song.favorite
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
              ),
              title: const Text("Favori"),
              trailing: Text(song.favorite ? "Oui" : "Non"),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Paroles",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

         ChordProViewer(
  lyrics: song.lyrics,

          ),
        ],
      ),
    );
  }
}