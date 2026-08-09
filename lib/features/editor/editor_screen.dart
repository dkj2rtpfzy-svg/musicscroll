import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  final String initialLyrics;
  final ValueChanged<String> onSave;

  const EditorScreen({
    super.key,
    required this.initialLyrics,
    required this.onSave,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final TextEditingController _controller;

  final List<String> _available = const [
    "C",
    "Cm",
    "D",
    "Dm",
    "E",
    "Em",
    "F",
    "Fm",
    "G",
    "Gm",
    "A",
    "Am",
    "B",
    "Bm",
  ];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialLyrics,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addChord() async {
    final chord = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un accord"),
          content: SizedBox(
            width: 300,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: _available.map((chord) {
                return TextButton(
                  onPressed: () {
                    Navigator.pop(context, chord);
                  },
                  child: Text(
                    chord,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (chord == null) return;

    final selection = _controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;

    final text = _controller.text;

    final newText =
        '${text.substring(0, start)}[$chord]${text.substring(start)}';

    final newCursorPosition = start + chord.length + 2;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newCursorPosition,
      ),
    );
  }

  void _save() {
    widget.onSave(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Éditeur d'accords"),
        actions: [
          IconButton(
            tooltip: "Enregistrer",
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter un accord",
        onPressed: _addChord,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Écrivez vos paroles...",
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }
}