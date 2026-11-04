
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/models/song.dart';

class SharedSetlistImport {
  final String name;
  final List<Map<String, dynamic>> songs;

  const SharedSetlistImport({
    required this.name,
    required this.songs,
  });

  List<Song> toSongList() {
    return songs.map((song) => Song.fromMap(song)).toList();
  }
}

class SharedSetlistImportService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<SharedSetlistImport?> fetchSharedSetlist(
    String token,
  ) async {
    final result = await _supabase.rpc(
      'get_shared_setlist',
      params: {'p_token': token},
    );

    if (result == null) {
      return null;
    }

    if (result is! Map) {
      throw const FormatException(
        'Le partage reçu est dans un format inattendu.',
      );
    }

    final name = result['name'];
    final songsData = result['songs'];

    if (name is! String || name.trim().isEmpty) {
      throw const FormatException(
        'Le partage ne contient pas de nom de setlist valide.',
      );
    }

    if (songsData is! List) {
      throw const FormatException(
        'Le partage ne contient pas de liste de morceaux valide.',
      );
    }

    final songs = <Map<String, dynamic>>[];

    for (final item in songsData) {
      if (item is! Map) {
        throw const FormatException(
          'Un morceau du partage est dans un format invalide.',
        );
      }

      songs.add(Map<String, dynamic>.from(item));
    }

    return SharedSetlistImport(
      name: name.trim(),
      songs: songs,
    );
  }
}
