/// Représente la qualité d'un accord.
///
/// Exemples :
/// C       -> major
/// Cm      -> minor
/// C7      -> dominant7
/// Cmaj7   -> major7
/// Cm7     -> minor7
/// Csus4   -> sus4
/// Cadd9   -> add9
enum ChordQuality {
  major,
  minor,

  dominant7,
  major7,
  minor7,

  dominant9,
  major9,
  minor9,

  dominant11,
  major11,
  minor11,

  dominant13,
  major13,
  minor13,

  diminished,
  diminished7,
  halfDiminished,

  augmented,

  suspended2,
  suspended4,

  add2,
  add4,
  add9,

  sixth,
  minor6,
  sixthNine,

  powerChord,
}

extension ChordQualityExtension on ChordQuality {
  /// Suffixe affiché après la note.
  ///
  /// Exemple :
  /// C + m7 => Cm7
  String get symbol {
    switch (this) {
      case ChordQuality.major:
        return '';

      case ChordQuality.minor:
        return 'm';

      case ChordQuality.dominant7:
        return '7';

      case ChordQuality.major7:
        return 'maj7';

      case ChordQuality.minor7:
        return 'm7';

      case ChordQuality.dominant9:
        return '9';

      case ChordQuality.major9:
        return 'maj9';

      case ChordQuality.minor9:
        return 'm9';

      case ChordQuality.dominant11:
        return '11';

      case ChordQuality.major11:
        return 'maj11';

      case ChordQuality.minor11:
        return 'm11';

      case ChordQuality.dominant13:
        return '13';

      case ChordQuality.major13:
        return 'maj13';

      case ChordQuality.minor13:
        return 'm13';

      case ChordQuality.diminished:
        return 'dim';

      case ChordQuality.diminished7:
        return 'dim7';

      case ChordQuality.halfDiminished:
        return 'm7♭5';

      case ChordQuality.augmented:
        return 'aug';

      case ChordQuality.suspended2:
        return 'sus2';

      case ChordQuality.suspended4:
        return 'sus4';

      case ChordQuality.add2:
        return 'add2';

      case ChordQuality.add4:
        return 'add4';

      case ChordQuality.add9:
        return 'add9';

      case ChordQuality.sixth:
        return '6';

      case ChordQuality.minor6:
        return 'm6';

      case ChordQuality.sixthNine:
        return '6/9';

      case ChordQuality.powerChord:
        return '5';
    }
  }

  bool get isMinor =>
      this == ChordQuality.minor ||
      this == ChordQuality.minor6 ||
      this == ChordQuality.minor7 ||
      this == ChordQuality.minor9 ||
      this == ChordQuality.minor11 ||
      this == ChordQuality.minor13;

  bool get isSeventh =>
      this == ChordQuality.dominant7 ||
      this == ChordQuality.major7 ||
      this == ChordQuality.minor7;

  bool get isExtended =>
      this == ChordQuality.dominant9 ||
      this == ChordQuality.major9 ||
      this == ChordQuality.minor9 ||
      this == ChordQuality.dominant11 ||
      this == ChordQuality.major11 ||
      this == ChordQuality.minor11 ||
      this == ChordQuality.dominant13 ||
      this == ChordQuality.major13 ||
      this == ChordQuality.minor13;
}