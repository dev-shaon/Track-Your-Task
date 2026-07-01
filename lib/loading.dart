import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_your_task/navber_screen.dart';
import 'package:track_your_task/splash_screen.dart';
import 'package:track_your_task/welcome_screen.dart';
import 'constants/app_constants.dart';
import 'helpers/di.dart';
import 'helpers/helpers_method.dart';
import 'networks/dio/dio.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  bool _isLoading = true;

  Future<void> loadInitialData() async {
    await setInitValue();

    bool data = appData.read(kKeyIsLoggedIn) ?? false;
    if (data) {
      String token = appData.read(kKeyAccessToken);
      log("Token is ===========> $token");
      log("FCM Token is ===========> ${appData.read(kKeyFCMToken)}");
      DioSingleton.instance.update(token);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("loding screen >>>>>>>>>>>>><<<<<<<<<<<<<<<<<");
    if (_isLoading) {
      log("loding screen if condition >>>>>>>>>>>>><<<<<<<<<<<<<<<<<");
      return const SplashScreen();
    } else {
      log("loding screen  else condition>>>>>>>>>>>>><<<<<<<<<<<<<<<<<");
      return appData.read(kKeyIsLoggedIn)
          ? const NavberScreen()
          // ? DemoScreen()
          // ? CameraScreen()
          // ? const SelectCapsuleTypeScreen()
          // : const LoginScreen();
          : const WelcomeScreen();
    }
  }
}
