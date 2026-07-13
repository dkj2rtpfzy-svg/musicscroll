import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = [
      {
        "title": "Amazing Grace",
        "artist": "Traditionnel",
      },
      {
        "title": "Hallelujah",
        "artist": "Leonard Cohen",
      },
      {
        "title": "Hosanna",
        "artist": "Hillsong",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliothèque"),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.music_note),
            ),
            title: Text(song["title"]!),
            subtitle: Text(song["artist"]!),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}