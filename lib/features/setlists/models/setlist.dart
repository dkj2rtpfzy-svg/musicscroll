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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
    };
  }

  factory Setlist.fromMap(Map<dynamic, dynamic> map) {
    return Setlist(
      id: map['id'] as String,
      name: map['name'] as String,
      songIds: List<String>.from(map['songIds'] ?? []),
    );
  }
}