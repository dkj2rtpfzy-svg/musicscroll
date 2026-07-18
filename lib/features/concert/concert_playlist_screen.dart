import 'package:flutter/material.dart';

import '../../shared/models/song.dart';

class ConcertPlaylistScreen extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;

  const ConcertPlaylistScreen({
    super.key,
    required this.songs,
    this.initialIndex = 0,
  });

  @override
  State<ConcertPlaylistScreen> createState() =>
      _ConcertPlaylistScreenState();
}

class _ConcertPlaylistScreenState
    extends State<ConcertPlaylistScreen> {
  late int _currentIndex;

  Song get _song => widget.songs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _previousSong() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextSong() {
    if (_currentIndex < widget.songs.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.songs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mode Concert"),
        ),
        body: const Center(
          child: Text("Aucun morceau dans cette setlist."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(_song.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${_currentIndex + 1} / ${widget.songs.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _song.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _song.artist,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _song.lyrics.isEmpty
                      ? "Aucune parole disponible."
                      : _song.lyrics,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _currentIndex > 0 ? _previousSong : null,
                    icon: const Icon(Icons.skip_previous),
                    label: const Text("Précédent"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentIndex < widget.songs.length - 1
                        ? _nextSong
                        : null,
                    icon: const Icon(Icons.skip_next),
                    label: const Text("Suivant"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}