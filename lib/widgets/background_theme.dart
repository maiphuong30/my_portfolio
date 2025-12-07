import 'package:flutter/material.dart';

class BackgroundSpecialTheme extends StatefulWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const BackgroundSpecialTheme({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  State<BackgroundSpecialTheme> createState() => _BackgroundSpecialThemeState();
}

class _BackgroundSpecialThemeState extends State<BackgroundSpecialTheme>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 1.0,
      upperBound: 1.15,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scaleController.forward();
      }
    });
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExpanded)
          SizedBox(
            width: 200,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ScaleTransition(
                          scale: _scaleController,
                          child: Icon(
                            Icons.celebration,
                            color: widget.isActive ? Colors.pink : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Special Theme',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Switch(
                          value: widget.isActive,
                          onChanged: (v) {
                            widget.onToggle(v);
                          },
                          activeColor: Colors.pink,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.isActive ? "ON" : "OFF",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),

        // collapsed toggle button
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10)
              ],
            ),
            child: ScaleTransition(
              scale: _scaleController,
              child: Icon(
                Icons.celebration,
                color: widget.isActive ? Colors.pink : Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
