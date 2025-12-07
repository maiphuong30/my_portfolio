import 'dart:math';
import 'package:flutter/material.dart';

class TwinkleStars extends StatefulWidget {
  final int numberOfStars;
  final double width;
  final double height;

  const TwinkleStars({
    super.key,
    required this.numberOfStars,
    required this.width,
    required this.height,
  });

  @override
  State<TwinkleStars> createState() => _TwinkleStarsState();
}

class _TwinkleStarsState extends State<TwinkleStars>
    with SingleTickerProviderStateMixin {
  late List<_Star> stars;
  late AnimationController _controller;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    stars = List.generate(widget.numberOfStars, (index) {
      return _Star(
        x: random.nextDouble() * widget.width,
        y: random.nextDouble() * widget.height,
        size: random.nextDouble() * 3 + 1,
        opacity: random.nextDouble(),
        speed: random.nextDouble() * 0.02 + 0.01,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
      setState(() {
        for (var star in stars) {
          // Random nhấp nháy
          star.opacity += star.speed;
          if (star.opacity > 1.0) star.opacity = 0.0;
        }
      });
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _TwinkleStarsPainter(stars),
    );
  }
}

class _Star {
  double x;
  double y;
  double size;
  double opacity;
  double speed;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}

class _TwinkleStarsPainter extends CustomPainter {
  final List<_Star> stars;

  _TwinkleStarsPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var star in stars) {
      paint.color = Colors.white.withOpacity(star.opacity);
      canvas.drawCircle(Offset(star.x, star.y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
