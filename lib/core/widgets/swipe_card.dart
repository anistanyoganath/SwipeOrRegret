import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_theme.dart';

class SwipeCard extends StatefulWidget {
  final String text;
  final String leftChoice;
  final String rightChoice;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final int timeLeft;

  const SwipeCard({
    super.key,
    required this.text,
    required this.leftChoice,
    required this.rightChoice,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.timeLeft,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          widget.onSwipeRight();
        } else if (details.primaryVelocity! < 0) {
          widget.onSwipeLeft();
        }
      },
      child: Container(
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
            // Timer indicator
            LinearProgressIndicator(
              value: widget.timeLeft / 30,
              backgroundColor: colorScheme.surfaceVariant,
              color: colorScheme.primary,
              minHeight: 4,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    widget.text,
                    style: AppTheme.getTextStyle(
                      locale: locale,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Swipe instructions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          widget.leftChoice,
                          style: AppTheme.getTextStyle(
                            locale: locale,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.rightChoice,
                          style: AppTheme.getTextStyle(
                            locale: locale,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
