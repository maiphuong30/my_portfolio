import 'package:flutter/material.dart';

class ChristmasFooter extends StatelessWidget {
  final bool isDarkMode;
  final Locale locale;
  final String Function(String) t;

  const ChristmasFooter({
    super.key,
    required this.isDarkMode,
    required this.locale,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.red.shade900, Colors.green.shade900]
              : [Colors.red.shade400, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        // Message Christmas luôn ở trên cùng, căn giữa
        final message = Center(
          child: Text(
            "🎄 ${t('merry_christmas')} & ${t('happy_new_year')} 🎁",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.yellow.shade50,
            ),
          ),
        );

        if (isMobile) {
          // Mobile: stacked + centered
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              message,
              const SizedBox(height: 12),
              _leftFooterRow(centered: true),
              const SizedBox(height: 8),
              Text(t('built'), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text("© $year Mai Phuong. ${t('rights')}",
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        }

        // Desktop: message căn giữa trên cùng, footer inline như cũ
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            message,
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _leftFooterRow(centered: false),
                Text(t('built'), style: Theme.of(context).textTheme.bodySmall),
                Text("© $year Mai Phuong. ${t('rights')}",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
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
