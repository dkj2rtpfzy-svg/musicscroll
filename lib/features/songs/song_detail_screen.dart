import 'package:flutter/material.dart';

import '../../shared/models/song.dart';
import 'song_editor_screen.dart';

class SongDetailScreen extends StatelessWidget {
  final Song song;
  final int songIndex;

  const SongDetailScreen({
    super.key,
    required this.song,
    required this.songIndex,
  });

  @override
  Widget build(BuildContext context) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Gestion des Setlists disponible au prochain sprint.",
                        ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Mode Concert en préparation.",
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

          Text(
            song.lyrics.isEmpty
                ? "Aucune parole disponible."
                : song.lyrics,
            style: const TextStyle(
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}