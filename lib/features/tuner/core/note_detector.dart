
import 'dart:math' as math;

/// Détecte la fréquence fondamentale d'un signal audio.
class NoteDetector {
  NoteDetector._();

  static double? detectFrequency(
    List<double> samples, {
    required int sampleRate,
    double minFrequency = 35,
    double maxFrequency = 1200,
  }) {
    if (sampleRate <= 0 || samples.length < 2048) {
      return null;
    }

    if (minFrequency <= 0 || maxFrequency <= minFrequency) {
      return null;
    }

    final mean = samples.reduce((a, b) => a + b) / samples.length;

    final centered = List<double>.generate(
      samples.length,
      (index) => samples[index] - mean,
      growable: false,
    );

    var energy = 0.0;
    for (final sample in centered) {
      energy += sample * sample;
    }

    final rms = math.sqrt(energy / centered.length);
    if (rms < 0.008) return null;

    final minLag = math.max(
      2,
      (sampleRate / maxFrequency).floor(),
    ).toInt();

    final maxLag = math.min(
      (sampleRate / minFrequency).ceil(),
      centered.length ~/ 2,
    ).toInt();

    if (maxLag <= minLag) return null;

    final correlations = List<double>.filled(maxLag + 1, 0);

    for (var lag = minLag; lag <= maxLag; lag++) {
      var cross = 0.0;
      var energyA = 0.0;
      var energyB = 0.0;
      final limit = centered.length - lag;

      for (var index = 0; index < limit; index++) {
        final a = centered[index];
        final b = centered[index + lag];

        cross += a * b;
        energyA += a * a;
        energyB += b * b;
      }

      final denominator = math.sqrt(energyA * energyB);
      if (denominator > 0) {
        correlations[lag] = cross / denominator;
      }
    }

    var bestLag = minLag;
    var bestCorrelation = -1.0;

    for (var lag = minLag; lag <= maxLag; lag++) {
      if (correlations[lag] > bestCorrelation) {
        bestCorrelation = correlations[lag];
        bestLag = lag;
      }
    }

    if (bestCorrelation < 0.65) return null;

    var refinedLag = bestLag.toDouble();

    if (bestLag > minLag && bestLag < maxLag) {
      final left = correlations[bestLag - 1];
      final center = correlations[bestLag];
      final right = correlations[bestLag + 1];
      final denominator = left - 2 * center + right;

      if (denominator.abs() > 0.000001) {
        final adjustment = 0.5 * (left - right) / denominator;
        refinedLag += adjustment.clamp(-0.5, 0.5).toDouble();
      }
    }

    if (refinedLag <= 0) return null;

    final frequency = sampleRate / refinedLag;

    if (frequency < minFrequency || frequency > maxFrequency) {
      return null;
    }

    return frequency;
  }
}