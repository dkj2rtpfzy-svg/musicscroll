import 'package:flutter/material.dart';

import '../widgets/instrument_selector.dart';
import '../widgets/tuner_gauge.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  String _selectedInstrument = 'Guitare';

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
            const SizedBox(height: 30),
            const Expanded(
              child: Center(
                child: TunerGauge(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}