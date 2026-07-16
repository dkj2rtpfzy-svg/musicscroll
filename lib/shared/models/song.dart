class Song {
  final String id;
  final String title;
  final String artist;
  final String key;
  final int bpm;
  final String lyrics;
  final bool favorite;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.key,
    required this.bpm,
    this.lyrics = "",
    this.favorite = false,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? key,
    int? bpm,
    String? lyrics,
    bool? favorite,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      key: key ?? this.key,
      bpm: bpm ?? this.bpm,
      lyrics: lyrics ?? this.lyrics,
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'key': key,
      'bpm': bpm,
      'lyrics': lyrics,
      'favorite': favorite,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      key: map['key'] as String,
      bpm: map['bpm'] as int,
      lyrics: map['lyrics'] as String? ?? "",
      favorite: map['favorite'] as bool? ?? false,
    );
  }
}
