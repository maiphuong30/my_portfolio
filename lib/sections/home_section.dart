import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/translations.dart';

class HomeSection extends StatefulWidget {
  final VoidCallback onViewWork;   // scroll tới Projects
  final VoidCallback onContact;    // scroll tới Contact
  final VoidCallback onScrollDown; // scroll xuống tiếp section dưới

  const HomeSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
    required this.onScrollDown,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<Offset> _dot1Animation; // floating dot 1 (large)
  late final Animation<Offset> _dot2Animation; // floating dot 2 (large)

  // small bubbles: offsets, opacity and scale (no separate controller)
  late final Animation<Offset> _dot3Animation;
  late final Animation<double> _dot3Opacity;
  late final Animation<double> _dot3Scale;

  late final Animation<Offset> _dot4Animation;
  late final Animation<double> _dot4Opacity;
  late final Animation<double> _dot4Scale;

  // Gradient colors used for primary button / headline
  static const Color _gradStart = Color(0xFFFF5A9E); // pink-ish
  static const Color _gradEnd = Color(0xFF7C3AED); // purple-ish

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Scroll indicator bounce
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2), // nhún xuống 20%
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _dot1Animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.10),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _dot2Animation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: const Offset(0, -0.06),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // small bubble 3: subtle vertical + horizontal shift, opacity pulse and scale
    _dot3Animation = Tween<Offset>(
      begin: const Offset(-0.02, 0.0),
      end: const Offset(0.02, -0.02),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)));

    _dot3Opacity = Tween<double>(begin: 0.55, end: 0.18).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    _dot3Scale = Tween<double>(begin: 0.92, end: 1.06).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ));

    // small bubble 4: phase offset for variety
    _dot4Animation = Tween<Offset>(
      begin: const Offset(0.02, 0.02),
      end: const Offset(-0.02, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)));

    _dot4Opacity = Tween<double>(begin: 0.48, end: 0.12).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ));

    _dot4Scale = Tween<double>(begin: 0.88, end: 1.02).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFollowMe({bool center = false}) {
    // lấy mã ngôn ngữ hiện tại
    final localeCode = Localizations.localeOf(context).languageCode;
    final followMeLabel = AppTranslations.text('follow_me', localeCode);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity, // full width
        child: Row(
          mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              followMeLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://www.facebook.com/thaidoanmaiphuong");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: const Icon(Icons.facebook, color: Colors.blue),
            ),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://github.com/maiphuong30");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: FaIcon(FontAwesomeIcons.github, color: Colors.black),
            ),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://www.linkedin.com/in/thaidoanmaiphuong");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: const FaIcon(FontAwesomeIcons.squareLinkedin, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  /// Gradient text implemented with ShaderMask
  Widget gradientHeadline(String text, {double fontSize = 36}) {
    final gradient = const LinearGradient(
      colors: [
        _gradStart,
        _gradEnd,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white, // replaced by shader
        ),
      ),
    );
  }

  /// Badge similar to template: small pill with icon and text
  Widget badgePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // subtle gradient background for the pill
        gradient: LinearGradient(
          colors: [_gradStart.withOpacity(0.14), _gradEnd.withOpacity(0.10)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 16, color: Color(0xFFFF5A9E)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Build primary gradient button similar to template.
  Widget _buildPrimaryButton(String text, VoidCallback onPressed,
      {EdgeInsetsGeometry? padding}) {
    final pad = padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: _gradEnd.withOpacity(0.45),
        backgroundColor: Colors.transparent, // gradient will paint
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: pad,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text, VoidCallback onPressed,
      {EdgeInsetsGeometry? padding}) {
    final pad = padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: _gradStart, width: 2),
      ),
      child: Container(
        padding: pad,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: _gradStart, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Build profile with decorative background and floating dots.
  /// diameter: requested size for whole widget (profile circle area)
  Widget _buildProfileWithDecoration(double diameter) {
    final bgSize = diameter * 1.16;
    final imageSize = diameter * 0.88;
    final borderWidth = diameter * 0.05;

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // radial glow behind profile
          Container(
            width: bgSize,
            height: bgSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.2),
                radius: 0.9,
                colors: [
                  _gradStart.withOpacity(0.20),
                  _gradEnd.withOpacity(0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          // main profile with white border + shadow
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/images/IMG_MYPHOTO.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.person, size: 48, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // Floating dot 1 (top-right)
          Positioned(
            top: diameter * 0.04,
            right: diameter * 0.04,
            child: SlideTransition(
              position: _dot1Animation,
              child: Container(
                width: diameter * 0.14,
                height: diameter * 0.14,
                decoration: BoxDecoration(
                  color: _gradStart,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _gradStart.withOpacity(0.45),
                      blurRadius: 10,
                      spreadRadius: 1.5,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating dot 2 (bottom-left)
          Positioned(
            bottom: diameter * 0.04,
            left: diameter * 0.04,
            child: SlideTransition(
              position: _dot2Animation,
              child: Container(
                width: diameter * 0.11,
                height: diameter * 0.11,
                decoration: BoxDecoration(
                  color: _gradEnd,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _gradEnd.withOpacity(0.40),
                      blurRadius: 8,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Small bubble 3 (top-left, subtler)
          Positioned(
            top: -diameter * 0.04,
            left: -diameter * 0.06,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // convert fractional offset to pixel offset relative to diameter
                final off = _dot3Animation.value;
                final dx = off.dx * diameter * 0.6;
                final dy = off.dy * diameter * 0.6;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: _dot3Opacity.value,
                    child: Transform.scale(
                      scale: _dot3Scale.value,
                      child: Container(
                        width: diameter * 0.07,
                        height: diameter * 0.07,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [_gradStart.withOpacity(0.85), _gradEnd.withOpacity(0.65)]),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _gradStart.withOpacity(0.18),
                              blurRadius: 6,
                              spreadRadius: 0.6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Small bubble 4 (bottom-right, subtler)
          Positioned(
            bottom: -diameter * 0.05,
            right: -diameter * 0.06,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final off = _dot4Animation.value;
                final dx = off.dx * diameter * 0.6;
                final dy = off.dy * diameter * 0.6;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Opacity(
                    opacity: _dot4Opacity.value,
                    child: Transform.scale(
                      scale: _dot4Scale.value,
                      child: Container(
                        width: diameter * 0.06,
                        height: diameter * 0.06,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [_gradEnd.withOpacity(0.75), _gradStart.withOpacity(0.55)]),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _gradEnd.withOpacity(0.14),
                              blurRadius: 6,
                              spreadRadius: 0.4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // dùng AppTranslations cùng locale hiện tại
    String t(String key) => AppTranslations.text(key, Localizations.localeOf(context).languageCode);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    const double profileFraction = 0.4;

    // subtract AppBar height (kToolbarHeight) so HomeSection fits the visible area below AppBar
    final double deviceHeight =
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.vertical -
            kToolbarHeight;
    final double containerHeight = deviceHeight.clamp(360.0, 1100.0);

    // Height reserved for scroll indicator overlay. This value is added to content bottom padding
    const double scrollIndicatorHeight = 88.0; // make a bit larger for safe spacing

    // small vertical padding on mobile
    final double topPadding = isMobile ? 36 : 60;
    // ensure bottom padding includes scrollIndicatorHeight so content isn't overlapped
    final EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, topPadding, 24, topPadding + scrollIndicatorHeight,);

    // --- BUTTON SIZING FOR MOBILE: ensure two buttons fit on one row ---
    final double horizontalPadding = 24.0; // matches contentPadding horizontal
    const double gapBetweenButtons = 12.0;
    final double computedButtonWidth = (screenWidth - horizontalPadding * 2 - gapBetweenButtons) / 2;
    const double buttonMinWidth = 120.0; // avoid too small buttons
    final double buttonWidth = computedButtonWidth < buttonMinWidth ? buttonMinWidth : computedButtonWidth;

    return Container(
      height: containerHeight,
      color: Colors.blue[50],
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bounded scrollable area (height = containerHeight)
          SizedBox(
            height: containerHeight,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: containerHeight),
                child: Center(
                  child: Padding(
                    padding: contentPadding,
                    child: isMobile
                        ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProfileWithDecoration(200),
                        const SizedBox(height: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // dùng key dịch cho badge
                            badgePill(t('available_for_projects')),
                            const SizedBox(height: 12),
                            gradientHeadline(t('hi_im_phuong'), fontSize: 28),
                            const SizedBox(height: 16),
                            Text(
                              t('short_intro_home'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            // <-- REPLACED: use Row with fixed button widths so both buttons stay on one line on mobile -->
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: buttonWidth,
                                  child: _buildPrimaryButton(
                                    t('learn_about_me'),
                                    widget.onViewWork,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                                const SizedBox(width: gapBetweenButtons),
                                SizedBox(
                                  width: buttonWidth,
                                  child: _buildOutlineButton(
                                    t('get_in_touch'),
                                    widget.onContact,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                            _buildFollowMe(center: true),
                          ],
                        ),
                      ],
                    )
                        : LayoutBuilder(builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth;
                      final profileAreaWidth = availableWidth * profileFraction;
                      double computedDiameter = profileAreaWidth * 0.9;
                      final double diameter = computedDiameter.clamp(160.0, 420.0);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                badgePill(t('available_for_projects')),
                                const SizedBox(height: 12),
                                gradientHeadline(t('hi_im_phuong'), fontSize: 36),
                                const SizedBox(height: 16),
                                Text(
                                  t('short_intro_home'),
                                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    _buildPrimaryButton(t('learn_about_me'), widget.onViewWork),
                                    const SizedBox(width: 16),
                                    _buildOutlineButton(t('get_in_touch'), widget.onContact),
                                  ],
                                ),
                                _buildFollowMe(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: profileAreaWidth,
                            child: Center(
                              child: _buildProfileWithDecoration(diameter),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),

          // Scroll Down
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: widget.onScrollDown,
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 140,
                  height: 56,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t('scroll_down'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
