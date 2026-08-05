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
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: artistController,
          decoration: const InputDecoration(
            labelText: "Artiste",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: keyController,
                decoration: const InputDecoration(
                  labelText: "Tonalité",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: bpmController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Tempo",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Format ChordPro",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "[C]Quand il me prend dans ses bras\n"
                  "[Am]Je vois la vie en rose\n"
                  "[F]Il me dit des mots d'amour\n"
                  "[G]Des mots de tous les jours",
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: lyricsController,
          minLines: 18,
          maxLines: null,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            height: 1.5,
          ),
          decoration: const InputDecoration(
            labelText: "Paroles / Accords",
            hintText:
                "Écrivez votre morceau au format ChordPro.",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),

        const SizedBox(height: 24),

        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save),
          label: Text(buttonLabel),
        ),
      ],
    );
  }
}