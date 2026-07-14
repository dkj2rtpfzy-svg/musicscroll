import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../../shared/models/song.dart';
import '../../shared/widgets/song_form.dart';

class SongFormScreen extends ConsumerStatefulWidget {
  const SongFormScreen({super.key});

  @override
  ConsumerState<SongFormScreen> createState() =>
      _SongFormScreenState();
}

class _SongFormScreenState
    extends ConsumerState<SongFormScreen> {
  final titleController = TextEditingController();
  final artistController = TextEditingController();
  final keyController = TextEditingController();
  final bpmController = TextEditingController(text: "120");
  final lyricsController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    artistController.dispose();
    keyController.dispose();
    bpmController.dispose();
    lyricsController.dispose();
    super.dispose();
  }

  void _saveSong() {
    if (titleController.text.trim().isEmpty ||
        artistController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Le titre et l'artiste sont obligatoires."),
        ),
      );
      return;
    }

    final song = Song(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text.trim(),
      artist: artistController.text.trim(),
      key: keyController.text.trim(),
      bpm: int.tryParse(bpmController.text) ?? 120,
      lyrics: lyricsController.text.trim(),
    );

    ref.read(songProvider.notifier).addSong(song);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau morceau"),
      ),
      body: SongForm(
        titleController: titleController,
        artistController: artistController,
        keyController: keyController,
        bpmController: bpmController,
        lyricsController: lyricsController,
        onSave: _saveSong,
        buttonLabel: "Ajouter",
      ),
    );
  }
}