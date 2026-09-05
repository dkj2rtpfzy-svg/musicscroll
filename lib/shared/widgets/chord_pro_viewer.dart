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
              child: _ChordLine(
                line: line,
                fontSize: fontSize,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ChordMark {
  final String chord;
  final int position;

  const _ChordMark({
    required this.chord,
    required this.position,
  });
}

class _ChordLine extends StatelessWidget {
  final String line;
  final double fontSize;

  const _ChordLine({
    required this.line,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final reg = RegExp(r'\[([^\]]+)\]');
    final matches = reg.allMatches(line).toList();

    if (matches.isEmpty) {
      return Text(
        line,
        softWrap: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          height: 1.2,
          fontFamily: 'Courier',
        ),
      );
    }

    final plainText = StringBuffer();
    final chords = <_ChordMark>[];

    int sourceIndex = 0;

    for (final match in matches) {
      final before = line.substring(
        sourceIndex,
        match.start,
      );

      plainText.write(before);

      chords.add(
        _ChordMark(
          chord: match.group(1)!,
          position: plainText.length,
        ),
      );

      sourceIndex = match.end;
    }

    plainText.write(line.substring(sourceIndex));

    return _WrappedChordLine(
      text: plainText.toString(),
      chords: chords,
      fontSize: fontSize,
    );
  }
}

class _WrappedChordLine extends StatelessWidget {
  final String text;
  final List<_ChordMark> chords;
  final double fontSize;

  const _WrappedChordLine({
    required this.text,
    required this.chords,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = _ChordTextPainter(
          text: text,
          chords: chords,
          fontSize: fontSize,
          maxWidth: constraints.maxWidth,
        );

        return SizedBox(
          width: double.infinity,
          height: painter.totalHeight,
          child: CustomPaint(
            painter: painter,
          ),
        );
      },
    );
  }
}

class _ChordTextPainter extends CustomPainter {
  final String text;
  final List<_ChordMark> chords;
  final double fontSize;
  final double maxWidth;

  _ChordTextPainter({
    required this.text,
    required this.chords,
    required this.fontSize,
    required this.maxWidth,
  });

  final TextDirection _textDirection = TextDirection.ltr;

  double get _chordFontSize => fontSize * 0.79;

  double get _lyricsHeight => fontSize * 1.2;

  double get _chordHeight => _chordFontSize * 1.15;

  double get _gap => 2;

  double get _lineHeight => _chordHeight + _gap + _lyricsHeight;

  double get totalHeight => _buildRows().length * _lineHeight;

  List<_TextRow> _buildRows() {
    if (text.isEmpty) {
      return const [
        _TextRow(
          start: 0,
          end: 0,
        ),
      ];
    }

    final rows = <_TextRow>[];

    int start = 0;

    while (start < text.length) {
      final remaining = text.substring(start);

      final fullPainter = TextPainter(
        text: TextSpan(
          text: remaining,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Courier',
          ),
        ),
        textDirection: _textDirection,
        maxLines: 1,
      );

      fullPainter.layout();

      if (fullPainter.width <= maxWidth) {
        rows.add(
          _TextRow(
            start: start,
            end: text.length,
          ),
        );
        break;
      }

      int bestEnd = _findBestBreak(
        start,
        maxWidth,
      );

      if (bestEnd <= start) {
        bestEnd = start + 1;
      }

      rows.add(
        _TextRow(
          start: start,
          end: bestEnd,
        ),
      );

      start = bestEnd;

      while (start < text.length && text[start] == ' ') {
        start++;
      }
    }

    return rows;
  }

  int _findBestBreak(
    int start,
    double width,
  ) {
    int lastSpace = -1;
    int bestEnd = start;

    for (
      int end = start + 1;
      end <= text.length;
      end++
    ) {
      final candidate = text.substring(
        start,
        end,
      );

      final painter = TextPainter(
        text: TextSpan(
          text: candidate,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Courier',
          ),
        ),
        textDirection: _textDirection,
        maxLines: 1,
      );

      painter.layout();

      if (painter.width > width) {
        if (lastSpace > start) {
          return lastSpace;
        }

        return bestEnd;
      }

      bestEnd = end;

      if (text[end - 1] == ' ') {
        lastSpace = end - 1;
      }
    }

    return bestEnd;
  }

  double _textWidth(
    String value,
  ) {
    if (value.isEmpty) {
      return 0;
    }

    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Courier',
        ),
      ),
      textDirection: _textDirection,
      maxLines: 1,
    );

    painter.layout();

    return painter.width;
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final rows = _buildRows();

    final lyricsStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      height: 1.2,
      fontFamily: 'Courier',
    );

    final chordStyle = TextStyle(
      color: const Color(0xFFFFFF62),
      fontSize: _chordFontSize,
      fontWeight: FontWeight.bold,
      height: 1.0,
      fontFamily: 'Courier',
      letterSpacing: 0.5,
    );

    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];

      final rowText = text.substring(
        row.start,
        row.end,
      );

      final y = rowIndex * _lineHeight;

      final rowChords = chords.where((chord) {
        return chord.position >= row.start &&
            chord.position <= row.end;
      });

      for (final chord in rowChords) {
        final relativePosition =
            chord.position - row.start;

        final beforeChord = rowText.substring(
          0,
          relativePosition.clamp(
            0,
            rowText.length,
          ),
        );

        final x = _textWidth(beforeChord);

        final chordPainter = TextPainter(
          text: TextSpan(
            text: chord.chord,
            style: chordStyle,
          ),
          textDirection: _textDirection,
          maxLines: 1,
        );

        chordPainter.layout(
          maxWidth: maxWidth,
        );

        chordPainter.paint(
          canvas,
          Offset(
            x,
            y,
          ),
        );
      }

      final lyricsPainter = TextPainter(
        text: TextSpan(
          text: rowText,
          style: lyricsStyle,
        ),
        textDirection: _textDirection,
        maxLines: 1,
      );

      lyricsPainter.layout(
        maxWidth: maxWidth,
      );

      lyricsPainter.paint(
        canvas,
        Offset(
          0,
          y + _chordHeight + _gap,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ChordTextPainter oldDelegate,
  ) {
    return oldDelegate.text != text ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.maxWidth != maxWidth ||
        oldDelegate.chords.length != chords.length;
  }

  @override
  bool hitTest(Offset position) => false;
}

class _TextRow {
  final int start;
  final int end;

  const _TextRow({
    required this.start,
    required this.end,
  });
}
