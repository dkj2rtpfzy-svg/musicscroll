import 'note.dart';
import 'chord_quality.dart';

/// Représente un accord musical.
///
/// Exemples :
///
/// C
/// Cm
/// Cmaj7
/// F#m7
/// Bbmaj7
/// D/F#
/// Cmaj7/G
class Chord {
  /// Note fondamentale.
  final Note root;

  /// Qualité de l'accord.
  final ChordQuality quality;

  /// Note de basse (optionnelle).
  final Note? bass;

  const Chord({
    required this.root,
    this.quality = ChordQuality.major,
    this.bass,
  });

  bool get hasBass => bass != null;

  /// Retourne une copie avec certaines valeurs modifiées.
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

  /// Transpose l'accord.
  Chord transpose(int semitones) {
    return Chord(
      root: root.transpose(semitones),
      quality: quality,
      bass: bass?.transpose(semitones),
    );
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
          runtimeType == other.runtimeType &&
          root == other.root &&
          quality == other.quality &&
          bass == other.bass;

  @override
  int get hashCode => Object.hash(root, quality, bass);
}