import 'package:huegahsample/screen/appointments/appointment.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(_today.year + 1, 12, 31),
          onDateChanged: (DateTime) {}),
    );
  }
}
