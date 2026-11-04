
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/song_provider.dart';
import '../providers/setlist_provider.dart';
import 'shared_setlist_import_service.dart';

class SharedSetlistImporter {
  static Future<String?> importSetlist({
    required WidgetRef ref,
    required String token,
  }) async {
    final shared = await SharedSetlistImportService.fetchSharedSetlist(
      token,
    );

    if (shared == null) {
      return null;
    }

    final importedSongs = shared.toSongList();

    ref.read(songProvider.notifier).addSongsIfMissing(importedSongs);

    final importedSongIds = importedSongs
        .map((song) => song.id)
        .toList();

    ref.read(setlistProvider.notifier).addImportedSetlist(
          name: shared.name,
          songIds: importedSongIds,
        );

    return shared.name;
  }
}
