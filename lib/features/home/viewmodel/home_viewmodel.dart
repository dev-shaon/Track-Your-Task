import 'package:flutter/material.dart';
import 'package:track_your_task/gen/assets.gen.dart';

class HomeViewModel extends ChangeNotifier {
  int? _pressedIndex;
  int? get pressedIndex => _pressedIndex;

  final List<Map<String, String>> categories = [
    {"icon": Assets.icons.workIcon, "label": "Work"},
    {"icon": Assets.icons.studyIcon, "label": "Study"},
    {"icon": Assets.icons.personIcon, "label": "Personal"},
    {"icon": Assets.icons.fitnessIcon, "label": "GYM"},
    {"icon": Assets.icons.shoppingIcon, "label": "Shopping"},
    {"icon": Assets.icons.travelIcon, "label": "Travel"},
  ];

  void onPressDown(int index) {
    _pressedIndex = index;
    notifyListeners();
  }

  void onPressUp() {
    _pressedIndex = null;
    notifyListeners();
  }
}
