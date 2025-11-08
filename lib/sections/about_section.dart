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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(width: gap),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgePill(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.grey[850] : Colors.white,
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 6,
          )
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _imageWithFloatingBadge({
    required double imageHeight,
    double? badgeLeft,
    double badgeBottom = -28,
  }) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final t = (String key) => AppTranslations.text(key, localeCode);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.black12,
                    blurRadius: 12,
                  )
                ],
                border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.green, size: 12),
                  const SizedBox(width: 8),
                  Text(
                    t('about_currently_building'),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    final imageWithShadow = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black26,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/IMG_MYDOG.jpg',
          width: double.infinity,
          height: imageHeight,
          fit: BoxFit.cover,
          color: isDark ? Colors.black.withOpacity(0.05) : null,
          colorBlendMode: isDark ? BlendMode.darken : null,
        ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        imageWithShadow,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(isDark ? 0.4 : 0.2),
                  Colors.transparent
                ],
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
    String t(String key) =>
        AppTranslations.text(key, Localizations.localeOf(context).languageCode);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black;
    final textSecondary = isDark ? Colors.white70 : Colors.black54;
    final bgColor = isDark ? Colors.black : Colors.grey[50];
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

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
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              _badgePill(t('about_badge')),
              const SizedBox(height: 12),
              Text(
                t('about_title'),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 720,
                child: Text(
                  t('about_subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            final storyTitleStyle = TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            );
            final storyTextStyle = TextStyle(
              color: textSecondary,
              height: 1.5,
            );

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('about_story_title'), style: storyTitleStyle),
                  const SizedBox(height: 10),
                  Text(t('about_story_text'), style: storyTextStyle),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(t('about_location'), style: TextStyle(color: textPrimary)),
                      const SizedBox(width: 16),
                      Icon(Icons.event_available, size: 18, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(t('about_available'), style: TextStyle(color: textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t('about_fun_facts_title'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(builder: (ctx, box) {
                    final columns = 2;
                    const gap = 12.0;
                    final itemWidth =
                        (box.maxWidth - (columns - 1) * gap) / columns;
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
                            compact: true,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 20),
                  _imageWithFloatingBadge(imageHeight: 220, badgeLeft: null, badgeBottom: -28),
                  const SizedBox(height: 36),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('about_story_title'), style: storyTitleStyle),
                        const SizedBox(height: 10),
                        Text(t('about_story_text'), style: storyTextStyle),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 18, color: textSecondary),
                            const SizedBox(width: 4),
                            Text(t('about_location'), style: TextStyle(color: textPrimary)),
                            const SizedBox(width: 16),
                            Icon(Icons.event_available, size: 18, color: textSecondary),
                            const SizedBox(width: 4),
                            Text(t('about_available'), style: TextStyle(color: textPrimary)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          t('about_fun_facts_title'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(builder: (ctx, box) {
                          final columns = 2;
                          const gap = 12.0;
                          final itemWidth =
                              (box.maxWidth - (columns - 1) * gap) / columns;
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
                                  compact: false,
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
                        _imageWithFloatingBadge(
                            imageHeight: 360, badgeLeft: 12, badgeBottom: -28),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final columns = maxWidth < 600 ? 2 : 4;
              const spacing = 8.0;
              final itemWidth =
                  (maxWidth - (columns - 1) * spacing) / columns;

              final statCards = stats
                  .map((s) => _StatCard(
                value: s['number'] as String,
                label: s['label'] as String,
              ))
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 8,
          ),
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
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
