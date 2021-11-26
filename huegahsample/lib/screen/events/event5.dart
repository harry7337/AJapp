import 'package:flutter/material.dart';
import 'package:huegahsample/screen/appointments/appointment.dart';

class Event5 extends StatelessWidget {
  final String userId;
  Event5({this.userId});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'This is Event 5',
          //textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (context) => Appointments(userId),
              ),
            );
          },
          child: Text('Book Now'),
        ),
      ],
    );
  }
}
