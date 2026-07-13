import 'package:flutter/material.dart';

class SongForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController artistController;
  final TextEditingController keyController;
  final TextEditingController bpmController;
  final TextEditingController lyricsController;
  final VoidCallback onSave;
  final String buttonLabel;

  const SongForm({
    super.key,
    required this.titleController,
    required this.artistController,
    required this.keyController,
    required this.bpmController,
    required this.lyricsController,
    required this.onSave,
    this.buttonLabel = "Enregistrer",
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          onPressed: onSave,
          icon: const Icon(Icons.save),
          label: Text(buttonLabel),
        ),
      ],
    );
  }
}