import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_theme.dart';

class AnimatedStatBar extends StatefulWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  final int? previousValue;
  final Duration animationDuration;
  final Locale locale;

  const AnimatedStatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.previousValue,
    required this.locale,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedStatBar> createState() => _AnimatedStatBarState();
}

class _AnimatedStatBarState extends State<AnimatedStatBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _valueAnimation;
  late Animation<double> _opacityAnimation;
  int? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.previousValue ?? widget.value;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _valueAnimation = IntTween(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedStatBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;

      _valueAnimation = IntTween(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: widget.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.label,
                      style: AppTheme.getTextStyle(
                        locale: widget.locale,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    // Show change indicator
                    if (_previousValue != null &&
                        widget.value != _previousValue!)
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (widget.value > _previousValue!)
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.value > _previousValue! ? '+' : ''}${widget.value - _previousValue!}',
                            style: AppTheme.getTextStyle(
                              locale: widget.locale,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: widget.value > _previousValue!
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _valueAnimation.value / 100,
                      backgroundColor: widget.color.withOpacity(0.2),
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Text(
                '${_valueAnimation.value}',
                style: AppTheme.getTextStyle(
                  locale: widget.locale,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
