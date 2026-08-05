import 'dart:math';

class PitchResult {
  final String note;
  final double frequency;
  final double targetFrequency;
  final double cents;

  const PitchResult({
    required this.note,
    required this.frequency,
    required this.targetFrequency,
    required this.cents,
  });

  bool get isValid => frequency > 0;

  bool get isInTune => cents.abs() < 3;

  String get fullNote => note;
}

class PitchConverter {
  static const List<String> _notes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  static const double _a4 = 440.0;

  PitchConverter._();

  static PitchResult fromFrequency(double frequency) {
    if (frequency <= 0) {
      return const PitchResult(
        note: '--',
        frequency: 0,
        targetFrequency: 0,
        cents: 0,
      );
    }

    final midi =
        (69 + 12 * (log(frequency / _a4) / ln2)).round();

    final target =
        _a4 * pow(2, (midi - 69) / 12).toDouble();

    final cents =
        1200 * (log(frequency / target) / ln2);

    final octave = (midi ~/ 12) - 1;

    final note =
        '${_notes[midi % 12]}$octave';

    return PitchResult(
      note: note,
      frequency: frequency,
      targetFrequency: target,
      cents: cents,
    );
  }
}