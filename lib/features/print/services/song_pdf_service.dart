
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SongPdfService {
  static Future<void> printSong({
    required String title,
    required String artist,
    required String songKey,
    required int bpm,
    required String lyrics,
    bool showChords = true,
  }) async {
    debugPrint('MUSICSCROLL PRINT : début');

    try {
      await Printing.layoutPdf(
        name: '$title.pdf',
        dynamicLayout: false,
        onLayout: (PdfPageFormat format) async {
          debugPrint('MUSICSCROLL PRINT : callback onLayout reçu');

          final pdf = await _buildPdf(
            title: title,
            artist: artist,
            songKey: songKey,
            bpm: bpm,
            lyrics: lyrics,
            showChords: showChords,
          );

          debugPrint(
            'MUSICSCROLL PRINT : PDF généré (${pdf.length} octets)',
          );

          return pdf;
        },
      );

      debugPrint('MUSICSCROLL PRINT : layoutPdf terminé');
    } catch (error, stackTrace) {
      debugPrint('MUSICSCROLL PRINT : ERREUR $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<Uint8List> _buildPdf({
    required String title,
    required String artist,
    required String songKey,
    required int bpm,
    required String lyrics,
    required bool showChords,
  }) async {
    debugPrint('MUSICSCROLL PRINT : construction du document');

    final document = pw.Document();
    final lines = lyrics.split('\n');

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              artist,
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 14),
            pw.Row(
              children: [
                pw.Text(
                  'Tonalité : $songKey',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(width: 25),
                pw.Text(
                  'Tempo : $bpm BPM',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            ...lines.map(
              (line) => showChords
                  ? _buildChordProLine(line)
                  : _buildLyricsOnlyLine(line),
            ),
          ];
        },
      ),
    );

    final result = await document.save();

    debugPrint('MUSICSCROLL PRINT : document.save terminé');

    return result;
  }

  static pw.Widget _buildLyricsOnlyLine(String line) {
    final lyrics = line.replaceAll(RegExp(r'\[([^\]]+)\]'), '');

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        lyrics,
        style: pw.TextStyle(
          fontSize: 12,
          font: pw.Font.courier(),
        ),
      ),
    );
  }

  static pw.Widget _buildChordProLine(String line) {
    final reg = RegExp(r'\[([^\]]+)\]');
    final matches = reg.allMatches(line).toList();

    if (matches.isEmpty) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text(
          line,
          style: pw.TextStyle(
            fontSize: 12,
            font: pw.Font.courier(),
          ),
        ),
      );
    }

    final chordLine = StringBuffer();
    final lyricsLine = StringBuffer();

    int sourceIndex = 0;

    for (final match in matches) {
      final before = line.substring(sourceIndex, match.start);

      lyricsLine.write(before);
      chordLine.write(' ' * before.length);
      chordLine.write(match.group(1)!);

      sourceIndex = match.end;
    }

    final remaining = line.substring(sourceIndex);

    lyricsLine.write(remaining);

    if (chordLine.length < lyricsLine.length) {
      chordLine.write(' ' * (lyricsLine.length - chordLine.length));
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            chordLine.toString(),
            maxLines: 1,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              font: pw.Font.courier(),
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            lyricsLine.toString(),
            maxLines: 1,
            style: pw.TextStyle(
              fontSize: 12,
              font: pw.Font.courier(),
            ),
          ),
        ],
      ),
    );
  }
}
