
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

import '../core/note_detector.dart';
import '../core/pitch_converter.dart';

class TunerService extends ChangeNotifier {
  static const int _sampleRate = 44100;
  static const int _windowSize = 8192;

  final AudioRecorder _recorder = AudioRecorder();

  StreamSubscription<Uint8List>? _subscription;

  final List<double> _samples = [];

  PitchResult _result = const PitchResult(
    note: '--',
    frequency: 0,
    targetFrequency: 0,
    cents: 0,
  );

  bool _isRunning = false;
  bool _disposed = false;
  String? _error;

  PitchResult get result => _result;
  String get note => _result.note;
  double get frequency => _result.frequency;
  double get cents => _result.cents;
  bool get isRunning => _isRunning;
  String? get error => _error;

  Future<void> start() async {
    if (_isRunning) return;

    _error = null;
    _samples.clear();

    try {
      final hasPermission = await _recorder.hasPermission();

      if (!hasPermission) {
        _error = 'Autorisation du microphone refusée.';
        _notify();
        return;
      }

      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: _sampleRate,
          numChannels: 1,
          autoGain: false,
          echoCancel: false,
          noiseSuppress: false,
        ),
      );

      if (_disposed) {
        await _recorder.stop();
        return;
      }

      _subscription = stream.listen(
        _processAudio,
        onError: (Object error) {
          _error = 'Erreur du microphone : $error';
          _isRunning = false;
          _notify();
        },
        onDone: () {
          _isRunning = false;
          _notify();
        },
      );

      _isRunning = true;
      _notify();
    } catch (error) {
      _isRunning = false;
      _error = 'Impossible de démarrer le microphone : $error';
      _notify();
    }
  }

  void _processAudio(Uint8List bytes) {
    if (_disposed || bytes.length < 2) return;

    final data = ByteData.sublistView(bytes);
    final sampleCount = bytes.length ~/ 2;

    for (var i = 0; i < sampleCount; i++) {
      final value = data.getInt16(i * 2, Endian.little);
      _samples.add(value / 32768.0);
    }

    if (_samples.length < _windowSize) return;

    final window = _samples.sublist(
      _samples.length - _windowSize,
    );

    final detectedFrequency = NoteDetector.detectFrequency(
      window,
      sampleRate: _sampleRate,
      minFrequency: 35,
      maxFrequency: 1200,
    );

    if (detectedFrequency != null &&
        detectedFrequency.isFinite &&
        detectedFrequency > 0) {
      _result = PitchConverter.fromFrequency(detectedFrequency);
      _notify();
    }

    if (_samples.length > _windowSize * 2) {
      _samples.removeRange(
        0,
        _samples.length - _windowSize,
      );
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    try {
      if (_isRunning) {
        await _recorder.stop();
      }
    } catch (error) {
      _error = 'Erreur lors de l’arrêt du microphone : $error';
    }

    _isRunning = false;
    _samples.clear();
    _notify();
  }

  /// Permet de tester l'interface sans microphone.
  void simulate(double frequency) {
    _result = PitchConverter.fromFrequency(frequency);
    _notify();
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> _releaseRecorder() async {
    await _subscription?.cancel();

    try {
      if (_isRunning) {
        await _recorder.stop();
      }
    } catch (_) {
      // Le microphone peut déjà être arrêté.
    }

    await _recorder.dispose();
  }

  @override
  void dispose() {
    _disposed = true;
    _isRunning = false;
    unawaited(_releaseRecorder());
    super.dispose();
  }
}