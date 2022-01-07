import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class Alarm extends StatefulWidget {
  Alarm({Key? key}) : super(key: key);
  static var time = [
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 11, 00),
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 15, 00),
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 00)
  ]; //11am,4pm,8pm
  static final reminder =
      []; //stores the next reminder(it will always have only one value)
  final completedReminders = {
    time[0]: false,
    time[1]: false,
    time[2]: false
  }; //status of completion for reminders
  late int endTime; //the difference between the current time and the reminder

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();
    initializeReminders();
    controller = CountdownTimerController(
        endTime: widget.endTime,
        onEnd: () => scheduleAlarm(Alarm.reminder.first));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your next reminder: ${DateFormat('j').format(Alarm.reminder.first)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            CountdownTimer(
              endTime: widget.endTime,
              controller: controller,
              endWidget: const Text(
                'Practice your Movements!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      color: Colors.white,
      elevation: 5,
    );
  }

  void initializeReminders() {
    // widget.completedReminders
    //     .removeWhere((key, value) => DateTime.now().hour >= key);
    widget.completedReminders.forEach((key, value) {
      //key is a datetime object and refers to the time of the reminder
      //if value =true means the reminder is completed
      //if value =false means the reminder is not yet completed
      if (!value) {
        Alarm.reminder.first = key;
        widget.endTime = DateTime.now().millisecondsSinceEpoch +
            DateTime.now()
                .difference(Alarm.reminder.first)
                .inMilliseconds
                .abs();
        if (key.isAtSameMomentAs(Alarm.time[2])) {
          //if this is the last key then set values for the other reminders as false
          //for the next day
          widget.completedReminders.updateAll((key, value) => false);
        }
        return;
        // value = !value;
      }
    });
  }

  void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif',
        channelDescription: "Channel for Alarm notification",
        icon: 'codex_logo',
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        // showProgress: true,
        // maxProgress: widget.endTime,
        // progress: DateTime.now().second,
        largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
        styleInformation: BigPictureStyleInformation(
            DrawableResourceAndroidBitmap('codex_logo')),
        importance: Importance.high,
        priority: Priority.high);

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Its that time of the day!',
        "Practice your movements!!",
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}
