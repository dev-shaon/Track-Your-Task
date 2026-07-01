// ignore_for_file: unused_element

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:track_your_task/features/add_task/add_task_screen.dart';
import 'package:track_your_task/features/auth/presentation/signin/signin_screen.dart';
import 'package:track_your_task/features/auth/presentation/sign_up/signup_screen.dart';
import 'package:track_your_task/features/home/presentation/home_screen.dart';
import 'package:track_your_task/navber_screen.dart';

final class Routes {
  static const String homeScreen = '/homeScreen';
  static const String navberScreen = '/navberScreen';
  static const String addTaskScreen = '/addTaskScreen';
  static const String signinScreen = '/signinScreen';
  static const String signupScreen = '/signupScreen';
}

final class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return _buildRoute(const HomeScreen(), settings);
      case Routes.navberScreen:
        return _buildRoute(const NavberScreen(), settings);
      case Routes.addTaskScreen:
        return _buildRoute(const AddTaskScreen(), settings);
      case Routes.signinScreen:
        return _buildRoute(const SigninScreen(), settings);
      case Routes.signupScreen:
        return _buildRoute(const SignupScreen(), settings);
      default:
        return null;
    }
  }

  static Route<dynamic> _buildRoute(Widget widget, RouteSettings settings) {
    return (!kIsWeb && Platform.isAndroid)
        ? _FadedTransitionRoute(widget: widget, settings: settings)
        : CupertinoPageRoute(builder: (context) => widget);
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(milliseconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
              child: child,
            );
          },
        );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;
  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: widget,
    );
  }
}
