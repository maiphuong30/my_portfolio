import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/translations.dart';

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

  String t(String key) =>
      AppTranslations.text(key, Localizations.localeOf(context).languageCode);

  Future<void> _launchLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('contact_couldNotLaunch')} $url')),
      );
    }
  }

  Future<void> _sendMessage() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    const String ownerEmail = 'thaidoanmaiphuong@gmail.com';

    final String subject = _subjectCtr.text.trim().isEmpty
        ? t('contact_defaultSubject')
        : _subjectCtr.text.trim();

    final String body = '''
${t('contact_newMessage')}:

${t('contact_name')}: ${_nameCtr.text.trim()}
${t('contact_email')}: ${_emailCtr.text.trim()}

${t('contact_message')}:
${_messageCtr.text.trim()}

---
${t('contact_footerNote')}
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
          SnackBar(content: Text(t('contact_mailOpened'))),
        );
        _nameCtr.clear();
        _emailCtr.clear();
        _subjectCtr.clear();
        _messageCtr.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t('contact_couldNotOpenMail'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${t('contact_errorOpeningMail')}: $e')),
      );
    }
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    final fillColor = isDark ? Colors.grey.shade800 : Colors.grey[100];
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black38),
            filled: true,
            fillColor: fillColor,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = Colors.pink;

    final bgColor = isDark ? Colors.grey.shade900 : Colors.grey[50];
    final cardBg = isDark ? Colors.grey.shade800 : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 28),
      child: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t('contact_getInTouch'),
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          const SizedBox(height: 14),
          Text(
            t('contact_mainHeading'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 850,
            child: Text(
              t('contact_subHeading'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 30),

          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            Widget buildLeftCard() {
              return Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                  boxShadow:
                  const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mail_outline, color: accent),
                          const SizedBox(width: 8),
                          Text(
                            t('contact_sendMessage'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _field(
                              label: "${t('contact_name')} *",
                              controller: _nameCtr,
                              hint: t('contact_hintName'),
                              validator: (v) => (v?.trim().isEmpty ?? true)
                                  ? t('contact_errorName')
                                  : null,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _field(
                              label: "${t('contact_email')} *",
                              controller: _emailCtr,
                              hint: t('contact_hintEmail'),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return t('contact_errorEmailEmpty');
                                }
                                final re = RegExp(
                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                return re.hasMatch(v)
                                    ? null
                                    : t('contact_errorEmailInvalid');
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: "${t('contact_subject')} *",
                        controller: _subjectCtr,
                        hint: t('contact_hintSubject'),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? t('contact_errorSubject')
                            : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: "${t('contact_message')} *",
                        controller: _messageCtr,
                        maxLines: 6,
                        hint: t('contact_hintMessage'),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? t('contact_errorMessage')
                            : null,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 22),

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
                                children: [
                                  const Icon(Icons.send,
                                      size: 18, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    t('contact_sendButton'),
                                    style: const TextStyle(
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

            final rightColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                    boxShadow:
                    const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.favorite, color: accent),
                          const SizedBox(width: 8),
                          Text(t('contact_connectTitle'),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t('contact_connectDesc'),
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        Icon(Icons.location_on_outlined,
                            size: 18, color: isDark ? Colors.white60 : Colors.black54),
                        const SizedBox(width: 8),
                        Text(t('contact_location'),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            )),
                      ]),
                      const SizedBox(height: 4),
                      Text("Phu My, Ho Chi Minh City",
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Icon(Icons.access_time,
                            size: 18, color: isDark ? Colors.white60 : Colors.black54),
                        const SizedBox(width: 8),
                        Text(t('contact_timezone'),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            )),
                      ]),
                      const SizedBox(height: 4),
                      Text("ICT (UTC+7)",
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Icon(Icons.coffee,
                            size: 18, color: isDark ? Colors.white60 : Colors.black54),
                        const SizedBox(width: 8),
                        Text(t('contact_bestTime'),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            )),
                      ]),
                      const SizedBox(height: 4),
                      Text("9 AM - 6 PM",
                          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Social buttons
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow:
                    const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('contact_findMeOnline'),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          )),
                      const SizedBox(height: 12),
                      LayoutBuilder(builder: (context, cstr) {
                        final double max = cstr.maxWidth;
                        const double spacing = 12;
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
                                side: BorderSide(color: borderColor),
                                foregroundColor: isDark ? Colors.white : Colors.black87,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, size: 28, color: isDark ? Colors.white : Colors.black87),
                                  const SizedBox(height: 8),
                                  Text(title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : Colors.black87,
                                      )),
                                  const SizedBox(height: 4),
                                  Text(subtitle,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white60 : Colors.grey[600],
                                      ),
                                      textAlign: TextAlign.center),
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
                              subtitle: t('contact_githubSubtitle'),
                              onTap: () => _launchLink("https://github.com/maiphuong30"),
                            ),
                            socialButton(
                              icon: Icons.work,
                              title: "LinkedIn",
                              subtitle: t('contact_linkedinSubtitle'),
                              onTap: () => _launchLink("https://www.linkedin.com/in/thaidoanmaiphuong"),
                            ),
                            socialButton(
                              icon: Icons.chat_bubble_outline,
                              title: "Instagram",
                              subtitle: t('contact_instagramSubtitle'),
                              onTap: () => _launchLink("https://www.instagram.com/maiphuong30.12.2000/"),
                            ),
                            socialButton(
                              icon: Icons.email_outlined,
                              title: "Email",
                              subtitle: t('contact_emailSubtitle'),
                              onTap: () => _launchLink("mailto:thaidoanmaiphuong@gmail.com"),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Coffee Chat
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? LinearGradient(
                      colors: [Colors.grey.shade900, Colors.grey.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : const LinearGradient(
                      colors: [Color(0xFFfff0f6), Color(0xFFfff5fb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade700 : Colors.pink.shade100,
                    ),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.local_cafe,
                          size: 32, color: isDark ? Colors.pink.shade200 : Colors.black87),
                      const SizedBox(height: 8),
                      Text(t('contact_coffeeChatTitle'),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        t('contact_coffeeChatDesc'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
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
                            await launchUrl(facebookUri, mode: LaunchMode.externalApplication);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
                          foregroundColor: isDark ? Colors.pink.shade200 : Colors.black87,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(t('contact_scheduleChat')),
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
