import 'editor_line.dart';

class EditorDocument {
  final List<EditorLine> lines;

  EditorDocument({
    List<EditorLine>? lines,
  }) : lines = lines ?? [];

  factory EditorDocument.empty() {
    return EditorDocument(
      lines: [
        EditorLine(text: ""),
      ],
    );
  }

  void addLine([String text = ""]) {
    lines.add(
      EditorLine(text: text),
    );
  }

  void removeLine(int index) {
    if (lines.length <= 1) return;
    lines.removeAt(index);
  }

  EditorLine line(int index) => lines[index];

  int get length => lines.length;

  EditorDocument copy() {
    return EditorDocument(
      lines: lines.map((e) => e.copy()).toList(),
    );
  }
}