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
}