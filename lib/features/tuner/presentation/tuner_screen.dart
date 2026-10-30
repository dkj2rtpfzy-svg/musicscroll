
import 'package:flutter/material.dart';

import '../services/tuner_service.dart';
import '../widgets/instrument_selector.dart';
import '../widgets/tuner_gauge.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  String _selectedInstrument = 'Guitare';

  late final TunerService _tunerService;

  @override
  void initState() {
    super.initState();
    _tunerService = TunerService();
  }

  Future<void> _toggleTuner() async {
    if (_tunerService.isRunning) {
      await _tunerService.stop();
    } else {
      await _tunerService.start();
    }
  }

  @override
  void dispose() {
    _tunerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accordeur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            InstrumentSelector(
              selectedInstrument: _selectedInstrument,
              onChanged: (instrument) {
                setState(() {
                  _selectedInstrument = instrument;
                });
              },
            ),

            const SizedBox(height: 20),

            AnimatedBuilder(
              animation: _tunerService,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _toggleTuner,
                    icon: Icon(
                      _tunerService.isRunning
                          ? Icons.stop
                          : Icons.mic,
                    ),
                    label: Text(
                      _tunerService.isRunning
                          ? 'Arrêter l’accordeur'
                          : 'Activer le microphone',
                    ),
                  ),
                );
              },
            ),

            AnimatedBuilder(
              animation: _tunerService,
              builder: (context, child) {
                if (_tunerService.error == null) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _tunerService.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _tunerService,
                  builder: (context, child) {
                    return TunerGauge(
                      note: _tunerService.note,
                      frequency: _tunerService.frequency,
                      cents: _tunerService.cents,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}