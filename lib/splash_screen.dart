import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:track_your_task/features/home/presentation/fullscreen.dart';
import 'package:track_your_task/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _p1SlideAnimation;
  late Animation<Offset> _p2SlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // logo_p1 উপর থেকে সেন্টারে আসবে
    _p1SlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -4.0),
      end: Offset.zero,
    ).animate(curvedAnimation);

    // logo_p2 নিচ থেকে সেন্টারে যাবে
    _p2SlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 4.0),
      end: Offset.zero,
    ).animate(curvedAnimation);

    // মসৃণভাবে দৃশ্যমান হওয়ার জন্য ফেড অ্যানিমেশন
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoHeight = 200.h;
    final double p1Width = logoHeight * (350 / 849);
    final double p2Width = logoHeight * (320 / 849);

    return Scaffold(
      body: FullScreen(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _p1SlideAnimation,
                  child: Image.asset(
                    Assets.images.logoP1.path,
                    height: logoHeight,
                    width: p1Width,
                    fit: BoxFit.fill,
                  ),
                ),
                SlideTransition(
                  position: _p2SlideAnimation,
                  child: Image.asset(
                    Assets.images.logoP2.path,
                    height: logoHeight,
                    width: p2Width,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
