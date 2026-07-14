class Setlist {
  final String id;
  final String name;
  final List<int> songIndexes;

  const Setlist({
    required this.id,
    required this.name,
    this.songIndexes = const [],
  });

  Setlist copyWith({
    String? id,
    String? name,
    List<int>? songIndexes,
  }) {
    return Setlist(
      id: id ?? this.id,
      name: name ?? this.name,
      songIndexes: songIndexes ?? this.songIndexes,
    );
  }
}