import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/icon_mapper.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _featureList = [
    {
      "icon": "smartphone_outlined",
      "title": "Mobile-First Design",
      "desc": "Creating responsive experiences that work beautifully on all devices"
    },
    {
      "icon": "public",
      "title": "Web Performance",
      "desc": "Optimizing for speed, accessibility, and user experience"
    },
    {
      "icon": "flash_on",
      "title": "Rapid Prototyping",
      "desc": "Quick iteration from concept to working prototype"
    },
    {
      "icon": "favorite_border",
      "title": "User-Centered Design",
      "desc": "Putting user needs and emotions at the center of design decisions"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final accent = Colors.purple.shade700;

    // Realtime stream cho skill_groups
    final streamSkillGroups =
    FirebaseFirestore.instance.collection('skill_groups').snapshots();

    // Realtime stream cho certificates
    final streamCertificates =
    FirebaseFirestore.instance.collection('certificates').snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: streamSkillGroups,
      builder: (context, skillSnap) {
        // handle errors / loading
        if (skillSnap.hasError) {
          return Container(
            color: Colors.grey[50],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
            child: Center(child: Text('Error loading skills: ${skillSnap.error}')),
          );
        }

        if (skillSnap.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[50],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Parse skill groups
        List<String> frontendTags = [];
        List<String> designTags = [];
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
            if (id == 'frontend') {
              frontendTags = tags;
            } else if (id == 'design') {
              designTags = tags;
            } else if (id == 'backend') {
              backendTags = tags;
            } else if (id == 'techchip') {
              techTags = tags;
            }
          }
        }

        return Container(
          color: Colors.grey[50],
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // small pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("My Skills"),
              ),
              const SizedBox(height: 18),
              const Text(
                "What I bring to the table ✨",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 800,
                child: Text(
                  "A blend of technical expertise and creative vision, backed by continuous learning and certifications.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 36),

              // --- Skill cards row (3 cards on wide screen) ---
              LayoutBuilder(builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                if (isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SkillCard(
                          icon: Icons.code,
                          iconBg: Colors.blue.shade50,
                          title: "Frontend Development",
                          tags: frontendTags,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _SkillCard(
                          icon: Icons.color_lens,
                          iconBg: Colors.pink.shade50,
                          title: "Design & UX",
                          tags: designTags,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _SkillCard(
                          icon: Icons.storage,
                          iconBg: Colors.green.shade50,
                          title: "Backend & Tools",
                          tags: backendTags,
                        ),
                      ),
                    ],
                  );
                } else {
                  // mobile / tablet: stacked with spacing (full width each)
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _SkillCard(
                          icon: Icons.code,
                          iconBg: Colors.blue.shade50,
                          title: "Frontend Development",
                          tags: frontendTags,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _SkillCard(
                          icon: Icons.color_lens,
                          iconBg: Colors.pink.shade50,
                          title: "Design & UX",
                          tags: designTags,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _SkillCard(
                          icon: Icons.storage,
                          iconBg: Colors.green.shade50,
                          title: "Backend & Tools",
                          tags: backendTags,
                        ),
                      ),
                    ],
                  );
                }
              }),

              const SizedBox(height: 44),

              // --- Certificates & Achievements header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined, color: accent),
                  const SizedBox(width: 8),
                  const Text(
                    "Certificates & Achievements",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // certificates grid (realtime from Firestore)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streamCertificates,
                builder: (context, certSnap) {
                  // nếu lỗi -> hiển thị message nhỏ
                  if (certSnap.hasError) {
                    return Text('Error loading certificates: ${certSnap.error}',
                        style: const TextStyle(color: Colors.red));
                  }

                  // nếu đang load -> spinner nhỏ
                  if (certSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()));
                  }

                  final certDocs = certSnap.data?.docs ?? [];

                  // chuyển thành list data
                  final certItems = certDocs.map((d) {
                    final data = d.data();
                    final title = (data['title'] ?? '').toString();
                    final issuer = (data['issuer'] ?? '').toString();
                    final year = (data['year'] ?? '').toString();
                    final iconName = (data['icon'] ?? '').toString();
                    final icon = iconFromString(iconName);
                    return {
                      'title': title,
                      'issuer': issuer,
                      'year': year,
                      'icon': icon,
                    };
                  }).toList();

                  // responsive columns
                  return LayoutBuilder(builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int columns = 1;
                    if (width > 1200) {
                      columns = 3;
                    } else if (width > 900) {
                      columns = 2;
                    } else {
                      columns = 1;
                    }

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: certItems
                          .map((c) => SizedBox(
                        width: (constraints.maxWidth - (20 * (columns - 1))) / columns,
                        child: _CertificateCard(
                          title: c['title'] as String,
                          issuer: c['issuer'] as String,
                          year: c['year'] as String,
                          icon: c['icon'] as IconData,
                        ),
                      ))
                          .toList(),
                    );
                  });
                },
              ),

              const SizedBox(height: 40),

              // --- Feature boxes (4) ---
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _featureList.map((f) {
                  return SizedBox(
                    width: 260,
                    child: _FeatureCard(
                      icon: iconFromString(f['icon'] ?? ''),
                      title: f['title'] as String,
                      desc: f['desc'] as String,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(
                          "Technologies I Love",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.star, color: Colors.amber),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: techTags.map((name) => _TechChip(name)).toList(),
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

// ----------------- small widgets -----------------

class _SkillCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final List<String> tags;

  const _SkillCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // card style similar to design: white bg, light border, rounded
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          // icon circle
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                t,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String title;
  final String issuer;
  final String year;
  final IconData icon;

  const _CertificateCard({
    required this.title,
    required this.issuer,
    required this.year,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // similar card to design
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
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
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(issuer, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.black45),
                    const SizedBox(width: 6),
                    Text(year, style: const TextStyle(color: Colors.black45)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.purple),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
