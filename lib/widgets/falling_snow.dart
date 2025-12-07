import 'package:flutter/material.dart';
import 'dart:math';

/// ----------------------------
/// FallingSnow nâng cấp thực tế
/// ----------------------------
/// numberOfSnowflakes: số lượng hạt
/// isDarkMode: nền tối hay sáng
class FallingSnow extends StatefulWidget {
  final int numberOfSnowflakes;
  final bool isDarkMode;

  const FallingSnow({super.key, this.numberOfSnowflakes = 35, this.isDarkMode = false});

  @override
  State<FallingSnow> createState() => _FallingSnowState();
}

class _FallingSnowState extends State<FallingSnow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Snowflake> _snowflakes;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _snowflakes = List.generate(widget.numberOfSnowflakes, (index) {
      bool isNear = _random.nextBool(); // 50% gần, 50% xa
      double radius = isNear
          ? _random.nextDouble() * 6 + 6   // hạt gần: 6–12 px
          : _random.nextDouble() * 4 + 2;  // hạt xa: 2–6 px
      double speed = isNear
          ? _random.nextDouble() * 0.0007 + 0.0005 // hạt gần → rơi nhanh
          : _random.nextDouble() * 0.0003 + 0.0002; // hạt xa → rơi chậm

      return _Snowflake(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: radius,
        speed: speed,
        swing: _random.nextDouble() * 15 + 5,
        swingSpeed: _random.nextDouble() * 0.002 + 0.001,
        opacity: isNear
            ? _random.nextDouble() * 0.5 + 0.5   // hạt gần → rõ hơn
            : _random.nextDouble() * 0.3 + 0.2,  // hạt xa → mờ hơn
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer( // không chặn scroll / tap
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _SnowfallPainter(
              snowflakes: _snowflakes,
              progress: _controller.value,
              isDarkMode: widget.isDarkMode,
            ),
          );
        },
      ),
    );
  }
}

class _Snowflake {
  double x; // 0–1
  double y; // 0–1
  double radius;
  double speed;
  double swing;
  double swingSpeed;
  double opacity;

  _Snowflake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.swing,
    required this.swingSpeed,
    required this.opacity,
  });
}

class _SnowfallPainter extends CustomPainter {
  final List<_Snowflake> snowflakes;
  final double progress;
  final bool isDarkMode;

  _SnowfallPainter({
    required this.snowflakes,
    required this.progress,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var flake in snowflakes) {
      // Tính y = rơi + loop
      double posY = (flake.y + progress * flake.speed * size.height * 60) % 1;

      // X swing lắc lư + sin nhỏ tạo bay bồng bềnh
      double posX = flake.x * size.width +
          sin(progress * 2 * pi * flake.swingSpeed + flake.x * 10) * flake.swing;

      final paint = Paint()
        ..color = (isDarkMode ? Colors.white : Colors.grey.shade300)
            .withOpacity(flake.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(posX, posY * size.height), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
