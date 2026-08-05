import 'package:flutter/material.dart';

@immutable
class EditorChord {
  final String name;

  /// Position du premier caractère dans la ligne
  final int index;

  const EditorChord({
    required this.name,
    required this.index,
  });

  EditorChord copyWith({
    String? name,
    int? index,
  }) {
    return EditorChord(
      name: name ?? this.name,
      index: index ?? this.index,
    );
  }
}