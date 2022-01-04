import 'package:flutter/material.dart';

class Event2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Available Slots",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Container(
        child: Text('Under dev'),
      ),
    ]);
    /*Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'This is Event 2',
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
    */
  }
}
