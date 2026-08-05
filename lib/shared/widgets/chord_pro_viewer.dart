import 'package:flutter/material.dart';

class ChordProViewer extends StatelessWidget {
  final String lyrics;

  const ChordProViewer({
    super.key,
    required this.lyrics,
  });

  @override
  Widget build(BuildContext context) {
    if (lyrics.trim().isEmpty) {
      return const Text(
        "Aucune parole disponible.",
        style: TextStyle(fontSize: 18),
      );
    }

    final lines = lyrics.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildLine(line),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLine(String line) {
    final reg = RegExp(r'\[([^\]]+)\]');

    final matches = reg.allMatches(line);

    if (matches.isEmpty) {
      return Text(
        line,
      style: const TextStyle(
  color: Colors.white,
  fontSize: 28,
  height: 1.8,
  fontFamily: 'Courier',
),
      );
    }

    final chords = <Widget>[];
    final lyricsBuffer = StringBuffer();

    int index = 0;

    for (final match in matches) {
      lyricsBuffer.write(line.substring(index, match.start));

      chords.add(
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Text(
            match.group(1)!,
            style: const TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.amber,
  fontSize: 22,
  letterSpacing: 0.5,
),
          ),
        ),
      );

      index = match.end;
    }

    lyricsBuffer.write(line.substring(index));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(children: chords),
        Text(
          lyricsBuffer.toString(),
          style: const TextStyle(
            fontSize: 18,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}