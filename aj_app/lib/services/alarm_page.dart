import 'dart:async';

import 'package:aj_app/services/update_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../main.dart';

bool isRunning = true;
final _refreshRate = Duration(seconds: 5);
final timeout = Duration(hours: 0, minutes: 5);
// final time = [
//   {
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 11,
//         00): false
//   },
//   {
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12,
//         11): false
//   },
//   {
//     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20,
//         00): false
//   }
// ];
final time = UpdateDoc.getReminders();
Duration? nextReminder;

Future<List> getTime() {
  return time;
}

class AlarmPage extends StatefulWidget {
  AlarmPage({Key? key}) : super(key: key);

  static void onUploadSucess() async {
    final datePath = DateFormat.yMMMMd('en_US').format(DateTime.now());
    var data = await UpdateDoc.getUploadedStatusFromDatabase();
    if (data['video_paths'][datePath] != null) {
      data['video_paths'][datePath].forEach((key, value) async {
        if (value != null) {
          for (var map in await time) {
            var correspondingTime = map.keys.first;
            if (DateFormat.j().format(correspondingTime) == key)
              map.updateAll((key, value) => true);
          }
        }
      });
    }
  }

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final now = DateTime.now();

  get showEndWidget {
    return Text(
      'Practice your Movements!',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkAlarmStatus();
    // timerController = CountdownTimerController(
    //     endTime: now.millisecondsSinceEpoch +
    //         model.timeTillNextReminder.inMilliseconds,
    //     onEnd: model.scheduleAlarm
    //     // await AndroidAlarmManager.oneShotAt(
    //     //   now,
    //     //   0,
    //     //   model.scheduleAlarm,
    //     //   alarmClock: true,
    //     //   allowWhileIdle: true,
    //     //   exact: true,
    //     //   wakeup: true,
    //     //   rescheduleOnReboot: true,
    //     // );
    //     //   scheduleAlarm(Alarm.pendingReminder.isNotEmpty
    //     //       ? Alarm.pendingReminder.top()
    //     //       : Alarm.completedReminders.top());
    //     );
    Timer.periodic(_refreshRate, (timer) => checkAlarmStatus());
  }

  bool _soundPlayed = false;
  late CountdownTimerController timerController;
  late Duration timeTillNextReminder = Duration(minutes: 2);

  void checkAlarmStatus() async {
    print("checking alarm status");
    for (var map in await time) {
      var reminder = map.keys.first;
      var uploaded = map.values.first;
      if (DateTime.now().isBefore(reminder.add(timeout)) &&
          DateTime.now().isAfter(reminder) &&
          !uploaded) {
        timeTillNextReminder = Duration(seconds: 0);
        _soundPlayed = true;
        break;
      } else if (DateTime.now().isBefore(reminder) ||
          DateTime.now().isAtSameMomentAs(reminder)) {
        timeTillNextReminder = reminder.difference(DateTime.now());
        _soundPlayed = false;
        break;
      }
      // if (reminder.isAtSameMomentAs(time.last)) last = true;
    }

    timerController = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch +
            timeTillNextReminder.inMilliseconds,
        onEnd: scheduleAlarm);
    nextReminder = timeTillNextReminder;

    if (mounted) {
      setState(() {
        // timerController.notifyListeners();
      });
    }
  }

  void scheduleAlarm() async {
    if (!_soundPlayed) {
      DateTime scheduledNotificationDateTime = DateTime.now();
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'alarm_notif', 'alarm_notif',
          channelDescription: "Channel for Alarm notification",
          icon: 'codex_logo',
          sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
          // showProgress: true,
          // maxProgress: widget.endTime,
          // progress: now.second,
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

  DateTime getReminderTime() {
    return DateTime.now().add(timeTillNextReminder);
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your next reminder is ${isTimeUp() ? 'Now!' : 'in:'}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
              ),
              CountdownTimer(
                controller: timerController,
                endWidget: showEndWidget,
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
      color: Colors.white,
      elevation: 5,
    );
  }

  bool isTimeUp() {
    if (timeTillNextReminder.inSeconds == 0) return true;
    return false;
  }

  DateTime getCurrentReminder() {
    return now.add(timeTillNextReminder);
  }
}
