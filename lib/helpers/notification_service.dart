import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:track_your_task/features/add_task/model/task_model.dart';
import 'dart:typed_data';

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
    if (task.time.isEmpty || task.reminderMinutes <= 0) return;

    try {
      if (!_initialized) await init();
      final taskDateTime = _parseTaskDateTime(task);
      if (taskDateTime == null) return;

      final reminderTime = taskDateTime.subtract(
        Duration(minutes: task.reminderMinutes),
      );

      if (reminderTime.isBefore(DateTime.now())) {
        debugPrint('Scheduled time is in the past. Skipping...');
        return;
      }

      final notifId = task.id.hashCode.abs() % 2147483647;

      final Int64List vibrationPattern = Int64List.fromList([0, 5000]);
      final androidDetails = AndroidNotificationDetails(
        'task_reminder_channel_v2',
        'Task Reminders',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        vibrationPattern: vibrationPattern,
      );

      final scheduledTZ = tz.TZDateTime.from(reminderTime, tz.local);

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
      debugPrint('📅 Scheduled: ${task.title} at $scheduledTZ');
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
    await _plugin.cancel(notifId);
    debugPrint('🚫 Cancelled notification for task ID: $taskId');
  }
}
