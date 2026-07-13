import 'package:flutter/material.dart';

import '../../shared/models/song.dart';

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