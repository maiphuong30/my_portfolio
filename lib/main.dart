import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'sections/home_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/contact_section.dart';
import 'widgets/background_music.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  Locale _locale = const Locale('en');

  void _toggleLanguage() {
    setState(() {
      _locale =
      _locale.languageCode == 'en' ? const Locale('vi') : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: PortfolioHome(onToggleLanguage: _toggleLanguage, locale: _locale),
    );
  }
}

/// ---------------------------
/// PortfolioHome (main screen)
/// ---------------------------
class PortfolioHome extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final Locale locale;

  const PortfolioHome({
    super.key,
    required this.onToggleLanguage,
    required this.locale,
  });

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollToSection(GlobalKey key, {bool closeDrawer = false}) {
    if (closeDrawer && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // dùng translations từ file riêng
  String t(String key) => AppTranslations.text(key, widget.locale.languageCode);

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
        onToggleLanguage: widget.onToggleLanguage,
        locale: widget.locale,
        t: t,
      ),
      drawer: PortfolioDrawer(
        onMenuTap: (menu) {
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
        },
        locale: widget.locale,
        t: t,
        onToggleLanguage: widget.onToggleLanguage, // ✅ thêm
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HomeSection(
                  key: homeKey,
                  onViewWork: () => scrollToSection(aboutKey),
                  onContact: () => scrollToSection(contactKey),
                  onScrollDown: () => scrollToSection(aboutKey),
                ),
                AboutSection(key: aboutKey),
                SkillsSection(key: skillsKey),
                // ProjectsSection(key: projectsKey),
                ContactSection(key: contactKey),
                const SizedBox(height: 24),
                Footer(locale: widget.locale, t: t),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: const BackgroundMusic(),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------
/// AppBar có nút chuyển ngữ
/// ---------------------------
class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(String menu) onMenuTap;
  final VoidCallback onToggleLanguage;
  final Locale locale;
  final String Function(String) t;

  const PortfolioAppBar({
    super.key,
    required this.onMenuTap,
    required this.onToggleLanguage,
    required this.locale,
    required this.t,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isMobile = constraints.maxWidth < 600;
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: isMobile,
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
                  _NavItem(title: 'Home', label: t('home'), onTap: () => onMenuTap("Home")),
                  _NavItem(title: 'About', label: t('about'), onTap: () => onMenuTap("About")),
                  _NavItem(title: 'Skills', label: t('skills'), onTap: () => onMenuTap("Skills")),
                  //_NavItem(title: 'Projects', label: t('projects'), onTap: () => onMenuTap("Projects")),
                  _NavItem(title: 'Contact', label: t('contact'), onTap: () => onMenuTap("Contact")),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: onToggleLanguage,
                    icon: const Icon(Icons.language, color: Colors.black87),
                    tooltip: locale.languageCode == 'en' ? 'VI' : 'EN',
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}

/// ---------------------------
/// Drawer (mobile menu)
/// ---------------------------
class PortfolioDrawer extends StatelessWidget {
  final void Function(String menu) onMenuTap;
  final Locale locale;
  final String Function(String) t;
  final VoidCallback onToggleLanguage; // ✅ thêm

  const PortfolioDrawer({
    super.key,
    required this.onMenuTap,
    required this.locale,
    required this.t,
    required this.onToggleLanguage, // ✅ thêm
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          _DrawerItem(title: t('home'), onTap: () => onMenuTap("Home")),
          _DrawerItem(title: t('about'), onTap: () => onMenuTap("About")),
          _DrawerItem(title: t('skills'), onTap: () => onMenuTap("Skills")),
          //_DrawerItem(title: t('projects'), onTap: () => onMenuTap("Projects")),
          _DrawerItem(title: t('contact'), onTap: () => onMenuTap("Contact")),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(locale.languageCode == 'en' ? 'Tiếng Việt' : 'English'),
            onTap: () {
              Navigator.pop(context); // đóng Drawer
              onToggleLanguage();     // ✅ đổi ngôn ngữ thực sự
            },
          ),
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
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// Footer (đa ngữ)
/// -------------------------
class Footer extends StatelessWidget {
  final Locale locale;
  final String Function(String) t;

  const Footer({super.key, required this.locale, required this.t});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _leftFooterRow(centered: true),
              const SizedBox(height: 12),
              Text(t('built'), style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 12),
              Text("© $year Mai Phuong. ${t('rights')}",
                  style: const TextStyle(color: Colors.black54)),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _leftFooterRow(centered: false),
            Text(t('built'), style: const TextStyle(color: Colors.black54)),
            Text("© $year Mai Phuong. ${t('rights')}",
                style: const TextStyle(color: Colors.black54)),
          ],
        );
      }),
    );
  }

  Widget _leftFooterRow({required bool centered}) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text("Made with "),
        Icon(Icons.favorite, color: Colors.pink, size: 16),
        SizedBox(width: 6),
        Text(" and "),
        Icon(Icons.code, size: 16, color: Colors.blue),
        SizedBox(width: 6),
        Text(" and "),
        Icon(Icons.local_cafe, size: 16, color: Colors.orange),
        SizedBox(width: 8),
        Text("by Mai Phuong"),
      ],
    );

    return centered ? Center(child: row) : row;
  }
}
