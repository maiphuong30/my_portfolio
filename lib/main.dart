import 'package:flutter/material.dart';
import 'sections/home_section.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();

  // Tạo key cho từng section
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PortfolioAppBar(
        onMenuTap: (menu) {
          switch (menu) {
            case "Home":
              scrollToSection(homeKey);
              break;
            case "About":
              scrollToSection(aboutKey);
              break;
            case "Skills":
              scrollToSection(skillsKey);
              break;
            case "Projects":
              scrollToSection(projectsKey);
              break;
            case "Contact":
              scrollToSection(contactKey);
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HomeSection(
              key: homeKey,
              onViewWork: () => scrollToSection(projectsKey),
              onContact: () => scrollToSection(contactKey),
            ),
            _Section(key: aboutKey, title: "About Section", color: Colors.green[50]!),
            _Section(key: skillsKey, title: "Skills Section", color: Colors.orange[50]!),
            _Section(key: projectsKey, title: "Projects Section", color: Colors.purple[50]!),
            _Section(key: contactKey, title: "Contact Section", color: Colors.red[50]!),
          ],
        ),
      ),
    );
  }
}

class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(String menu) onMenuTap;

  const PortfolioAppBar({super.key, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bên trái: Icon trái tim + Tên
          Row(
            children: const [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "My Portfolio",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          // Bên phải: Menu
          Row(
            children: [
              _NavItem(title: "Home", onTap: () => onMenuTap("Home")),
              _NavItem(title: "About", onTap: () => onMenuTap("About")),
              _NavItem(title: "Skills", onTap: () => onMenuTap("Skills")),
              _NavItem(title: "Projects", onTap: () => onMenuTap("Projects")),
              _NavItem(title: "Contact", onTap: () => onMenuTap("Contact")),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Color color;

  const _Section({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // giả sử mỗi section cao 600px
      color: color,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}