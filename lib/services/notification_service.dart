import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../data/database.dart';

final _plugin = FlutterLocalNotificationsPlugin();
bool _initialized = false;

class NotificationService {
  static Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    final deviceTzInfo = await FlutterTimezone.getLocalTimezone();
    final deviceTz = deviceTzInfo.toString();
    try {
      tz.setLocalLocation(tz.getLocation(deviceTz));
      print('Timezone set to: $deviceTz');
    } catch (_) {
      // Fallback to Asia/Kolkata if timezone not found
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      print('Timezone fallback to Asia/Kolkata');
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // We do not request permissions here! It must happen after runApp().
    _initialized = true;
  }

  /// Request permissions AFTER the app has fully launched (has an Activity).
  static Future<void> requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
      await androidImpl.requestExactAlarmsPermission();
    }
  }

  /// Schedule notifications for [task].
  /// If a due date is set, it ALWAYS schedules a notification exactly at the due date.
  /// If reminderMinutes is > 0, it ALSO schedules a separate early reminder notification.
  static Future<void> scheduleReminder(Task task) async {
    if (task.dueDate == null) return;

    // 1. Always schedule the exact Due Date notification
    await _scheduleSingle(
      id: _idFor(task.id),
      title: 'Atelier — ${task.title}',
      message: "It's time!",
      fireAt: task.dueDate!,
    );

    // 2. Schedule the early Reminder notification (if one was selected and > 0 mins)
    if (task.reminderMinutes != null && task.reminderMinutes! > 0) {
      final reminderTime = task.dueDate!.subtract(Duration(minutes: task.reminderMinutes!));
      final msg = task.reminderMinutes == 1440
          ? 'Due tomorrow'
          : '${task.reminderMinutes} minutes until due';

      await _scheduleSingle(
        id: _reminderIdFor(task.id),
        title: 'Atelier Reminder: ${task.title}',
        message: msg,
        fireAt: reminderTime,
      );
    }
  }

  static Future<void> _scheduleSingle({
    required int id,
    required String title,
    required String message,
    required DateTime fireAt,
  }) async {
    var scheduleTime = fireAt;
    final now = DateTime.now();

    // If scheduleTime is slightly in the past (e.g. user selected "now" and hit save),
    // fire it almost immediately. If it's heavily in the past (>5 mins), skip.
    if (scheduleTime.isBefore(now)) {
      if (scheduleTime.isBefore(now.subtract(const Duration(minutes: 5)))) {
        return; // Too old, ignore
      }
      scheduleTime = now.add(const Duration(seconds: 2));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      message,
      tz.TZDateTime.from(scheduleTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'atelier_reminders',
          'Task Reminders',
          channelDescription: 'Reminders for your Atelier tasks',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder(String taskId) async {
    // Cancel both the due date and the early reminder notifications
    await _plugin.cancel(_idFor(taskId));
    await _plugin.cancel(_reminderIdFor(taskId));
  }

  /// Stable int id from the first 8 chars of UUID.
  static int _idFor(String taskId) =>
      int.parse(taskId.replaceAll('-', '').substring(0, 8), radix: 16) &
      0x7FFFFFFF;

  /// Secondary stable int id for the early reminder.
  static int _reminderIdFor(String taskId) =>
      (int.parse(taskId.replaceAll('-', '').substring(0, 8), radix: 16) ^
          0x55555555) &
      0x7FFFFFFF;
}
