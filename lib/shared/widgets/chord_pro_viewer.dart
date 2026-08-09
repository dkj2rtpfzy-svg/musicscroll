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
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
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

    // Ligne sans accord.
    if (matches.isEmpty) {
      return Text(
        line,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          height: 1.2,
          fontFamily: 'Courier',
        ),
      );
    }

    /*
     * On construit deux lignes de même longueur :
     *
     * Ligne du haut :
     *
     *        G                 Em
     *
     * Ligne du bas :
     *
     * Well, I heard there was a secret chord
     *
     * Comme les deux utilisent une police monospace,
     * les positions horizontales correspondent.
     */

    final chordLine = StringBuffer();
    final lyricsLine = StringBuffer();

    int sourceIndex = 0;
    

    for (final match in matches) {
      // Texte situé avant l'accord.
      final textBefore =
          line.substring(sourceIndex, match.start);

      lyricsLine.write(textBefore);

      // Même nombre de positions vides dans la ligne des accords.
      chordLine.write(' ' * textBefore.length);

      final chord = match.group(1)!;

      /*
       * Place l'accord exactement à la position où
       * commence le texte qui suit.
       */
      chordLine.write(chord);

      // On avance dans la chaîne source.
      sourceIndex = match.end;

     
    }

    // Dernier morceau de paroles.
    final remaining = line.substring(sourceIndex);

    lyricsLine.write(remaining);

    // On complète la ligne des accords pour avoir
    // au minimum la même largeur que les paroles.
    final chordLength = chordLine.length;
    final lyricsLength = lyricsLine.length;

    if (chordLength < lyricsLength) {
      chordLine.write(
        ' ' * (lyricsLength - chordLength),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          chordLine.toString(),
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            color: const Color(0xFFFFFF62),
            fontSize: fontSize * 0.79,
            fontWeight: FontWeight.bold,
            height: 1.0,
            fontFamily: 'Courier',
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          lyricsLine.toString(),
          softWrap: false,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            height: 1.2,
            fontFamily: 'Courier',
          ),
        ),
      ],
    );
  }
}