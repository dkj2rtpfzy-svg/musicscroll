import 'package:flutter/material.dart';

class ChordProViewer extends StatelessWidget {
  final String lyrics;
  final double fontSize;

  const ChordProViewer({
    super.key,
    required this.lyrics,
    this.fontSize = 28,
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
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildLine(line),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLine(String line) {
    final reg = RegExp(r'\[([^\]]+)\]');
    final matches = reg.allMatches(line).toList();

    if (matches.isEmpty) {
      return Text(
        line,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          height: 1.8,
          fontFamily: 'Courier',
        ),
      );
    }

    final segments = <Widget>[];
    int index = 0;

    for (final match in matches) {
      // Texte situé avant l'accord.
      final textBefore = line.substring(index, match.start);

      if (textBefore.isNotEmpty) {
        segments.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: fontSize * 0.95,
              ),
              Text(
                textBefore,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  height: 1.2,
                  fontFamily: 'Courier',
                ),
              ),
            ],
          ),
        );
      }

      // Accord situé exactement à cet endroit de la phrase.
      segments.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              match.group(1)!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFF62),
                fontSize: fontSize * 0.79,
                letterSpacing: 0.5,
                height: 1.0,
              ),
            ),
            SizedBox(
              height: fontSize * 0.2,
            ),
          ],
        ),
      );

      index = match.end;
    }

    // Texte situé après le dernier accord.
    final textAfter = line.substring(index);

    if (textAfter.isNotEmpty) {
      segments.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: fontSize * 0.95,
            ),
            Text(
              textAfter,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                height: 1.2,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: segments,
      ),
    );
  }
}