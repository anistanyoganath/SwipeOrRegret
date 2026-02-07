import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const SwipeCard({
    super.key,
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  double rotation = 0;
  bool isAnimating = false;

  static const double threshold = 120;

  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() => position = animation.value);
      }
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => isAnimating = false);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _animate(Offset target, VoidCallback onEnd) {
    if (!mounted) return;

    setState(() => isAnimating = true);

    animation = Tween<Offset>(
      begin: position,
      end: target,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller
      ..reset()
      ..forward().then((_) {
        if (mounted) {
          onEnd();
        }
      });
  }

  void _onEnd() {
    if (!mounted || isAnimating) return;

    if (position.dx > threshold) {
      _animate(const Offset(500, 0), widget.onSwipeRight);
    } else if (position.dx < -threshold) {
      _animate(const Offset(-500, 0), widget.onSwipeLeft);
    } else {
      _animate(Offset.zero, () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) => _onEnd(),
      child: GestureDetector(
        onPanUpdate: (d) {
          if (isAnimating) return;
          setState(() {
            position += d.delta;
            rotation = position.dx / 300;
          });
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Transform.translate(
              offset: position,
              child: Transform.rotate(
                angle: rotation * 3.14 / 12,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}
