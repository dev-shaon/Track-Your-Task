import 'dart:math';
import 'package:flutter/material.dart';
import 'package:track_your_task/gen/colors.gen.dart';

class CircularTimer extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String time;

  const CircularTimer({
    super.key,
    required this.progress,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration:  BoxDecoration(
        color: Color(0xFF002117), // ডার্ক গ্রিন ব্যাকগ্রাউন্ড
        shape: BoxShape.circle,
                    border: Border.all(color: AppColors.c1B5E20),

      ),
      child: CustomPaint(
        painter: TimerPainter(progress),
        child: Center(
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'monospace', // ডিজিটাল লুকের জন্য
            ),
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final ringRadius = radius - 20; // বাইরের রিং এর দূরত্ব

    // ১. ব্যাকগ্রাউন্ড রিং (অল্প অপাসিটি)
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 14.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, ringRadius, bgPaint);

    // ২. টিক মার্কস (Ticks)
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 12; i++) {
      // -pi/2 করলে টিকগুলো ১২টা থেকে শুরু হবে
      final angle = (i * 30) * pi / 180 - pi / 2;
      final isCardinal = i % 3 == 0;
      final tickLength = isCardinal ? 15.0 : 8.0;
      
      // টিকগুলোর অবস্থান মাঝের দিকে (Ring থেকে দূরে)
      final start = Offset(
        center.dx + (ringRadius - 35) * cos(angle),
        center.dy + (ringRadius - 35) * sin(angle),
      );
      final end = Offset(
        center.dx + (ringRadius - 35 - tickLength) * cos(angle),
        center.dy + (ringRadius - 35 - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    // ৩. প্রগ্রেস আর্ক (সবুজ অংশ)
    final progressPaint = Paint()
      ..color = const Color(0xFF00C853) // ইমেজের মতো ভাইব্রেন্ট গ্রিন
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: ringRadius),
      -pi / 2, // ১২টা থেকে শুরু
      2 * pi * progress,
      false,
      progressPaint,
    );

    // ৪. কার্ডিনাল ডটস (১২, ৩, ৬, ৯ পজিশনে ছোট ডট)
    final dotPaint = Paint()..color = const Color(0xFF00C853).withOpacity(0.5);
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * pi / 180 - pi / 2;
      final dotPos = Offset(
        center.dx + ringRadius * cos(angle),
        center.dy + ringRadius * sin(angle),
      );
      canvas.drawCircle(dotPos, 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) => 
      oldDelegate.progress != progress;
}