import 'editor_chord.dart';

class EditorLine {
  String text;

  final List<EditorChord> chords;

  EditorLine({
    required this.text,
    List<EditorChord>? chords,
  }) : chords = chords ?? [];

  void addChord(String chordName, int index) {
    chords.add(
      EditorChord(
        name: chordName,
        index: index,
      ),
    );

    chords.sort((a, b) => a.index.compareTo(b.index));
  }

  void removeChord(EditorChord chord) {
    chords.remove(chord);
  }

  EditorLine copy() {
    return EditorLine(
      text: text,
      chords: chords
          .map(
            (c) => c.copyWith(),
          )
          .toList(),
    );
  }
}