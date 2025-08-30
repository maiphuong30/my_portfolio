import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("About Me"),
              ),
              const SizedBox(height: 16),
              const Text(
                "Get to know me better 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "I'm a creative developer who believes in the power of beautiful design and clean code to create meaningful digital experiences.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Content Row
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 800;

              if (isMobile) {
                // Mobile: ảnh dưới fun facts
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Story + Fun Facts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "My Story",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "I stumbled into IT rather naturally—no grand plan, no childhood dream of coding. One day I picked the field, studied it, and somehow ended up working in it. Things have gone surprisingly smoothly, as if the universe quietly nudged me along.\n\nI’m not a genius, just an ordinary person putting in small, steady efforts. I spend my days learning on the job, exploring small projects, and occasionally reminding my computer that I know what I’m doing.\n\nOutside work, I enjoy quiet hobbies and experimenting with little tech ideas—sometimes they work, sometimes they don’t, and that’s part of the fun.",
                          style: TextStyle(color: Colors.black87, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined,
                                size: 18, color: Colors.black54),
                            SizedBox(width: 4),
                            Text("Ho Chi Minh City, Viet Nam"),
                            SizedBox(width: 16),
                            Icon(Icons.event_available,
                                size: 18, color: Colors.black54),
                            SizedBox(width: 4),
                            Text("Available"),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Fun Facts About Me:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 20,
                          runSpacing: 12,
                          children: const [
                            _FunFact(
                                icon: FontAwesomeIcons.mugHot,
                                label: "Coffee enthusiast ☕"),
                            _FunFact(
                                icon: FontAwesomeIcons.dog,
                                label: "Dog lover 🐕"),
                            _FunFact(
                                icon: FontAwesomeIcons.code,
                                label: "Night owl coder 🌙"),
                            _FunFact(
                                icon: FontAwesomeIcons.palette,
                                label: "Art collector 🎨"),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    // Image dưới fun facts
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/testImg.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              } else {
                // Desktop: ảnh bên phải
                return Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "My Story",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "I stumbled into IT rather naturally—no grand plan, no childhood dream of coding. One day I picked the field, studied it, and somehow ended up working in it. Things have gone surprisingly smoothly, as if the universe quietly nudged me along.\n\nI’m not a genius, just an ordinary person putting in small, steady efforts. I spend my days learning on the job, exploring small projects, and occasionally reminding my computer that I know what I’m doing.\n\nOutside work, I enjoy quiet hobbies and experimenting with little tech ideas—sometimes they work, sometimes they don’t, and that’s part of the fun.",
                            style: TextStyle(color: Colors.black87, height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Icon(Icons.location_on_outlined,
                                  size: 18, color: Colors.black54),
                              SizedBox(width: 4),
                              Text("Ho Chi Minh City, Viet Nam"),
                              SizedBox(width: 16),
                              Icon(Icons.event_available,
                                  size: 18, color: Colors.black54),
                              SizedBox(width: 4),
                              Text("Available"),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Fun Facts About Me:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 20,
                            runSpacing: 12,
                            children: const [
                              _FunFact(
                                  icon: FontAwesomeIcons.mugHot,
                                  label: "Coffee enthusiast ☕"),
                              _FunFact(
                                  icon: FontAwesomeIcons.dog,
                                  label: "Dog lover 🐕"),
                              _FunFact(
                                  icon: FontAwesomeIcons.code,
                                  label: "Night owl coder 🌙"),
                              _FunFact(
                                  icon: FontAwesomeIcons.palette,
                                  label: "Art collector 🎨"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/testImg.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: -25,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.circle,
                                      color: Colors.green, size: 14),
                                  SizedBox(width: 8),
                                  Text("Currently building something awesome"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 60),

          // Statistics
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: const [
              _StatCard(value: "50+", label: "Projects Completed"),
              _StatCard(value: "3+", label: "Years Experience"),
              _StatCard(value: "25+", label: "Happy Clients"),
              _StatCard(value: "∞", label: "Cups of Coffee"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunFact extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FunFact({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.pink),
        const SizedBox(width: 6),
        Text(label),
      ],
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
