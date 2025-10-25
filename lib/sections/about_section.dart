import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../localization/translations.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim; // vertical translate for badge
  late final Animation<double> _pulseAnim; // scale pulse for badge

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    // float: 0 -> -5 -> 0
    _floatAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween:
        Tween(begin: 0.0, end: -5.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
        Tween(begin: -5.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // pulse: 1.0 -> 1.05 -> 1.0
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween:
        Tween(begin: 1.0, end: 1.05).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
        Tween(begin: 1.05, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fun fact tile used in grid
  // compact = true -> smaller sizes for mobile
  Widget _funFactTile({
    required IconData icon,
    required String label,
    required Color color,
    bool compact = false,
  }) {
    final double boxSize = compact ? 32 : 36;
    final double iconSize = compact ? 14 : 16;
    final double gap = compact ? 8 : 12;
    final double fontSize = compact ? 13 : 14;
    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: compact ? 6 : 8,
      vertical: compact ? 6 : 8,
    );

    return Container(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  // Image + badge combined (badge is animated)
  // imageHeight: requested image height
  Widget _imageWithFloatingBadge({
    required double imageHeight,
    double? badgeLeft,
    double badgeBottom = -28,
  }) {
    // lấy locale hiện tại & hàm dịch
    final localeCode = Localizations.localeOf(context).languageCode;
    final t = (String key) => AppTranslations.text(key, localeCode);

    // badge widget (animated) - dùng key dịch
    final badge = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, _floatAnim.value),
          child: Transform.scale(
            scale: _pulseAnim.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    t('about_currently_building'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // image container with shadow (no animation)
    final imageWithShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/testImg.png',
          width: double.infinity,
          height: imageHeight,
          fit: BoxFit.cover,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Static image with shadow
        imageWithShadow,

        // overlay gradient for better contrast
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.20), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned(
          left: badgeLeft,
          bottom: badgeBottom,
          child: badge,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dùng AppTranslations cùng locale hiện tại
    String t(String key) => AppTranslations.text(key, Localizations.localeOf(context).languageCode);

    final funFacts = [
      {'icon': FontAwesomeIcons.mugHot, 'text': t('about_fun_fact1'), 'color': Colors.orange},
      {'icon': FontAwesomeIcons.heart, 'text': t('about_fun_fact2'), 'color': Colors.pink},
      {'icon': FontAwesomeIcons.code, 'text': t('about_fun_fact3'), 'color': Colors.blue},
      {'icon': FontAwesomeIcons.palette, 'text': t('about_fun_fact4'), 'color': Colors.purple},
    ];

    final stats = [
      {'number': '50+', 'label': t('stat_projects_completed')},
      {'number': '3+', 'label': t('stat_years_experience')},
      {'number': '25+', 'label': t('stat_happy_clients')},
      {'number': '∞', 'label': t('stat_cups_of_coffee')},
    ];

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Column(
            children: [
              _badgePill(t('about_badge')),
              const SizedBox(height: 12),
              Text(
                t('about_title'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 720,
                child: Text(
                  t('about_subtitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Main grid: left text / right image
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              // Mobile: ảnh dưới fun facts
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('about_story_title'),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t('about_story_text'),
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(t('about_location')),
                      const SizedBox(width: 16),
                      const Icon(Icons.event_available, size: 18, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(t('about_available')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(t('about_fun_facts_title'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  // FUN FACTS GRID (mobile) - 2 columns with spacing and compact tiles
                  LayoutBuilder(builder: (ctx, box) {
                    final columns = 2;
                    const gap = 12.0;
                    final itemWidth = (box.maxWidth - (columns - 1) * gap) / columns;
                    final compact = true; // mobile -> compact
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: funFacts.map((f) {
                        return SizedBox(
                          width: itemWidth,
                          child: _funFactTile(
                            icon: f['icon'] as IconData,
                            label: f['text'] as String,
                            color: f['color'] as Color,
                            compact: compact,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Image + badge (badge floats) — image height smaller on mobile
                  _imageWithFloatingBadge(imageHeight: 220, badgeLeft: null, badgeBottom: -28),

                  // extra spacing to account for badge overlap
                  const SizedBox(height: 36),
                ],
              );
            } else {
              // Desktop: ảnh bên phải
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('about_story_title'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(t('about_story_text'), style: const TextStyle(color: Colors.black87, height: 1.5)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(t('about_location')),
                            const SizedBox(width: 16),
                            const Icon(Icons.event_available, size: 18, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(t('about_available')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(t('about_fun_facts_title'), style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),

                        // FUN FACTS GRID (desktop) - 2 columns, regular size
                        LayoutBuilder(builder: (ctx, box) {
                          final columns = 2;
                          const gap = 12.0;
                          final itemWidth = (box.maxWidth - (columns - 1) * gap) / columns;
                          final compact = false; // desktop -> normal size
                          return Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: funFacts.map((f) {
                              return SizedBox(
                                width: itemWidth,
                                child: _funFactTile(
                                  icon: f['icon'] as IconData,
                                  label: f['text'] as String,
                                  color: f['color'] as Color,
                                  compact: compact,
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Using same unified container: image + badge (badgeLeft provided)
                        _imageWithFloatingBadge(imageHeight: 360, badgeLeft: 12, badgeBottom: -28),

                        // spacing to account for overlap
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),

          const SizedBox(height: 60),

          // Statistics
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              // breakpoint: nếu nhỏ hơn 600 => 2 cột, ngược lại 4 cột
              final columns = maxWidth < 600 ? 2 : 4;
              const spacing = 8.0;
              final itemWidth = (maxWidth - (columns - 1) * spacing) / columns;

              // tạo danh sách card (không const vì dùng t())
              final statCards = stats
                  .map((s) => _StatCard(value: s['number'] as String, label: s['label'] as String))
                  .toList();

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: spacing,
                runSpacing: 10,
                children: statCards
                    .map((card) => SizedBox(
                  width: itemWidth,
                  child: card,
                ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
