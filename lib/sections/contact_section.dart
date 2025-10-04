import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _subjectCtr = TextEditingController();
  final _messageCtr = TextEditingController();

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _subjectCtr.dispose();
    _messageCtr.dispose();
    super.dispose();
  }

  Future<void> _launchLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  // UPDATED: open mail client with prefilled fields
  Future<void> _sendMessage() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    const String ownerEmail = 'thaidoanmaiphuong@gmail.com';

    final String subject = _subjectCtr.text.trim().isEmpty
        ? "New Contact Form Message"
        : _subjectCtr.text.trim();

    final String body = '''
You received a new message from your website contact form:

Name: ${_nameCtr.text.trim()}
Email: ${_emailCtr.text.trim()}

Message:
${_messageCtr.text.trim()}

---
This email was generated from your website contact form.
''';

    final String encodedSubject = Uri.encodeComponent(subject);
    final String encodedBody = Uri.encodeComponent(body);

    final Uri emailUri = Uri.parse(
        "mailto:$ownerEmail?subject=$encodedSubject&body=$encodedBody");

    try {
      final bool launched =
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      if (launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opened mail app.')),
        );
        _nameCtr.clear();
        _emailCtr.clear();
        _subjectCtr.clear();
        _messageCtr.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open mail app.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening mail app: $e')),
      );
    }
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.pink;
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
      child: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Get In Touch"),
          ),
          const SizedBox(height: 14),
          const Text(
            "Let's create something amazing together! ✨",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 850,
            child: Text(
              "Have a project in mind? Want to collaborate? Or just want to say hi? I'd love to hear from you!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 30),

          // main content: two columns on wide screens, stacked on mobile
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            // Left card builder (form)
            Widget buildLeftCard() {
              return Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề form
                      Row(
                        children: const [
                          Icon(Icons.mail_outline, color: Colors.pink),
                          SizedBox(width: 8),
                          Text(
                            "Send me a message",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name + Email
                      Row(
                        children: [
                          Expanded(
                            child: _field(
                              label: "Name *",
                              controller: _nameCtr,
                              hint: "Your name",
                              validator: (v) => (v?.trim().isEmpty ?? true)
                                  ? "Please enter name"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _field(
                              label: "Email *",
                              controller: _emailCtr,
                              hint: "your@email.com",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Please enter email";
                                }
                                final re = RegExp(
                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                return re.hasMatch(v) ? null : "Invalid email";
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Subject
                      _field(
                        label: "Subject *",
                        controller: _subjectCtr,
                        hint: "What's this about?",
                        validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? "Please enter subject" : null,
                      ),
                      const SizedBox(height: 16),

                      // Message
                      _field(
                        label: "Message *",
                        controller: _messageCtr,
                        maxLines: 6,
                        hint: "Tell me about your project or just say hi!",
                        validator: (v) =>
                        (v?.trim().isEmpty ?? true) ? "Please enter message" : null,
                      ),
                      const SizedBox(height: 22),

                      // Send button (theo template với gradient)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _sendMessage,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5A9E), Color(0xFF7C3AED)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.send, size: 18, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Send Message",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Right column: contact info + social cards + coffee chat
            final rightColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.favorite, color: Colors.pink),
                          SizedBox(width: 8),
                          Text("Let's connect!", style: TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "I'm always excited to work on new projects and meet amazing people. Whether you have a project in mind, want to collaborate, or just want to chat about design and development, don't hesitate to reach out!",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Row(children: const [
                        Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Location", style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 4),
                      const Text("Phu My, Ho Chi Minh City", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 12),
                      Row(children: const [
                        Icon(Icons.access_time, size: 18, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Timezone", style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 4),
                      const Text("ICT (UTC+7)", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 12),
                      Row(children: const [
                        Icon(Icons.coffee, size: 18, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Best Time", style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 4),
                      const Text("9 AM - 6 PM", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Find me online box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Find me online", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 12),
                      // Responsive grid: 2 per row on wide, 1 per row on narrow
                      LayoutBuilder(builder: (context, cstr) {
                        final double max = cstr.maxWidth;
                        // spacing between items
                        const double spacing = 12;
                        // if we consider 2 columns, each width:
                        final bool twoCol = max >= 480;
                        final double itemWidth = twoCol ? (max - spacing) / 2 : max;

                        Widget socialButton({
                          required IconData icon,
                          required String title,
                          required String subtitle,
                          required VoidCallback onTap,
                        }) {
                          return SizedBox(
                            width: itemWidth,
                            child: OutlinedButton(
                              onPressed: onTap,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, size: 28, color: Colors.black87),
                                  const SizedBox(height: 8),
                                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          );
                        }

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            socialButton(
                              icon: Icons.code,
                              title: "GitHub",
                              subtitle: "Check out my code",
                              onTap: () => _launchLink("https://github.com/maiphuong30"),
                            ),
                            socialButton(
                              icon: Icons.work,
                              title: "LinkedIn",
                              subtitle: "Let's connect professionally",
                              onTap: () => _launchLink("https://www.linkedin.com/in/thaidoanmaiphuong"),
                            ),
                            socialButton(
                              icon: Icons.chat_bubble_outline,
                              title: "Instagram",
                              subtitle: "Follow my journey",
                              onTap: () => _launchLink("https://www.instagram.com/maiphuong30.12.2000/"),
                            ),
                            socialButton(
                              icon: Icons.email_outlined,
                              title: "Email",
                              subtitle: "Send me an email",
                              onTap: () => _launchLink("mailto:thaidoanmaiphuong@gmail.com"),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Coffee Chat box (pink)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFfff0f6), Color(0xFFfff5fb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade100),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.local_cafe, size: 32),
                      const SizedBox(height: 8),
                      const Text("Coffee Chat?", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text(
                        "I'm always up for a virtual coffee chat to discuss ideas, share experiences, or just get to know each other better!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async {
                          const messengerUrl = "https://m.me/thaidoanmaiphuong";
                          const facebookUrl = "https://www.facebook.com/thaidoanmaiphuong";

                          final messengerUri = Uri.parse(messengerUrl);
                          final facebookUri = Uri.parse(facebookUrl);

                          try {
                            final launched = await launchUrl(
                              messengerUri,
                              mode: LaunchMode.externalApplication,
                            );
                            if (!launched) {
                              await launchUrl(facebookUri, mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            // fallback luôn nếu lỗi
                            await launchUrl(facebookUri, mode: LaunchMode.externalApplication);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Schedule a Chat"),
                      ),
                    ],
                  ),
                ),
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: buildLeftCard()),
                  const SizedBox(width: 28),
                  Expanded(flex: 1, child: rightColumn),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLeftCard(),
                  const SizedBox(height: 18),
                  rightColumn,
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}
