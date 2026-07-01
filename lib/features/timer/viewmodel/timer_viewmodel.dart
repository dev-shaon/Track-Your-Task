import 'dart:async';
import 'package:flutter/material.dart';

class TimerViewModel extends ChangeNotifier {
  Timer? _timer;

  Duration _duration = Duration.zero;
  Duration _initialDuration = Duration.zero;

  bool _isRunning = false;

  int selectedHour = 0;
  int selectedMinute = 0;

  Duration get duration => _duration;
  Duration get initialDuration => _initialDuration;
  bool get isRunning => _isRunning;

  double get progress => _initialDuration.inSeconds == 0
      ? 0
      : _duration.inSeconds / _initialDuration.inSeconds;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String get displayTime {
    if (_duration == Duration.zero) return "Set Your Time";
    return formatTime(_duration);
  }

  String get timerLabel => formatTime(_duration);

  void setTime() {
    _duration = Duration(hours: selectedHour, minutes: selectedMinute);
    _initialDuration = _duration;
    notifyListeners();
  }

  void startTimer(VoidCallback onFinished) {
    if (_duration.inSeconds == 0) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 1) {
        _duration -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        timer.cancel();
        _duration = Duration.zero;
        _isRunning = false;
        notifyListeners();
        onFinished();
      }
    });

    _isRunning = true;
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _duration = _initialDuration;
    _isRunning = false;
    notifyListeners();
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
