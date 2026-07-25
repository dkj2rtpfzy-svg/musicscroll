import 'package:flutter/material.dart';

class TunerGauge extends StatelessWidget {
  const TunerGauge({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 4,
              ),
            ),
          ),

          const Positioned(
            top: 24,
            child: Text(
              "-50",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Positioned(
            bottom: 24,
            child: Text(
              "+50",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: 6,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.music_note,
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                "--",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}