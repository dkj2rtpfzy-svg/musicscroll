
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/models/song.dart';
import '../../features/concert/concert_screen.dart';
import '../../features/setlists/widgets/select_setlist_dialog.dart';
import 'song_editor_screen.dart';
import '../../shared/widgets/chord_pro_viewer.dart';
import '../print/services/song_pdf_service.dart';

class SongDetailScreen extends ConsumerStatefulWidget {
  final Song song;
  final int songIndex;

  const SongDetailScreen({
    super.key,
    required this.song,
    required this.songIndex,
  });

  @override
  ConsumerState<SongDetailScreen> createState() =>
      _SongDetailScreenState();
}

class _SongDetailScreenState extends ConsumerState<SongDetailScreen> {
  bool _isPrinting = false;

  Future<void> _searchChordsOnline() async {
    final query = Uri.encodeComponent(
      '${widget.song.title} ${widget.song.artist} accords guitare paroles',
    );

    final uri = Uri.parse(
      'https://www.google.com/search?q=$query',
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Impossible d'ouvrir la recherche Internet.",
            ),
          ),
        );
      }
    } catch (error) {
      debugPrint('Erreur recherche accords : $error');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Impossible d'ouvrir la recherche Internet.",
            ),
          ),
        );
      }
    }
  }

  Future<void> _printSong() async {
    if (_isPrinting) return;

    setState(() => _isPrinting = true);

    try {
      await SongPdfService.printSong(
        title: widget.song.title,
        artist: widget.song.artist,
        songKey: widget.song.key,
        bpm: widget.song.bpm,
        lyrics: widget.song.lyrics,
      );
    } catch (error, stackTrace) {
      debugPrint('Erreur impression MusicScroll : $error');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Impossible d'ouvrir l'impression."),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Modifier",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongEditorScreen(
                    song: song,
                    songIndex: widget.songIndex,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Titre de la chanson
          Text(
            song.title,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          // Artiste
          Text(
            song.artist,
            style: TextStyle(
              fontSize: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          // Boutons Setlist et Concert
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => SelectSetlistDialog(
                        songId: song.id,
                      ),
                    );
                  },
                  icon: const Icon(Icons.queue_music),
                  label: const Text("Setlist"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFF62),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConcertScreen(song: song),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text("Concert"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Impression et PDF
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isPrinting ? null : _printSong,
              icon: _isPrinting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.print),
              label: Text(
                _isPrinting ? "Préparation..." : "Imprimer / PDF",
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Recherche des accords sur Internet
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _searchChordsOnline,
              icon: const Icon(Icons.search),
              label: const Text(
                "Rechercher les accords sur Internet",
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Tonalité
          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Tonalité"),
              trailing: Text(song.key),
            ),
          ),

          // Tempo
          Card(
            child: ListTile(
              leading: const Icon(Icons.speed),
              title: const Text("Tempo"),
              trailing: Text("${song.bpm} BPM"),
            ),
          ),

          // Favori
          Card(
            child: ListTile(
              leading: Icon(
                song.favorite ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              title: const Text("Favori"),
              trailing: Text(song.favorite ? "Oui" : "Non"),
            ),
          ),

          const SizedBox(height: 30),

          // Titre de la section paroles
          Text(
            "Paroles",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          // Affichage des paroles et accords
          ChordProViewer(
            lyrics: song.lyrics,
          ),
        ],
      ),
    );
  }
}
