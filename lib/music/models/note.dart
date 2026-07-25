enum Note {
  c,
  cSharp,
  d,
  dSharp,
  e,
  f,
  fSharp,
  g,
  gSharp,
  a,
  aSharp,
  b,
}

extension NoteExtension on Note {
  /// Nom international
  String get international {
    switch (this) {
      case Note.c:
        return 'C';
      case Note.cSharp:
        return 'C#';
      case Note.d:
        return 'D';
      case Note.dSharp:
        return 'D#';
      case Note.e:
        return 'E';
      case Note.f:
        return 'F';
      case Note.fSharp:
        return 'F#';
      case Note.g:
        return 'G';
      case Note.gSharp:
        return 'G#';
      case Note.a:
        return 'A';
      case Note.aSharp:
        return 'A#';
      case Note.b:
        return 'B';
    }
  }

  /// Nom français
  String get french {
    switch (this) {
      case Note.c:
        return 'Do';
      case Note.cSharp:
        return 'Do#';
      case Note.d:
        return 'Ré';
      case Note.dSharp:
        return 'Ré#';
      case Note.e:
        return 'Mi';
      case Note.f:
        return 'Fa';
      case Note.fSharp:
        return 'Fa#';
      case Note.g:
        return 'Sol';
      case Note.gSharp:
        return 'Sol#';
      case Note.a:
        return 'La';
      case Note.aSharp:
        return 'La#';
      case Note.b:
        return 'Si';
    }
  }

  int get semitone => index;

  Note transpose(int semitones) {
    final value = (index + semitones) % 12;
    return Note.values[(value + 12) % 12];
  }
}