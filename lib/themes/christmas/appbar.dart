import 'package:flutter/material.dart';
import 'dart:math';

class ChristmasAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(String menu) onMenuTap;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;
  final Locale locale;
  final bool isDarkMode;
  final String Function(String) t;

  const ChristmasAppBar({
    super.key,
    required this.onMenuTap,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.locale,
    required this.isDarkMode,
    required this.t,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    // Tạo các điểm nhấp nhô cố định
    final variations = List.generate(50, (_) => random.nextDouble());

    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 600;

      return Stack(
        children: [
          // Background gradient Christmas
          Container(
            height: preferredSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.red.shade900, Colors.green.shade900]
                    : [Colors.red.shade400, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Sóng tuyết mềm mại, nhấp nhô nhẹ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: preferredSize.height * 0.6,
            child: CustomPaint(
              painter: _SoftSnowPainter(variations: variations),
            ),
          ),

          // AppBar chính
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: isMobile,
            titleSpacing: 10,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + tên
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.pinkAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Mai Phuong",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                // Menu desktop
                if (!isMobile)
                  Row(
                    children: [
                      _NavItem(title: 'Home', label: t('home'), onTap: () => onMenuTap("Home")),
                      _NavItem(title: 'About', label: t('about'), onTap: () => onMenuTap("About")),
                      _NavItem(title: 'Skills', label: t('skills'), onTap: () => onMenuTap("Skills")),
                      _NavItem(title: 'Contact', label: t('contact'), onTap: () => onMenuTap("Contact")),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: onToggleLanguage,
                        icon: Icon(Icons.language, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: onToggleTheme,
                        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

/// ------------------
/// Painter sóng tuyết nhẹ, ổn định
/// ------------------
class _SoftSnowPainter extends CustomPainter {
  final List<double> variations;

  _SoftSnowPainter({required this.variations});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    final path = Path();

    double yBase = size.height / 2;
    path.moveTo(0, size.height);

    int numPoints = variations.length;
    for (int i = 0; i < numPoints; i++) {
      double x = i * (size.width / (numPoints - 1));
      double y = yBase - variations[i] * 6; // nhấp nhô nhẹ, ổn định
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SoftSnowPainter oldDelegate) => false;
}

/// ------------------
/// NavItem cho AppBar
/// ------------------
class _NavItem extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
