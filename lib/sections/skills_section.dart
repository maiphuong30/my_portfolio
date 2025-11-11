import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/icon_mapper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/translations.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _featureList = [
    {"icon": "smartphone_outlined", "titleKey": "feature_mobile_title", "descKey": "feature_mobile_desc"},
    {"icon": "public", "titleKey": "feature_web_title", "descKey": "feature_web_desc"},
    {"icon": "flash_on", "titleKey": "feature_prototype_title", "descKey": "feature_prototype_desc"},
    {"icon": "favorite_border", "titleKey": "feature_user_title", "descKey": "feature_user_desc"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;

    String t(String key) => AppTranslations.text(key, Localizations.localeOf(context).languageCode);
    // Realtime stream cho skill_groups
    final streamSkillGroups =
    FirebaseFirestore.instance.collection('skill_groups').snapshots();
    final streamCertificates =
    FirebaseFirestore.instance.collection('certificates').snapshots();

    Color cardBgColor() => theme.cardColor;
    Color chipBgColor() => theme.brightness == Brightness.light ? Colors.grey.shade100 : Colors.grey.shade800;
    Color chipTextColor() => theme.textTheme.bodyLarge!.color!;
    Color subtitleColor() => theme.textTheme.bodyMedium!.color!.withOpacity(0.7);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: streamSkillGroups,
      builder: (context, skillSnap) {
        if (skillSnap.hasError) {
          return Container(
            color: theme.scaffoldBackgroundColor,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
            child: Center(child: Text('${t("error_loading_skills")}: ${skillSnap.error}')),
          );
        }

        if (skillSnap.connectionState == ConnectionState.waiting) {
          return Container(
            color: theme.scaffoldBackgroundColor,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Parse skill groups
        List<String> frontendTags = [];
        List<String> dataTags = [];
        List<String> backendTags = [];
        List<String> techTags = [];

        final docs = skillSnap.data?.docs ?? [];
        for (final doc in docs) {
          final id = doc.id.toLowerCase();
          final data = doc.data();
          final dynamic tagsField = data['tags'];
          if (tagsField is List) {
            final tags = tagsField
                .map((e) => e?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList();
            if (id == 'frontend') frontendTags = tags;
            else if (id == 'data') dataTags = tags;
            else if (id == 'backend') backendTags = tags;
            else if (id == 'techchip') techTags = tags;
          }
        }

        return Container(
          color: theme.scaffoldBackgroundColor,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // badge pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? Colors.black12 : Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(t('skills_badge')),
              ),
              const SizedBox(height: 18),
              Text(
                t('skills_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 800,
                child: Text(
                  t('skills_subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: subtitleColor()),
                ),
              ),
              const SizedBox(height: 36),

              // Skill cards
              LayoutBuilder(builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                if (isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.code,
                            iconBg: Colors.blue.shade50,
                            title: t('skills_frontend_title'),
                            tags: frontendTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.storage,
                            iconBg: Colors.pink.shade50,
                            title: t('skills_backend_title'),
                            tags: backendTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.add_chart_outlined,
                            iconBg: Colors.green.shade50,
                            title: t('skills_data_title'),
                            tags: dataTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.code,
                            iconBg: Colors.blue.shade50,
                            title: t('skills_frontend_title'),
                            tags: frontendTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.color_lens,
                            iconBg: Colors.pink.shade50,
                            title: t('skills_backend_title'),
                            tags: backendTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _Hoverable(
                          child: _SkillCard(
                            icon: Icons.storage,
                            iconBg: Colors.green.shade50,
                            title: t('skills_data_title'),
                            tags: dataTags,
                            cardBgColor: cardBgColor(),
                            chipBgColor: chipBgColor(),
                            chipTextColor: chipTextColor(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),

              const SizedBox(height: 44),

              // Certificates header
              Row(
                children: [
                  Icon(Icons.school_outlined, color: accent),
                  const SizedBox(width: 8),
                  Text(
                    t('certificates_title'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // certificates grid (realtime from Firestore)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streamCertificates,
                builder: (context, certSnap) {
                  if (certSnap.hasError) {
                    return Text('${t("error_loading_certificates")}: ${certSnap.error}', style: const TextStyle(color: Colors.red));
                  }
                  if (certSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()));
                  }

                  final certDocs = certSnap.data?.docs ?? [];
                  final certItems = certDocs.map((d) {
                    final data = d.data();
                    final title = (data['title'] ?? '').toString();
                    final issuer = (data['issuer'] ?? '').toString();
                    final year = (data['year'] ?? '').toString();
                    final iconName = (data['icon'] ?? '').toString();
                    final link = (data['link'] ?? '').toString();
                    final icon = iconFromString(iconName);
                    return {
                      'title': title,
                      'issuer': issuer,
                      'year': year,
                      'icon': icon,
                      'link': link,
                    };
                  }).toList();

                  return LayoutBuilder(builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int columns = width > 1200 ? 3 : width > 900 ? 2 : 1;

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: certItems.map((c) => SizedBox(
                        width: (constraints.maxWidth - (20 * (columns - 1))) / columns,
                        child: _Hoverable(
                          child: _CertificateCard(
                            title: c['title'] as String,
                            issuer: c['issuer'] as String,
                            year: c['year'] as String,
                            icon: c['icon'] as IconData,
                            link: c['link'] as String,
                            cardBgColor: cardBgColor(),
                          ),
                        ),
                      )).toList(),
                    );
                  });
                },
              ),

              const SizedBox(height: 40),

              // Feature boxes
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _featureList.map((f) {
                  return SizedBox(
                    width: 260,
                    height: 180,
                    child: _Hoverable(
                      child: _FeatureCard(
                        icon: iconFromString(f['icon'] ?? ''),
                        title: t(f['titleKey'] ?? ''),
                        desc: t(f['descKey'] ?? ''),
                        cardBgColor: cardBgColor(),
                        textColor: theme.textTheme.bodyLarge!.color!,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              // Technologies I Love
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: cardBgColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          t('tech_love_title'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: techTags.map((name) => _Hoverable(child: _TechChip(name, chipBgColor(), chipTextColor()))).toList(),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------- Hoverable wrapper -----------------
class _Hoverable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const _Hoverable({required this.child, this.onTap, this.duration = const Duration(milliseconds: 180)});

  @override
  State<_Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<_Hoverable> {
  bool _hovered = false;

  void _setHovered(bool v) {
    if (!mounted) return;
    setState(() => _hovered = v);
  }

  @override
  Widget build(BuildContext context) {
    final cursor = widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic;

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: AnimatedPhysicalModel(
            duration: widget.duration,
            curve: Curves.easeOut,
            elevation: _hovered ? 10 : 2,
            shape: BoxShape.rectangle,
            shadowColor: Colors.black26,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ----------------- SkillCard -----------------
class _SkillCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final List<String> tags;
  final Color cardBgColor;
  final Color chipBgColor;
  final Color chipTextColor;

  const _SkillCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.tags,
    required this.cardBgColor,
    required this.chipBgColor,
    required this.chipTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: iconBg,
            radius: 26,
            child: Icon(icon, color: Colors.blue, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: tags
                .map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: chipBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                t,
                style: TextStyle(fontSize: 13, color: chipTextColor),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ----------------- CertificateCard -----------------
class _CertificateCard extends StatelessWidget {
  final String title;
  final String issuer;
  final String year;
  final IconData icon;
  final String link;
  final Color cardBgColor;

  const _CertificateCard({
    required this.title,
    required this.issuer,
    required this.year,
    required this.icon,
    this.link = '',
    required this.cardBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700) ?? TextStyle(fontWeight: FontWeight.w700);
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.7))
        ?? TextStyle(color: theme.textTheme.bodyMedium!.color!.withOpacity(0.7));
    final yearStyle = theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall!.color!.withOpacity(0.7))
        ?? TextStyle(color: theme.textTheme.bodySmall!.color!.withOpacity(0.7));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.purple),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 6),
                    Text(issuer, style: subtitleStyle),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: yearStyle.color),
                        const SizedBox(width: 6),
                        Text(year, style: yearStyle),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          if (link.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final uri = Uri.tryParse(link);
                    if (uri == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link không hợp lệ')));
                      return;
                    }
                    try {
                      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể mở link')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể mở link')));
                    }
                  },
                  icon: const Icon(Icons.open_in_new), // giữ màu cũ
                  label: const Text('View'),            // giữ màu cũ
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ----------------- FeatureCard -----------------
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color cardBgColor;
  final Color textColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.cardBgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.purple),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
          const SizedBox(height: 10),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(color: textColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}

// ----------------- TechChip -----------------
class _TechChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _TechChip(this.label, this.bgColor, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, color: textColor)),
    );
  }
}
