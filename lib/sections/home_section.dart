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

  // small bubbles: offsets, opacity and scale
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

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _dot1Animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.10),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _dot2Animation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: const Offset(0, -0.06),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textColor = cs.onSurface.withOpacity(0.8);

    final localeCode = Localizations.localeOf(context).languageCode;
    final followMeLabel = AppTranslations.text('follow_me', localeCode);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              followMeLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://www.facebook.com/thaidoanmaiphuong");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: Icon(Icons.facebook, color: cs.primary, size: 20),
              tooltip: 'Facebook',
            ),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://github.com/maiphuong30");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: FaIcon(FontAwesomeIcons.github, color: cs.onSurface, size: 20),
              tooltip: 'GitHub',
            ),
            IconButton(
              onPressed: () async {
                final Uri url = Uri.parse("https://www.linkedin.com/in/thaidoanmaiphuong");
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Could not launch $url');
                }
              },
              icon: FaIcon(FontAwesomeIcons.linkedin, color: cs.secondary, size: 20),
              tooltip: 'LinkedIn',
            ),
          ],
        ),
      ),
    );
  }

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
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget badgePill(String text, {bool isMobile = false}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = Color.alphaBlend(
      (_gradStart).withOpacity(0.12),
      cs.surface,
    );
    final border = cs.outlineVariant.withOpacity(0.6);
    final iconColor = _gradStart;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg, Color.alphaBlend(_gradEnd.withOpacity(0.08), cs.surface)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: isMobile ? 14 : 16, color: iconColor),
          SizedBox(width: isMobile ? 6 : 8),
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
              fontSize: isMobile ? 12 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed,
      {EdgeInsetsGeometry? padding}) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        shadowColor: theme.brightness == Brightness.dark
            ? _gradEnd.withOpacity(0.35)
            : _gradEnd.withOpacity(0.45),
        backgroundColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_gradStart, _gradEnd]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignment: Alignment.center,
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text, VoidCallback onPressed,
      {EdgeInsetsGeometry? padding}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: cs.primary, width: 2),
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileWithDecoration(double diameter) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bgSize = diameter * 1.16;
    final imageSize = diameter * 0.88;
    final borderWidth = diameter * 0.05;

    final borderColor = theme.brightness == Brightness.dark
        ? cs.surfaceVariant
        : Colors.white;

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: bgSize,
            height: bgSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.2),
                radius: 0.9,
                colors: [
                  _gradStart.withOpacity(0.18),
                  _gradEnd.withOpacity(0.10),
                  cs.surface.withOpacity(0.0),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : Colors.black.withOpacity(0.2),
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
                  color: cs.surfaceVariant,
                  child: Icon(Icons.person, size: 48, color: cs.onSurfaceVariant),
                ),
              ),
            ),
          ),
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
          // Small bubbles
          Positioned(
            top: -diameter * 0.04,
            left: -diameter * 0.06,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
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
    String t(String key) => AppTranslations.text(key, Localizations.localeOf(context).languageCode);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    const double profileFraction = 0.4;

    final double deviceHeight =
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.vertical -
            kToolbarHeight;
    final double containerHeight = deviceHeight.clamp(360.0, 1100.0);

    final double topPadding = isMobile ? 24 : 60;
    final EdgeInsets contentPadding = EdgeInsets.fromLTRB(24, topPadding, 24, topPadding + 88);

    final double horizontalPadding = 24.0;
    const double gapBetweenButtons = 12.0;
    final double computedButtonWidth = (screenWidth - horizontalPadding * 2 - gapBetweenButtons) / 2;
    const double buttonMinWidth = 120.0;
    final double buttonWidth = isMobile ? 140 : (computedButtonWidth < buttonMinWidth ? buttonMinWidth : computedButtonWidth);

    final sectionBg = cs.surface;
    final primaryText = cs.onSurface;
    final mutedText = cs.onSurface.withOpacity(0.6);

    return Container(
      height: containerHeight,
      color: sectionBg,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                        _buildProfileWithDecoration(160),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            badgePill(t('available_for_projects'), isMobile: true),
                            const SizedBox(height: 8),
                            gradientHeadline(t('hi_im_phuong'), fontSize: 24),
                            const SizedBox(height: 12),
                            Text(
                              t('short_intro_home'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: mutedText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: buttonWidth,
                                  child: _buildPrimaryButton(
                                    t('learn_about_me'),
                                    widget.onViewWork,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                                const SizedBox(width: gapBetweenButtons),
                                SizedBox(
                                  width: buttonWidth,
                                  child: _buildOutlineButton(
                                    t('get_in_touch'),
                                    widget.onContact,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: mutedText,
                                    fontSize: 18,
                                  ),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 12 : 16,
                            color: mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 28, color: mutedText),
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
