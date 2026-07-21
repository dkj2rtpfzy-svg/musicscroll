import '../models/chord.dart';
import '../models/chord_quality.dart';
import '../models/note.dart';

class ChordParser {
  ChordParser._();

  static final Map<String, Note> _notes = {
    'C': Note.c,
    'C#': Note.cSharp,
    'Db': Note.cSharp,

    'D': Note.d,
    'D#': Note.dSharp,
    'Eb': Note.dSharp,

    'E': Note.e,

    'F': Note.f,
    'F#': Note.fSharp,
    'Gb': Note.fSharp,

    'G': Note.g,
    'G#': Note.gSharp,
    'Ab': Note.gSharp,

    'A': Note.a,
    'A#': Note.aSharp,
    'Bb': Note.aSharp,

    'B': Note.b,
  };

  static final Map<String, ChordQuality> _qualities = {
    '': ChordQuality.major,

    'm': ChordQuality.minor,

    '7': ChordQuality.dominant7,
    'maj7': ChordQuality.major7,
    'm7': ChordQuality.minor7,

    '9': ChordQuality.dominant9,
    'maj9': ChordQuality.major9,
    'm9': ChordQuality.minor9,

    '11': ChordQuality.dominant11,
    '13': ChordQuality.dominant13,

    'dim': ChordQuality.diminished,
    'dim7': ChordQuality.diminished7,

    'aug': ChordQuality.augmented,

    'sus2': ChordQuality.suspended2,
    'sus4': ChordQuality.suspended4,

    'add9': ChordQuality.add9,

    '5': ChordQuality.powerChord,
  };

  static Chord parse(String text) {
    text = text.trim();

    String? bassPart;

    if (text.contains('/')) {
      final split = text.split('/');
      text = split.first;
      bassPart = split.last;
    }

    final rootMatch = RegExp(r'^[A-G](#|b)?').firstMatch(text);

    if (rootMatch == null) {
      throw FormatException('Accord invalide : $text');
    }

    final rootText = rootMatch.group(0)!;

    final root = _notes[rootText];

    if (root == null) {
      throw FormatException('Note inconnue : $rootText');
    }

    final qualityText = text.substring(rootText.length);

    final quality =
        _qualities[qualityText] ?? ChordQuality.major;

    Note? bass;

    if (bassPart != null) {
      bass = _notes[bassPart];

      if (bass == null) {
        throw FormatException(
          'Basse inconnue : $bassPart',
        );
      }
    }

    return Chord(
      root: root,
      quality: quality,
      bass: bass,
    );
  }
}