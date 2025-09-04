import 'package:flutter/material.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  // sample data
  static const _featured = [
    {
      "badge": "Mobile App",
      "title": "EcoTracker Mobile App",
      "desc":
      "A beautiful mobile app that helps users track their carbon footprint with gamification elements and social sharing features.",
      "tags": ["React Native", "TypeScript", "Firebase", "Figma"],
    },
    {
      "badge": "Web App",
      "title": "Modern SaaS Dashboard",
      "desc":
      "A comprehensive dashboard design with advanced data visualization, real-time updates, and intuitive user experience.",
      "tags": ["Next.js", "Tailwind CSS", "Chart.js", "PostgreSQL"],
    },
  ];

  static const _more = [
    {
      "badge": "Portfolio",
      "title": "Creative Portfolio Site",
      "desc":
      "A stunning portfolio website for a photographer with smooth animations and an immersive gallery experience.",
      "tags": ["React", "Framer Motion", "Three.js"],
    },
    {
      "badge": "E-commerce",
      "title": "E-commerce Platform",
      "desc":
      "A complete e-commerce solution with modern design, advanced filtering, and seamless checkout experience.",
      "tags": ["Vue.js", "Node.js", "Stripe"],
    },
    {
      "badge": "Mobile App",
      "title": "Mindfulness App",
      "desc":
      "A calming meditation app with soothing animations, progress tracking, and personalized recommendations.",
      "tags": ["Flutter", "Firebase", "Adobe XD"],
    },
    {
      "badge": "Productivity",
      "title": "Task Management Tool",
      "desc":
      "A collaborative project management tool with real-time updates, team chat, and advanced analytics.",
      "tags": ["React", "Socket.io", "Express.js"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 1100;
    final isMedium = width >= 800 && width < 1100;

    return Container(
      color: Colors.grey[50],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("My Work"),
          ),
          const SizedBox(height: 18),
          const Text(
            "Projects I'm proud of 🚀",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 900,
            child: Text(
              "Each project tells a story of problem-solving, creativity, and attention to detail. Here are some of my favorites!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 36),

          // Featured Projects (two columns on wide)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: const [
                  Icon(Icons.auto_awesome, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    "Featured Projects",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            // Featured in 2 columns on wide, 1 column on small
            final available = constraints.maxWidth;
            final featuredWidth = isWide
                ? (available / 2) - 12
                : available; // two columns or single column
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _featured.map((p) {
                return SizedBox(
                  width: featuredWidth,
                  child: _ProjectCard(
                    badge: p['badge'] as String,
                    title: p['title'] as String,
                    desc: p['desc'] as String,
                    tags: (p['tags'] as List).cast<String>(),
                    largeImage: true,
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 36),

          // More Projects grid
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "More Projects",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[900]),
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            int columns = 1;
            if (maxW > 1200) columns = 3;
            else if (maxW > 900) columns = 3;
            else if (maxW > 700) columns = 2;
            else columns = 1;

            final itemW = (maxW - (20 * (columns - 1))) / columns;
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _more.map((p) {
                return SizedBox(
                  width: itemW,
                  child: _ProjectCard(
                    badge: p['badge'] as String,
                    title: p['title'] as String,
                    desc: p['desc'] as String,
                    tags: (p['tags'] as List).cast<String>(),
                    largeImage: false,
                    showActions: true,
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 40),

          // CTA box
          Container(
            width: isWide ? 640 : double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFCE4F9), Color(0xFFFBF0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.pink.shade100),
            ),
            child: Column(
              children: [
                const Text(
                  "Like what you see?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's work together to bring your ideas to life!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // user will hook to contact section
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // a simple pink-purple gradient look via background color fallback
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text("Start a Project"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String badge;
  final String title;
  final String desc;
  final List<String> tags;
  final bool largeImage;
  final bool showActions;

  const _ProjectCard({
    required this.badge,
    required this.title,
    required this.desc,
    required this.tags,
    this.largeImage = false,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image area (placeholder)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: largeImage ? 240 : 160,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // badge + favorite icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    )
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  title,
                  style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ))
                      .toList(),
                ),

                if (showActions) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.open_in_new),
                          label: const Text("Live"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.code),
                          label: const Text("Code"),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
