class Setlist {
  final String id;
  final String name;
  final List<String> songIds;

  const Setlist({
    required this.id,
    required this.name,
    this.songIds = const [],
  });

  Setlist copyWith({
    String? id,
    String? name,
    List<String>? songIds,
  }) {
    return Setlist(
      id: id ?? this.id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
    );
  }
}