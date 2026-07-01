// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsColorsGen {
  const $AssetsColorsGen();

  /// File path: assets/colors/colors.xml
  String get colors => 'assets/colors/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Inter.ttf
  String get inter => 'assets/fonts/Inter.ttf';

  /// List of all assets
  List<String> get values => [inter];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/add_circle_icon.svg
  String get addCircleIcon => 'assets/icons/add_circle_icon.svg';

  /// File path: assets/icons/add_icon.svg
  String get addIcon => 'assets/icons/add_icon.svg';

  /// File path: assets/icons/all_tasks.svg
  String get allTasks => 'assets/icons/all_tasks.svg';

  /// File path: assets/icons/arrow_down.svg
  String get arrowDown => 'assets/icons/arrow_down.svg';

  /// File path: assets/icons/calendar_icon.svg
  String get calendarIcon => 'assets/icons/calendar_icon.svg';

  /// File path: assets/icons/fitness_icon.svg
  String get fitnessIcon => 'assets/icons/fitness_icon.svg';

  /// File path: assets/icons/home_icon.svg
  String get homeIcon => 'assets/icons/home_icon.svg';

  /// File path: assets/icons/person_icon.svg
  String get personIcon => 'assets/icons/person_icon.svg';

  /// File path: assets/icons/reminder_icon.svg
  String get reminderIcon => 'assets/icons/reminder_icon.svg';

  /// File path: assets/icons/shopping_icon.svg
  String get shoppingIcon => 'assets/icons/shopping_icon.svg';

  /// File path: assets/icons/study_icon.svg
  String get studyIcon => 'assets/icons/study_icon.svg';

  /// File path: assets/icons/task_complete_icon.svg
  String get taskCompleteIcon => 'assets/icons/task_complete_icon.svg';

  /// File path: assets/icons/timer_icon.svg
  String get timerIcon => 'assets/icons/timer_icon.svg';

  /// File path: assets/icons/timer_play.svg
  String get timerPlay => 'assets/icons/timer_play.svg';

  /// File path: assets/icons/topic_icon.svg
  String get topicIcon => 'assets/icons/topic_icon.svg';

  /// File path: assets/icons/travel_icon.svg
  String get travelIcon => 'assets/icons/travel_icon.svg';

  /// File path: assets/icons/watch_icon.svg
  String get watchIcon => 'assets/icons/watch_icon.svg';

  /// File path: assets/icons/work_icon.svg
  String get workIcon => 'assets/icons/work_icon.svg';

  /// List of all assets
  List<String> get values => [
    addCircleIcon,
    addIcon,
    allTasks,
    arrowDown,
    calendarIcon,
    fitnessIcon,
    homeIcon,
    personIcon,
    reminderIcon,
    shoppingIcon,
    studyIcon,
    taskCompleteIcon,
    timerIcon,
    timerPlay,
    topicIcon,
    travelIcon,
    watchIcon,
    workIcon,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/welcome.png
  AssetGenImage get welcome => const AssetGenImage('assets/images/welcome.png');

  /// List of all assets
  List<AssetGenImage> get values => [appLogo, welcome];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/wave_lottie.json
  String get waveLottie => 'assets/lottie/wave_lottie.json';

  /// List of all assets
  List<String> get values => [waveLottie];
}

class Assets {
  const Assets._();

  static const $AssetsColorsGen colors = $AssetsColorsGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
