
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/song_provider.dart';
import '../../shared/models/song.dart';
import 'services/apple_music_search_service.dart';
import 'services/lyrics_service.dart';

class AppleMusicSearchScreen extends ConsumerStatefulWidget {
  const AppleMusicSearchScreen({super.key});

  @override
  ConsumerState<AppleMusicSearchScreen> createState() =>
      _AppleMusicSearchScreenState();
}

class _AppleMusicSearchScreenState
    extends ConsumerState<AppleMusicSearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final AppleMusicSearchService _searchService =
      AppleMusicSearchService();

  final LyricsService _lyricsService = LyricsService();

  List<AppleMusicResult> _results = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchSongs() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _results = [];
    });

    try {
      final results = await _searchService.searchSongs(query);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'La recherche a échoué : $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _addSong(AppleMusicResult result) async {
    final songId = 'apple_${result.trackId}';

    final existingSongs = ref.read(songProvider);
    final alreadyExists =
        existingSongs.any((existing) => existing.id == songId);

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce morceau est déjà dans ta bibliothèque.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recherche des paroles en cours...'),
        duration: Duration(seconds: 2),
      ),
    );

    String lyrics = '';

    try {
      lyrics = await _lyricsService.fetchLyrics(
            title: result.title,
            artist: result.artist,
            album: result.album,
          ) ??
          '';
    } catch (_) {
      lyrics = '';
    }

    if (!mounted) return;

    final song = Song(
      id: songId,
      title: result.title,
      artist: result.artist,
      key: 'C',
      bpm: 120,
      lyrics: lyrics,
    );

    ref.read(songProvider.notifier).addSong(song);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lyrics.isNotEmpty
              ? '${result.title} ajouté avec ses paroles.'
              : '${result.title} ajouté. Aucune parole trouvée.',
        ),
      ),
    );
  }

  void _openSongDetails(AppleMusicResult result) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (result.artworkUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        result.artworkUrl!,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          width: 180,
                          height: 180,
                          child: Icon(Icons.music_note, size: 80),
                        ),
                      ),
                    )
                  else
                    const CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.music_note, size: 60),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    result.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.artist,
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.album,
                    textAlign: TextAlign.center,
                    style: Theme.of(sheetContext).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  const ListTile(
                    leading: Icon(Icons.lyrics_outlined),
                    title: Text('Paroles'),
                    subtitle: Text(
                      'Les paroles seront recherchées '
                      'automatiquement lors de l’ajout.',
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.music_note),
                    title: Text('Accords et notes'),
                    subtitle: Text(
                      'Les accords et les notes devront être '
                      'importés depuis une autre source.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Ajouter à ma bibliothèque',
                      ),
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        _addSong(result);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                    },
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue Apple Music'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchSongs(),
              decoration: InputDecoration(
                hintText: 'Titre ou artiste...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _searchSongs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (!_isLoading &&
              _results.isEmpty &&
              _errorMessage == null)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Recherche un titre ou un artiste.'),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];

                return ListTile(
                  onTap: () => _openSongDetails(result),
                  leading: result.artworkUrl != null
                      ? Image.network(
                          result.artworkUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.music_note),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.music_note),
                        ),
                  title: Text(result.title),
                  subtitle: Text(
                    '${result.artist}\n${result.album}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Ajouter à la bibliothèque',
                    onPressed: () => _addSong(result),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
