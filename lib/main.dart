import 'package:flutter/material.dart';
import 'sections/home_section.dart';
import 'sections/about_section.dart';

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

  void scrollToSection(GlobalKey key, {bool closeDrawer = false}) {
    if (closeDrawer) {
      Navigator.pop(context); // ✅ chỉ đóng Drawer khi cần
    }
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
      drawer: PortfolioDrawer(onMenuTap: (menu) {
        switch (menu) {
          case "Home":
            scrollToSection(homeKey, closeDrawer: true);
            break;
          case "About":
            scrollToSection(aboutKey, closeDrawer: true);
            break;
          case "Skills":
            scrollToSection(skillsKey, closeDrawer: true);
            break;
          case "Projects":
            scrollToSection(projectsKey, closeDrawer: true);
            break;
          case "Contact":
            scrollToSection(contactKey, closeDrawer: true);
            break;
        }
      }),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HomeSection(
              key: homeKey,
              onViewWork: () => scrollToSection(projectsKey),
              onContact: () => scrollToSection(contactKey),
              onScrollDown: () => scrollToSection(aboutKey),
            ),
            AboutSection(key: aboutKey),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: isMobile, // ✅ chỉ hiện menu mặc định khi mobile
          titleSpacing: 10,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.pink),
                  SizedBox(width: 8),
                  Text(
                    "Mai Phuong",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (!isMobile)
                Row(
                  children: [
                    _NavItem(title: "Home", onTap: () => onMenuTap("Home")),
                    _NavItem(title: "About", onTap: () => onMenuTap("About")),
                    _NavItem(title: "Skills", onTap: () => onMenuTap("Skills")),
                    _NavItem(title: "Projects", onTap: () => onMenuTap("Projects")),
                    _NavItem(title: "Contact", onTap: () => onMenuTap("Contact")),
                    const SizedBox(width: 16),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class PortfolioDrawer extends StatelessWidget {
  final void Function(String menu) onMenuTap;

  const PortfolioDrawer({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          _DrawerItem(title: "Home", onTap: () => onMenuTap("Home")),
          _DrawerItem(title: "About", onTap: () => onMenuTap("About")),
          _DrawerItem(title: "Skills", onTap: () => onMenuTap("Skills")),
          _DrawerItem(title: "Projects", onTap: () => onMenuTap("Projects")),
          _DrawerItem(title: "Contact", onTap: () => onMenuTap("Contact")),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: onTap,
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
      height: 600,
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
