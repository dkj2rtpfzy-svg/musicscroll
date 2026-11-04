import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'storage_service.dart';

class BackupExportService {
  static Future<ShareResult> exportBackup() async {
    final songs = StorageService.loadSongs();
    final setlists = StorageService.loadSetlists();

    final backup = <String, dynamic>{
      'format': 'musicscroll_backup',
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'songs': songs.map((song) => song.toMap()).toList(),
      'setlists': setlists.map((setlist) => setlist.toMap()).toList(),
    };

    final json = const JsonEncoder.withIndent('  ').convert(backup);
    final bytes = Uint8List.fromList(utf8.encode(json));

    final now = DateTime.now();
    final timestamp =
        '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';

    final file = XFile.fromData(bytes, mimeType: 'application/json');

    return SharePlus.instance.share(
      ShareParams(
        files: [file],
        fileNameOverrides: ['MusicScroll_Sauvegarde_$timestamp.json'],
        text: 'Sauvegarde de ma bibliothèque MusicScroll',
      ),
    );
  }
}
