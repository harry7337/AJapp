import 'package:flutter/material.dart';

class BookingConfirmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Text(
            'Congrats Booking Confirmed!!',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
