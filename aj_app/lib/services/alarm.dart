import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:intl/intl.dart';

class Alarm extends StatefulWidget {
  Alarm({Key? key}) : super(key: key);
  static const time = [11, 15, 20]; //11am,4pm,8pm
  static final reminders = [];
  final completedReminders = {time[0]: false, time[1]: false, time[2]: false};
  late int endTime;

  @override
  _AlarmState createState() => _AlarmState();
  static void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }
}

class _AlarmState extends State<Alarm> {
  late CountdownTimerController controller;

  @override
  void initState() {
    super.initState();
    initializeReminders();
    controller = CountdownTimerController(endTime: widget.endTime, onEnd: ring);
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
              'Your next reminder: ${DateFormat('j').format(Alarm.reminders[0])}',
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
      if (DateTime.now().hour > key && !value) {
        value = !value;
      }
      if (!value) {
        Alarm.reminders.add(DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, key, 18));
      }
    });
    widget.endTime = DateTime.now().millisecondsSinceEpoch +
        DateTime.now().difference(Alarm.reminders[0]).inMilliseconds.abs();
  }
}

void ring() async {
  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloAlarmID, Alarm.printHello);
}
