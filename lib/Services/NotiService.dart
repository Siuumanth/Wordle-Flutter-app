import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class DailyNotificationService {
  static final FlutterLocalNotificationsPlugin flutterNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await flutterNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
    tz.initializeTimeZones(); // Initialize timezone data
  }

  Future<void> scheduleDailyNotification() async {
    print("Starting to schedule notifications");
    final prefs = await SharedPreferences.getInstance();
    bool isNotificationScheduled =
        prefs.getBool('notification_scheduled') ?? false;

    if (!isNotificationScheduled) {
      print("Scheduling notification...");

      await flutterNotificationsPlugin.zonedSchedule(
        2, // Notification ID
        "Daily Challenge", // Notification Title
        "Don't forget your daily challenge!", // Notification Body
        _nextInstanceOfTime(10, 59),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      );

      // Set notification scheduled to true after scheduling
      prefs.setBool('notification_scheduled', true);
      print("Notification scheduled successfully at 10:53 AM");
    } else {
      print("Notification already found in cache");
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(
          days: 1)); // Schedule for the next day if the time has passed
    }
    return scheduledDate;
  }

  // Callback to handle notification interaction and reset the flag
  static Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    print('Notificaon sent');
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification_scheduled',
        false); // Reset the flag when notification is received
  }
}
