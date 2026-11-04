import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../models/setlist.dart';
import '../../../shared/models/song.dart';

class SetlistShareService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<String> createShareLink({
    required Setlist setlist,
    required List<Song> allSongs,
  }) async {
    final songsById = {
      for (final song in allSongs) song.id: song,
    };

    final sharedSongs = setlist.songIds.map((songId) {
      final song = songsById[songId];

      if (song == null) {
        throw StateError(
          'Le morceau "$songId" est introuvable dans la bibliothèque.',
        );
      }

      return song.toMap();
    }).toList();

    final payload = {
      'name': setlist.name,
      'songs': sharedSongs,
    };

    final token = await _supabase.rpc(
      'create_setlist_share',
      params: {'p_payload': payload},
    );

    if (token == null || token.toString().isEmpty) {
      throw StateError('Supabase n’a pas retourné de lien de partage.');
    }

    return 'musicscroll://shared-setlist/${token.toString()}';
  }

  static Future<void> shareLink({
    required String link,
    required String setlistName,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Je partage avec toi la setlist "$setlistName" sur MusicScroll :\n$link',
        subject: 'Setlist MusicScroll : $setlistName',
      ),
    );
  }
}
