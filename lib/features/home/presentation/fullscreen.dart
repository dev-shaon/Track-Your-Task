import 'package:flutter/material.dart';
import 'package:track_your_task/gen/assets.gen.dart';

class FullScreen extends StatelessWidget {
  final Widget child;

  const FullScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.splashScreen.path),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
