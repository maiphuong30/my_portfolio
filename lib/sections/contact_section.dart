import 'package:flutter/material.dart';

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

  void _sendMessage() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: xử lý gửi message (API, email, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent (stub).')),
      );
      _nameCtr.clear();
      _emailCtr.clear();
      _subjectCtr.clear();
      _messageCtr.clear();
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
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _field(
                              label: "Name *",
                              controller: _nameCtr,
                              hint: "Your name",
                              validator: (v) => (v?.trim().isEmpty ?? true) ? "Please enter name" : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _field(
                              label: "Email *",
                              controller: _emailCtr,
                              hint: "your@email.com",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return "Please enter email";
                                final re = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                return re.hasMatch(v) ? null : "Invalid email";
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _field(
                        label: "Subject *",
                        controller: _subjectCtr,
                        hint: "What's this about?",
                        validator: (v) => (v?.trim().isEmpty ?? true) ? "Please enter subject" : null,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        label: "Message *",
                        controller: _messageCtr,
                        maxLines: 6,
                        hint: "Tell me about your project, ideas, or just say hello!",
                        validator: (v) => (v?.trim().isEmpty ?? true) ? "Please enter message" : null,
                      ),
                      const SizedBox(height: 18),
                      // gradient button built manually
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFff5f8a), Color(0xFF8a2be2)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send_outlined),
                            label: const Text("Send Message"),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                      const Text("San Francisco, CA", style: TextStyle(color: Colors.black54)),
                      const SizedBox(height: 12),
                      Row(children: const [
                        Icon(Icons.access_time, size: 18, color: Colors.black54),
                        SizedBox(width: 8),
                        Text("Timezone", style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 4),
                      const Text("PST (UTC-8)", style: TextStyle(color: Colors.black54)),
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
                      const Text("Find me online", style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.code, size: 22),
                                  SizedBox(height: 6),
                                  Text("GitHub", style: TextStyle(fontWeight: FontWeight.w700)),
                                  SizedBox(height: 4),
                                  Text("Check out my code", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.work, size: 22),
                                  SizedBox(height: 6),
                                  Text("LinkedIn", style: TextStyle(fontWeight: FontWeight.w700)),
                                  SizedBox(height: 4),
                                  Text("Let's connect professionally", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.chat_bubble_outline, size: 22),
                                  SizedBox(height: 6),
                                  Text("Twitter", style: TextStyle(fontWeight: FontWeight.w700)),
                                  SizedBox(height: 4),
                                  Text("Follow my journey", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.email_outlined, size: 22),
                                  SizedBox(height: 6),
                                  Text("Email", style: TextStyle(fontWeight: FontWeight.w700)),
                                  SizedBox(height: 4),
                                  Text("Send me an email", style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        onPressed: () {},
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
                  // left = form (2/3 width)
                  Expanded(flex: 1, child: buildLeftCard()),
                  const SizedBox(width: 28),
                  // right = info column (1)
                  Expanded(flex: 1, child: rightColumn),
                ],
              );
            } else {
              // mobile: stacked
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
          // NOTE: footer removed — page ends here
        ],
      ),
    );
  }
}
