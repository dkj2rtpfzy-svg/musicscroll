import 'package:flutter/material.dart';

import '../../shared/models/song.dart';
import '../../shared/widgets/chord_pro_viewer.dart';

/// Vue dédiée à l'affichage des paroles et accords sur un écran externe.
class ExternalDisplayScreen extends StatelessWidget {
  final Song song;
  final double fontSize;

  const ExternalDisplayScreen({
    super.key,
    required this.song,
    this.fontSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 48,
            vertical: 32,
          ),
          child: ChordProViewer(
            lyrics: song.lyrics,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
