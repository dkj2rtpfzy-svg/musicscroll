import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _chords = [];

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
              children: _available.map((e) {
                return TextButton(
                  onPressed: () {
                    Navigator.pop(context, e);
                  },
                  child: Text(e),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (chord != null) {
      setState(() {
        _chords.add(chord);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvel éditeur"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChord,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Wrap(
              spacing: 8,
              children: _chords
                  .map(
                    (e) => Chip(
                      label: Text(e),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Écrivez vos paroles...",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}