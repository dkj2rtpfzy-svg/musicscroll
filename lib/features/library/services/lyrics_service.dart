
import 'dart:convert';

import 'package:http/http.dart' as http;

class LyricsService {
  static const String _baseUrl = 'https://lrclib.net/api';

  static const Map<String, String> _headers = {
    'User-Agent': 'MusicScroll/1.0',
    'Accept': 'application/json',
  };

  Future<String?> fetchLyrics({
    required String title,
    required String artist,
    String? album,
  }) async {
    final cleanedTitle = title.trim();
    final cleanedArtist = artist.trim();
    final cleanedAlbum = album?.trim();

    if (cleanedTitle.isEmpty || cleanedArtist.isEmpty) {
      return null;
    }

    final queries = <Map<String, String>>[
      if (cleanedAlbum != null && cleanedAlbum.isNotEmpty)
        {
          'track_name': cleanedTitle,
          'artist_name': cleanedArtist,
          'album_name': cleanedAlbum,
        },
      {
        'track_name': cleanedTitle,
        'artist_name': cleanedArtist,
      },
    ];

    for (final query in queries) {
      try {
        final uri = Uri.parse('$_baseUrl/search').replace(
          queryParameters: query,
        );

        final response = await http
            .get(uri, headers: _headers)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode != 200) {
          continue;
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! List || decoded.isEmpty) {
          continue;
        }

        for (final item in decoded) {
          if (item is! Map<String, dynamic>) {
            continue;
          }

          final plainLyrics = item['plainLyrics'];
          if (plainLyrics is String && plainLyrics.trim().isNotEmpty) {
            return plainLyrics.trim();
          }

          final syncedLyrics = item['syncedLyrics'];
          if (syncedLyrics is String && syncedLyrics.trim().isNotEmpty) {
            final lines = syncedLyrics
                .split('\n')
                .map(
                  (line) => line.replaceFirst(
                    RegExp(r'^\[\d{2}:\d{2}(?:\.\d{2,3})?\]\s*'),
                    '',
                  ),
                )
                .where((line) => line.trim().isNotEmpty)
                .toList();

            if (lines.isNotEmpty) {
              return lines.join('\n').trim();
            }
          }
        }
      } catch (_) {
        continue;
      }
    }

    return null;
  }
}
