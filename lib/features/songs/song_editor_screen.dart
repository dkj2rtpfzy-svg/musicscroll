import 'package:flutter/material.dart';

import '../../shared/models/song.dart';

class SongEditorScreen extends StatefulWidget {
  final Song song;

  const SongEditorScreen({
    super.key,
    required this.song,
  });

  @override
  State<SongEditorScreen> createState() => _SongEditorScreenState();
}

class _SongEditorScreenState extends State<SongEditorScreen> {
  late final TextEditingController titleController;
  late final TextEditingController artistController;
  late final TextEditingController keyController;
  late final TextEditingController bpmController;
  late final TextEditingController lyricsController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.song.title);
    artistController = TextEditingController(text: widget.song.artist);
    keyController = TextEditingController(text: widget.song.key);
    bpmController =
        TextEditingController(text: widget.song.bpm.toString());
    lyricsController =
        TextEditingController(text: widget.song.lyrics);
  }

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    keyController.dispose();
    bpmController.dispose();
    lyricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le morceau"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Titre",
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: artistController,
            decoration: const InputDecoration(
              labelText: "Artiste",
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: keyController,
            decoration: const InputDecoration(
              labelText: "Tonalité",
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: bpmController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Tempo (BPM)",
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: lyricsController,
            maxLines: 12,
            decoration: const InputDecoration(
              labelText: "Paroles",
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 30),

          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save),
            label: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }
}