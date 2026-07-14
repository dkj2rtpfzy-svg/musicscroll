import 'package:flutter/material.dart';

import '../../shared/models/song.dart';

class ConcertScreen extends StatelessWidget {
  final Song song;

  const ConcertScreen({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(song.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Text(
                song.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                song.artist,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                song.lyrics.isEmpty
                    ? "Aucune parole disponible."
                    : song.lyrics,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}