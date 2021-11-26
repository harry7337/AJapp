import 'package:flutter/material.dart';
import 'package:huegahsample/screen/appointments/appointment.dart';

class Event3 extends StatelessWidget {
  final String userId;
  Event3({this.userId});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'This is Event 3',
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
