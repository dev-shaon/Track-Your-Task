import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:track_your_task/gen/colors.gen.dart';
import 'package:track_your_task/helpers/notification_service.dart';
import 'package:track_your_task/loading.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'constants/custome_theme.dart';
import 'helpers/all_routes.dart';
import 'helpers/di.dart';
import 'helpers/helpers_method.dart';
import 'helpers/navigation_service.dart';
import 'helpers/register_provider.dart';
import 'networks/dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  diSetUp();
  DioSingleton.instance.create();

  // Notification service initialize
  await NotificationService.instance.init();

  // Initialize AndroidAlarmManager for background TTS + vibration
  await AndroidAlarmManager.initialize();

  if (!kIsWeb) {
    try {
      await _setHighRefreshRate();
    } catch (e) {
      log('Error setting high refresh rate: $e');
    }
  }
  runApp(const MyApp());
}

Future<void> _setHighRefreshRate() async {
  try {
    final flutter_displaymode = await Future.value(null);
    log('$flutter_displaymode');
  } catch (e) {
    log('Display mode error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return MultiProvider(
      providers: providers,
      child: AnimateIfVisibleWrapper(
        showItemInterval: const Duration(milliseconds: 150),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) async {},
          child: LayoutBuilder(
            builder: (context, constraints) {
              return const UtillScreenMobile();
            },
          ),
        ),
      ),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Track Your Task',
          theme: ThemeData(
            primarySwatch: CustomTheme.kToDark,
            primaryColor: AppColors.allPrimaryColor,
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.scaffoldColor,
              elevation: 0,
              foregroundColor: AppColors.allPrimaryColor,
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.allPrimaryColor,
            ),
            scaffoldBackgroundColor: AppColors.c003012.withValues(alpha: 0.6),
          ),
          builder: (context, widget) {
            return MediaQuery(data: MediaQuery.of(context), child: widget!);
          },
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          home: const Loading(),
        );
      },
    );
  }
}
