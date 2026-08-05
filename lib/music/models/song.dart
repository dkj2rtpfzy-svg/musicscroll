import 'chord.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String key;
  final int capo;
  final int tempo;
  final String timeSignature;
  final String lyrics;
  final List<Chord> chords;
  final List<String> tags;
  final bool favorite;
  final int transpose;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album = '',
    this.key = 'C',
    this.capo = 0,
    this.tempo = 120,
    this.timeSignature = '4/4',
    this.lyrics = '',
    this.chords = const [],
    this.tags = const [],
    this.favorite = false,
    this.transpose = 0,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? key,
    int? capo,
    int? tempo,
    String? timeSignature,
    String? lyrics,
    List<Chord>? chords,
    List<String>? tags,
    bool? favorite,
    int? transpose,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      key: key ?? this.key,
      capo: capo ?? this.capo,
      tempo: tempo ?? this.tempo,
      timeSignature: timeSignature ?? this.timeSignature,
      lyrics: lyrics ?? this.lyrics,
      chords: chords ?? this.chords,
      tags: tags ?? this.tags,
      favorite: favorite ?? this.favorite,
      transpose: transpose ?? this.transpose,
    );
  }
}