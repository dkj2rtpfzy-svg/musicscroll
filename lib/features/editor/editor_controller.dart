import 'package:flutter/foundation.dart';

import 'editor_document.dart';

class EditorController extends ChangeNotifier {
  EditorDocument _document = EditorDocument.empty();

  EditorDocument get document => _document;

  void newDocument() {
    _document = EditorDocument.empty();
    notifyListeners();
  }

  void load(EditorDocument document) {
    _document = document.copy();
    notifyListeners();
  }

  void updateLine(int lineIndex, String text) {
    if (lineIndex < 0 || lineIndex >= _document.length) return;

    _document.line(lineIndex).text = text;

    notifyListeners();
  }

  void addLine() {
    _document.addLine();

    notifyListeners();
  }

  void removeLine(int lineIndex) {
    _document.removeLine(lineIndex);

    notifyListeners();
  }

  void addChord({
    required int lineIndex,
    required String chord,
    required int position,
  }) {
    if (lineIndex < 0 || lineIndex >= _document.length) return;

    _document.line(lineIndex).addChord(
          chord,
          position,
        );

    notifyListeners();
  }

  void removeChord({
    required int lineIndex,
    required int chordIndex,
  }) {
    if (lineIndex < 0 || lineIndex >= _document.length) return;

    final line = _document.line(lineIndex);

    if (chordIndex < 0 || chordIndex >= line.chords.length) return;

    line.removeChord(line.chords[chordIndex]);

    notifyListeners();
  }
}