import 'package:flutter/material.dart';

import '../../shared/models/song.dart';
import '../songs/song_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = [
      const Song(
        title: "Amazing Grace",
        artist: "Traditionnel",
        key: "G",
        bpm: 90,
        lyrics: """
Amazing Grace
How sweet the sound
That saved a wretch like me.

I once was lost,
but now am found,
Was blind, but now I see.
""",
        favorite: true,
      ),
      const Song(
        title: "Hallelujah",
        artist: "Leonard Cohen",
        key: "C",
        bpm: 72,
      ),
      const Song(
        title: "Hosanna",
        artist: "Hillsong",
        key: "D",
        bpm: 128,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliothèque"),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return Card(
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