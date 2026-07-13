import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../../shared/models/song.dart';

class SongEditorScreen extends ConsumerStatefulWidget {
  final Song song;
  final int songIndex;

  const SongEditorScreen({
    super.key,
    required this.song,
    required this.songIndex,
  });

  @override
  ConsumerState<SongEditorScreen> createState() =>
      _SongEditorScreenState();
}

class _SongEditorScreenState
    extends ConsumerState<SongEditorScreen> {
  late final TextEditingController titleController;
  late final TextEditingController artistController;
  late final TextEditingController keyController;
  late final TextEditingController bpmController;
  late final TextEditingController lyricsController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.song.title);
    artistController =
        TextEditingController(text: widget.song.artist);
    keyController =
        TextEditingController(text: widget.song.key);
    bpmController = TextEditingController(
      text: widget.song.bpm.toString(),
    );
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
              final updatedSong = widget.song.copyWith(
                title: titleController.text,
                artist: artistController.text,
                key: keyController.text,
                bpm:
                    int.tryParse(bpmController.text) ??
                        widget.song.bpm,
                lyrics: lyricsController.text,
              );

              ref
                  .read(songProvider.notifier)
                  .updateSong(
                    widget.songIndex,
                    updatedSong,
                  );

              Navigator.pop(context);
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