import 'package:flutter/material.dart';
import 'package:swipeorregret/app/app_routes.dart';
import 'package:swipeorregret/features/splash/splash_controller.dart';
import 'package:swipeorregret/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        final localizations = AppLocalizations.of(context);

        return Scaffold(
          backgroundColor: Colors.deepPurple,
          body: Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon with animation
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swipe,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App Name with gradient text
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      localizations?.appTitle ?? 'SWIPE OR REGRET',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    localizations?.tagline ?? 'One choice. No undo.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Loading indicator
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      value: snapshot.connectionState == ConnectionState.waiting
                          ? null
                          : 1.0,
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loading text
                  Text(
                    snapshot.connectionState == ConnectionState.waiting
                        ? (localizations?.translate('loading_scenarios') ??
                              'Loading scenarios...')
                        : (localizations?.translate('ready') ?? 'Ready!'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    final controller = SplashController();
    await controller.initializeApp(context);

    // Add small delay to show "Ready!" message
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }
}
