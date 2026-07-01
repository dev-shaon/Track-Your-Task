import 'package:flutter/material.dart';
import 'package:track_your_task/gen/colors.gen.dart';

import 'navigation_service.dart';

extension Loader on Future {
  Future<dynamic> waitingForSucess() async {
    showDialog(
      barrierColor: AppColors.c003012.withValues(alpha: 0.1),
      context: NavigationService.context,
      builder:
          (context) => Center(
            child: CircularProgressIndicator(),
            // child: SizedBox(
            //   width: 100,
            //   height: 100,
            //   child: Lottie.asset(
            //     Assets.lottie.loadingAnimation,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ),
    );

    try {
      // Wait for the original future to complete
      dynamic result = await this;

      return result;
    } finally {
      // Close the loading dialog
      NavigationService.goBack;
    }
  }
}
