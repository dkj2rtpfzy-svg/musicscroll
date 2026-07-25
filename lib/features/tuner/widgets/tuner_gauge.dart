import 'dart:math';
import 'package:flutter/material.dart';
class TunerGauge extends StatelessWidget {
  final String note;
  final double frequency;
  final double cents;

  const TunerGauge({
    super.key,
    this.note = '--',
    this.frequency = 0,
    this.cents = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool inTune = cents.abs() < 3;

    Color indicatorColor;

    if (inTune) {
      indicatorColor = Colors.green;
    } else if (cents < 0) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.red;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          note,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          frequency == 0
              ? '-- Hz'
              : '${frequency.toStringAsFixed(2)} Hz',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: 280,
          height: 170,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(280, 170),
                painter: _GaugePainter(),
              ),

              Transform.rotate(
                angle: (cents / 50) * 0.8,
                child: Container(
                  width: 4,
                  height: 120,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Text(
          '${cents.toStringAsFixed(1)} cents',
          style: TextStyle(
            fontSize: 18,
            color: indicatorColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text("Trop bas"),
            Icon(Icons.check_circle_outline),
            Text("Trop haut"),
          ],
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.grey;

    canvas.drawArc(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.width,
      ),
      2.55,
      1.18,
      false,
      paint,
    );

    final tickPaint = Paint()
      ..strokeWidth = 2
      ..color = Colors.grey;

    for (int i = -5; i <= 5; i++) {
      final angle = 3.14 / 2 + (i * 0.12);

      final radius1 = 115.0;
      final radius2 = 130.0;

      final center = Offset(size.width / 2, size.width / 2);

      final p1 = Offset(
        center.dx + radius1 * cos(angle),
        center.dy + radius1 * sin(angle),
      );

      final p2 = Offset(
        center.dx + radius2 * cos(angle),
        center.dy + radius2 * sin(angle),
      );

      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}