import 'dart:async';

import 'package:flutter/foundation.dart';

class TunerService extends ChangeNotifier {
  String _note = "--";
  double _cents = 0;
  bool _running = false;

  Timer? _timer;

  String get note => _note;
  double get cents => _cents;
  bool get isRunning => _running;

  void start() {
    if (_running) return;

    _running = true;

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _cents += 5;

      if (_cents > 50) {
        _cents = -50;
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _running = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}