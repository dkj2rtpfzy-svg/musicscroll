import 'package:flutter/foundation.dart';

import '../core/pitch_converter.dart';

class TunerService extends ChangeNotifier {
  PitchResult _result = const PitchResult(
    note: '--',
    frequency: 0,
    targetFrequency: 0,
    cents: 0,
  );

  PitchResult get result => _result;

  String get note => _result.note;

  double get frequency => _result.frequency;

  double get cents => _result.cents;

  bool get isRunning => false;

  Future<void> start() async {
    // Le moteur audio sera ajouté dans un prochain sprint.
  }

  Future<void> stop() async {}

  /// Permet de tester l'interface sans micro.
  void simulate(double frequency) {
    _result = PitchConverter.fromFrequency(frequency);
    notifyListeners();
  }
}