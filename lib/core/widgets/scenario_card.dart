import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_theme.dart';

class ScenarioCard extends StatelessWidget {
  final String text;
  final String leftChoice;
  final String rightChoice;
  final VoidCallback? rightClick;
  final VoidCallback? leftClick;

  const ScenarioCard({
    super.key,
    required this.text,
    required this.leftChoice,
    required this.rightChoice,
    this.rightClick,
    this.leftClick,
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
                _ChoiceButton(
                  text: leftChoice,
                  color: Colors.red,
                  icon: Icons.arrow_back,
                  onClick: leftClick,
                ),
                _ChoiceButton(
                  text: rightChoice,
                  color: Colors.green,
                  icon: Icons.arrow_forward,
                  onClick: rightClick,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatefulWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback? onClick;

  const _ChoiceButton({
    required this.text,
    required this.color,
    required this.icon,
    this.onClick,
  });

  @override
  State<_ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<_ChoiceButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onClick,
          borderRadius: BorderRadius.circular(20),
          splashColor: widget.color.withOpacity(0.2),
          highlightColor: widget.color.withOpacity(0.1),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon == Icons.arrow_back) ...[
                  Icon(widget.icon, color: widget.color),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.icon == Icons.arrow_forward) ...[
                  const SizedBox(width: 8),
                  Icon(widget.icon, color: widget.color),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
