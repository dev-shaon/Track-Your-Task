import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vibration/vibration.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:typed_data';

/// Top-level callback for AndroidAlarmManager.
/// Runs in a background isolate — must be a top-level or static function.
@pragma('vm:entry-point')
Future<void> alarmCallback(int alarmId) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final taskTitle = box.read<String>('alarm_$alarmId') ?? 'your task';

  debugPrint('🔔 Alarm fired for: $taskTitle (id: $alarmId)');

  try {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(pattern: [0, 500, 200, 500, 200, 500]);
    }
  } catch (e) {
    debugPrint('Vibration error: $e');
  }

  try {
    final tts = FlutterTts();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.45);
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    await tts.speak("It's time to $taskTitle");
  } catch (e) {
    debugPrint('TTS error: $e');
  }
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) {
  debugPrint('Notification clicked: ${response.payload}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  NotificationService._internal();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    await _createNotificationChannel();

    _initialized = true;
    debugPrint(' NotificationService initialized.');
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();

      String timeZoneName = timezoneInfo.toString();

      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint(' Timezone set to: $timeZoneName');
    } catch (e) {
      debugPrint(' Fallback to manual TZ: $e');
      _setLocalTimezoneFallback();
    }
  }

  void _setLocalTimezoneFallback() {
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<void> _createNotificationChannel() async {
    final Int64List vibrationPattern = Int64List.fromList([0, 5000]);
    final channel = AndroidNotificationChannel(
      'task_reminder_channel_v2', // ID
      'Task Reminders', // Name
      description: 'Notifications for scheduled tasks',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: vibrationPattern,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showTestNotification() async {
    try {
      if (!_initialized) await init();

      final Int64List vibrationPattern = Int64List.fromList([0, 5000]);
      final androidDetails = AndroidNotificationDetails(
        'task_reminder_channel_v2',
        'Task Reminders',
        channelDescription: 'Testing task notification system',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        enableVibration: true,
        vibrationPattern: vibrationPattern,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await _plugin.show(
        999, // Static ID for test
        ' Test Notification ',
        ' Notification system is working perfectly!',
        notificationDetails,
      );
    } catch (e) {
      debugPrint(' Test notification error: $e');
    }
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.time.isEmpty) return;

    try {
      if (!_initialized) await init();
      final taskDateTime = _parseTaskDateTime(task);
      if (taskDateTime == null) return;

      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Permission requests moved here so they run when an Activity is active
      await androidImpl?.requestNotificationsPermission();

      bool? hasExactAlarm = await androidImpl?.canScheduleExactNotifications();
      if (hasExactAlarm == false) {
        await androidImpl?.requestExactAlarmsPermission();
        hasExactAlarm = await androidImpl?.canScheduleExactNotifications();
      }

      final scheduleMode = hasExactAlarm == true
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      final Int64List vibrationPattern = Int64List.fromList([0, 5000]);

      // --- Schedule the reminder notification (X minutes before) ---
      if (task.reminderMinutes > 0) {
        final reminderTime = taskDateTime.subtract(
          Duration(minutes: task.reminderMinutes),
        );

        if (reminderTime.isAfter(DateTime.now())) {
          final notifId = task.id.hashCode.abs() % 2147483647;

          final androidDetails = AndroidNotificationDetails(
            'task_reminder_channel_v2',
            'Task Reminders',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            vibrationPattern: vibrationPattern,
          );

          final scheduledTZ = tz.TZDateTime.from(reminderTime, tz.local);

          await _plugin.zonedSchedule(
            notifId,
            '⏰ ${task.title}',
            'Starting in ${task.reminderMinutes} minutes. Be ready! ',
            scheduledTZ,
            NotificationDetails(android: androidDetails),
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          debugPrint('📅 Reminder scheduled: ${task.title} at $scheduledTZ');
        } else {
          debugPrint('Reminder time is in the past. Skipping reminder...');
        }
      }

      // --- Schedule the exact-time notification (at the task time) ---
      if (taskDateTime.isAfter(DateTime.now())) {
        final exactNotifId =
            (task.id + '_exact').hashCode.abs() % 2147483647;

        final exactAndroidDetails = AndroidNotificationDetails(
          'task_reminder_channel_v2',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          vibrationPattern: vibrationPattern,
        );

        final exactScheduledTZ =
            tz.TZDateTime.from(taskDateTime, tz.local);

        await _plugin.zonedSchedule(
          exactNotifId,
          '🚀 It\'s time to ${task.title}',
          'Your scheduled task is starting now!',
          exactScheduledTZ,
          NotificationDetails(android: exactAndroidDetails),
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        debugPrint(
            '📅 Exact-time notification scheduled: ${task.title} at $exactScheduledTZ');

        // --- Schedule alarm for TTS + Vibration at exact task time ---
        final alarmId = exactNotifId;

        // Store the task title so the background isolate can read it
        final box = GetStorage();
        await box.write('alarm_$alarmId', task.title);

        await AndroidAlarmManager.oneShotAt(
          taskDateTime,
          alarmId,
          alarmCallback,
          exact: true,
          wakeup: true,
          allowWhileIdle: true,
          rescheduleOnReboot: true,
        );
        debugPrint(
            '🔊 TTS alarm scheduled: "${task.title}" at $taskDateTime');
      } else {
        debugPrint('Task time is in the past. Skipping exact-time notification...');
      }
    } catch (e) {
      debugPrint('❌ Schedule error: $e');
    }
  }

  DateTime? _parseTaskDateTime(TaskModel task) {
    try {
      DateTime date;
      if (task.date.isNotEmpty) {
        final parts = task.date.split('/');
        date = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      } else {
        date = DateTime.now();
      }

      int hour = 0;
      int minute = 0;
      final timeStr = task.time.trim().toUpperCase();

      final RegExp numRegex = RegExp(r'\d+');
      final matches = numRegex.allMatches(timeStr).toList();

      if (matches.length >= 2) {
        hour = int.parse(matches[0].group(0)!);
        minute = int.parse(matches[1].group(0)!);
      }

      if (timeStr.contains('PM') && hour != 12) {
        hour += 12;
      } else if (timeStr.contains('AM') && hour == 12) {
        hour = 0;
      }

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      debugPrint('Error parsing task date time: $e');
      return null;
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    final notifId = taskId.hashCode.abs() % 2147483647;
    final exactTimeNotifId = (taskId + '_exact').hashCode.abs() % 2147483647;

    await _plugin.cancel(notifId);
    await _plugin.cancel(exactTimeNotifId);

    // Cancel the TTS alarm and clean up stored data
    await AndroidAlarmManager.cancel(exactTimeNotifId);
    final box = GetStorage();
    await box.remove('alarm_$exactTimeNotifId');

    debugPrint('🚫 Cancelled all notifications and alarms for task ID: $taskId');
  }
}
