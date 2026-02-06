import 'dart:math' as math;

import 'package:flutter/material.dart';

class LiquidSwipeAnimation extends StatefulWidget {
  final bool isDarkMode;

  const LiquidSwipeAnimation({super.key, required this.isDarkMode});

  @override
  State<LiquidSwipeAnimation> createState() => _LiquidSwipeAnimationState();
}

class _LiquidSwipeAnimationState extends State<LiquidSwipeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;
  late Animation<double> _waveOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _rotation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.05, end: 1.0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _waveOffset = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotation.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Liquid border
                  CustomPaint(
                    painter: LiquidBorderPainter(waveOffset: _waveOffset.value),
                    size: Size(280, 280),
                  ),

                  // Inner circle with gradient
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swipe,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                  ),

                  // Animated NO indicator
                  Positioned(
                    left: 40 + 5 * math.sin(_controller.value * 2 * math.pi),
                    top: 120 + 3 * math.cos(_controller.value * 2 * math.pi),
                    child: _AnimatedSwipeIndicator(
                      color: Colors.red,
                      text: 'NO',
                      icon: Icons.arrow_back,
                      animation: _controller,
                      isLeft: true,
                    ),
                  ),

                  // Animated YES indicator
                  Positioned(
                    right:
                        40 +
                        5 * math.sin(_controller.value * 2 * math.pi + math.pi),
                    top:
                        120 +
                        3 * math.cos(_controller.value * 2 * math.pi + math.pi),
                    child: _AnimatedSwipeIndicator(
                      color: Colors.green,
                      text: 'YES',
                      icon: Icons.arrow_forward,
                      animation: _controller,
                      isLeft: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LiquidBorderPainter extends CustomPainter {
  final double waveOffset;

  LiquidBorderPainter({required this.waveOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create liquid effect path
    final path = Path();

    // Start at top
    for (double angle = 0; angle <= 2 * math.pi; angle += 0.05) {
      // Add wave distortion
      final waveAmplitude = 8.0;
      final waveFrequency = 8.0;
      final wave = waveAmplitude * math.sin(waveFrequency * angle + waveOffset);

      final pointX = center.dx + (radius + wave) * math.cos(angle);
      final pointY = center.dy + (radius + wave) * math.sin(angle);

      if (angle == 0) {
        path.moveTo(pointX, pointY);
      } else {
        path.lineTo(pointX, pointY);
      }
    }
    path.close();

    // Draw gradient border
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.purple.withOpacity(0.8),
          Colors.deepPurple.withOpacity(0.9),
          Colors.purple.withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(waveOffset),
      ).createShader(Rect.fromCircle(center: center, radius: radius + 10))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    // Add glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.deepPurple.withOpacity(0.3), Colors.transparent],
        stops: const [0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 20))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(center, radius + 10, glowPaint);
  }

  @override
  bool shouldRepaint(covariant LiquidBorderPainter oldDelegate) {
    return oldDelegate.waveOffset != waveOffset;
  }
}

class _AnimatedSwipeIndicator extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final Animation<double> animation;
  final bool isLeft;

  const _AnimatedSwipeIndicator({
    required this.color,
    required this.text,
    required this.icon,
    required this.animation,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = 1.0 + 0.1 * math.sin(animation.value * 2 * math.pi);
        final opacity = 0.7 + 0.3 * math.sin(animation.value * 2 * math.pi);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: isLeft
                    ? [
                        Icon(icon, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    : [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(icon, color: Colors.white, size: 16),
                      ],
              ),
            ),
          ),
        );
      },
    );
  }
}
