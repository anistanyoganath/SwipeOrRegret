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
  State<SwipeCard> createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  Offset position = Offset.zero;
  double rotation = 0;
  bool isAnimating = false;

  static const double threshold = 120;

  late AnimationController controller;
  late Animation<Offset> animation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    controller.addListener(() {
      if (mounted) {
        setState(() {
          position = animation.value;
          rotation = rotationAnimation.value;
        });
      }
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() => isAnimating = false);
        }
      }
    });

    animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(controller);
    rotationAnimation = Tween<double>(begin: 0, end: 0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _animate(Offset targetPosition, double targetRotation, VoidCallback onEnd) {
    if (!mounted) return;

    setState(() => isAnimating = true);

    animation = Tween<Offset>(
      begin: position,
      end: targetPosition,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    rotationAnimation = Tween<double>(
      begin: rotation,
      end: targetRotation,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller
      ..reset()
      ..forward().then((_) {
        if (mounted) {
          onEnd();
        }
      });
  }

  void swipeLeft() {
    if (isAnimating) return;
    _animate(const Offset(-500, 0), -0.4, widget.onSwipeLeft);
  }

  void swipeRight() {
    if (isAnimating) return;
    _animate(const Offset(500, 0), 0.4, widget.onSwipeRight);
  }

  void _onEnd() {
    if (!mounted || isAnimating) return;

    if (position.dx > threshold) {
      _animate(const Offset(500, 0), 0.4, widget.onSwipeRight);
    } else if (position.dx < -threshold) {
      _animate(const Offset(-500, 0), -0.4, widget.onSwipeLeft);
    } else if (position != Offset.zero) {
      _animate(Offset.zero, 0, () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        if (isAnimating) return;
        setState(() {
          position += d.delta;
          rotation = position.dx / 300;
        });
      },
      onPanEnd: (_) => _onEnd(),
      onPanCancel: () => _onEnd(),
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
    );
  }
}
