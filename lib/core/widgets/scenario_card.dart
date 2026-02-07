import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_theme.dart';

class ScenarioCard extends StatelessWidget {
  final String text;
  final String leftChoice;
  final String rightChoice;

  const ScenarioCard({
    super.key,
    required this.text,
    required this.leftChoice,
    required this.rightChoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTheme.getTextStyle(
                    locale: locale,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _choice(leftChoice, Colors.red, Icons.arrow_back),
                _choice(rightChoice, Colors.green, Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _choice(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (icon == Icons.arrow_back) Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          if (icon == Icons.arrow_forward) ...[
            const SizedBox(width: 8),
            Icon(icon, color: color),
          ],
        ],
      ),
    );
  }
}
