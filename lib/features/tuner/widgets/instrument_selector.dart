import 'package:flutter/material.dart';

class InstrumentSelector extends StatelessWidget {
  final String selectedInstrument;
  final ValueChanged<String> onChanged;

  const InstrumentSelector({
    super.key,
    required this.selectedInstrument,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final instruments = const [
      'Guitare',
      'Basse',
      'Ukulélé',
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedInstrument,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: instruments.map((instrument) {
              return DropdownMenuItem(
                value: instrument,
                child: Text(
                  instrument,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ),
    );
  }
}