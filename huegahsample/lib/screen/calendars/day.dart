import 'package:flutter/material.dart';

class TimeBooking extends StatefulWidget {
  @override
  _TimeBookingState createState() => _TimeBookingState();
}

class _TimeBookingState extends State<TimeBooking> {
  static const htime = [
    '8 am',
    '9 am',
    '10 am',
    '11 am',
    '12 pm',
    '1 pm',
    '2 pm',
    '3 pm',
    '4 pm',
    '5 pm',
    '6 pm',
    '7 pm',
    '8 pm'
  ];
  var selected_startTime;
  var selected_endTime;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            DropdownButton<String>(
              hint: Text('Please Choose the Start Time'),
              value: selected_startTime,
              items: htime.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(
                  () {
                    selected_startTime = value;
                  },
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            new DropdownButton<String>(
              hint: Text('Please Choose the End  Time'),
              value: selected_endTime,
              items: htime.map((time) {
                return new DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(
                  () {
                    selected_endTime = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
