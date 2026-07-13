import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../../shared/models/song.dart';
import '../../shared/widgets/song_form.dart';

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

    titleController = TextEditingController(text: widget.song.title);
    artistController = TextEditingController(text: widget.song.artist);
    keyController = TextEditingController(text: widget.song.key);
    bpmController = TextEditingController(
      text: widget.song.bpm.toString(),
    );
    lyricsController = TextEditingController(
      text: widget.song.lyrics,
    );
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

  void _saveSong() {
    final updatedSong = widget.song.copyWith(
      title: titleController.text,
      artist: artistController.text,
      key: keyController.text,
      bpm: int.tryParse(bpmController.text) ?? widget.song.bpm,
      lyrics: lyricsController.text,
    );

    ref.read(songProvider.notifier).updateSong(
          widget.songIndex,
          updatedSong,
        );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le morceau"),
      ),
      body: SongForm(
        titleController: titleController,
        artistController: artistController,
        keyController: keyController,
        bpmController: bpmController,
        lyricsController: lyricsController,
        onSave: _saveSong,
        buttonLabel: "Enregistrer",
      ),
    );
  }
}