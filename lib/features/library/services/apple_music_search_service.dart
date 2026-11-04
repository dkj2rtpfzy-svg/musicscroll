
import 'dart:convert';

import 'package:http/http.dart' as http;

class AppleMusicResult {
  final int trackId;
  final String title;
  final String artist;
  final String album;
  final String? artworkUrl;
  final String? previewUrl;

  const AppleMusicResult({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.album,
    this.artworkUrl,
    this.previewUrl,
  });

  factory AppleMusicResult.fromJson(Map<String, dynamic> json) {
    return AppleMusicResult(
      trackId: json['trackId'] as int,
      title: json['trackName'] as String? ?? '',
      artist: json['artistName'] as String? ?? '',
      album: json['collectionName'] as String? ?? '',
      artworkUrl: json['artworkUrl100'] as String?,
      previewUrl: json['previewUrl'] as String?,
    );
  }
}

class AppleMusicSearchService {
  Future<List<AppleMusicResult>> searchSongs(String query) async {
    final cleanedQuery = query.trim();

    if (cleanedQuery.isEmpty) {
      return [];
    }

    final uri = Uri.https(
      'itunes.apple.com',
      '/search',
      {
        'term': cleanedQuery,
        'entity': 'song',
        'limit': '25',
        'country': 'fr',
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur du catalogue Apple : ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];

    return results
        .whereType<Map<String, dynamic>>()
        .where((item) => item['trackId'] is int)
        .map(AppleMusicResult.fromJson)
        .toList();
  }
}
