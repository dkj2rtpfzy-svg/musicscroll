import 'note.dart';
import 'chord_quality.dart';

class Chord {
  final Note root;
  final ChordQuality quality;
  final Note? bass;

  const Chord({
    required this.root,
    this.quality = ChordQuality.major,
    this.bass,
  });

  bool get hasBass => bass != null;

  Chord copyWith({
    Note? root,
    ChordQuality? quality,
    Note? bass,
  }) {
    return Chord(
      root: root ?? this.root,
      quality: quality ?? this.quality,
      bass: bass ?? this.bass,
    );
  }

  Chord transpose(int semitones) {
    return Chord(
      root: root.transpose(semitones),
      quality: quality,
      bass: bass?.transpose(semitones),
    );
  }

  factory Chord.parse(String value) {
    final regex = RegExp(
      r'^([A-G])(#|b)?(maj13|maj11|maj9|maj7|m13|m11|m9|m7|m6|m|13|11|9|7|dim7|dim|aug|sus2|sus4|add9|add4|add2|6\/9|6|5)?(?:\/([A-G])(#|b)?)?$',
    );

    final match = regex.firstMatch(value.trim());

    if (match == null) {
      throw FormatException('Accord invalide : $value');
    }

    final root = _parseNote(
      '${match.group(1)!}${match.group(2) ?? ""}',
    );

    final quality = _parseQuality(
      match.group(3) ?? '',
    );

    Note? bass;

    if (match.group(4) != null) {
      bass = _parseNote(
        '${match.group(4)!}${match.group(5) ?? ""}',
      );
    }

    return Chord(
      root: root,
      quality: quality,
      bass: bass,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'root': root.international,
      'quality': quality.symbol,
      'bass': bass?.international,
    };
  }

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord.parse(
      '${json["root"]}${json["quality"]}${json["bass"] != null ? "/${json["bass"]}" : ""}',
    );
  }

  static Note _parseNote(String note) {
    switch (note) {
      case 'C':
        return Note.c;
      case 'C#':
      case 'Db':
        return Note.cSharp;
      case 'D':
        return Note.d;
      case 'D#':
      case 'Eb':
        return Note.dSharp;
      case 'E':
        return Note.e;
      case 'F':
        return Note.f;
      case 'F#':
      case 'Gb':
        return Note.fSharp;
      case 'G':
        return Note.g;
      case 'G#':
      case 'Ab':
        return Note.gSharp;
      case 'A':
        return Note.a;
      case 'A#':
      case 'Bb':
        return Note.aSharp;
      case 'B':
        return Note.b;
      default:
        throw FormatException('Note inconnue : $note');
    }
  }

  static ChordQuality _parseQuality(String q) {
    switch (q) {
      case '':
        return ChordQuality.major;
      case 'm':
        return ChordQuality.minor;
      case '7':
        return ChordQuality.dominant7;
      case 'maj7':
        return ChordQuality.major7;
      case 'm7':
        return ChordQuality.minor7;
      case '9':
        return ChordQuality.dominant9;
      case 'maj9':
        return ChordQuality.major9;
      case 'm9':
        return ChordQuality.minor9;
      case '11':
        return ChordQuality.dominant11;
      case 'maj11':
        return ChordQuality.major11;
      case 'm11':
        return ChordQuality.minor11;
      case '13':
        return ChordQuality.dominant13;
      case 'maj13':
        return ChordQuality.major13;
      case 'm13':
        return ChordQuality.minor13;
      case 'dim':
        return ChordQuality.diminished;
      case 'dim7':
        return ChordQuality.diminished7;
      case 'aug':
        return ChordQuality.augmented;
      case 'sus2':
        return ChordQuality.suspended2;
      case 'sus4':
        return ChordQuality.suspended4;
      case 'add2':
        return ChordQuality.add2;
      case 'add4':
        return ChordQuality.add4;
      case 'add9':
        return ChordQuality.add9;
      case '6':
        return ChordQuality.sixth;
      case 'm6':
        return ChordQuality.minor6;
      case '6/9':
        return ChordQuality.sixthNine;
      case '5':
        return ChordQuality.powerChord;
      default:
        return ChordQuality.major;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.write(root.international);
    buffer.write(quality.symbol);

    if (bass != null) {
      buffer.write('/');
      buffer.write(bass!.international);
    }

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chord &&
          root == other.root &&
          quality == other.quality &&
          bass == other.bass;

  @override
  int get hashCode => Object.hash(root, quality, bass);
}