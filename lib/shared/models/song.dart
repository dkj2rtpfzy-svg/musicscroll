class Song {
  final String id;
  final String title;
  final String artist;
  final String keySignature;
  final int tempo;
  final String instrument;
  final String lyrics;
  final String chords;
  final String notes;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.keySignature,
    required this.tempo,
    required this.instrument,
    this.lyrics = '',
    this.chords = '',
    this.notes = '',
  });
}