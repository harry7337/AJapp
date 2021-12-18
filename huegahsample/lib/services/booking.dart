import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:huegahsample/screen/appointments/current_appointments.dart';

class Booking {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool bookingStatus = false;

  void confirmBooking(String slot, String user_id, DateTime selectedDate,
      DateTime start_time, DateTime end_time, BuildContext context) {
    book(slot, user_id, selectedDate, start_time, end_time, context);
  }

  Future<void> book(String slot, String user_id, DateTime selectedDate,
      DateTime start_time, DateTime end_time, BuildContext context) {
    final DocumentReference available_slots = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments')
        .doc('available_slots');
    final DocumentReference bookings = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments')
        .doc('bookings');

    //Without Transaction
    /*
    return bookings.update(
      {
        '${DateFormat.yMMMd().format(selectedDate)}.$slot': {
              'start_time': start_time,
              'end_time': end_time,
              'user:id': user_id
            },
      },
    ).then(
      (value) {
        //Set booking status in firebase as 'booked'
        available_slots.update(
          {
            ''${DateFormat.yMMMd().format(selectedDate)}.$slot.booking_status':
                'booked!'
          },
        ).catchError((error) => print("Error $error"));

        //Show toast message to the user confirming the booking
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking Confirmed!"),
          ),
        );

        //Navigate to current bookings screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentBookings(),
          ),
        );
      },
    ).catchError((error) {
      print("Failed to add user. Error: ${error.toString()}");
    });
    */

    //With Transaction
    return firestore.runTransaction(
      (transaction) async {
        // Get the document
        final CollectionReference appointments = firestore
            .collection('event_1')
            .doc('hourly')
            .collection('appointments');

        //Update on bookings
        transaction.update(
          bookings,
          {
            '${DateFormat.yMMMd().format(selectedDate)}.$slot': {
              'start_time': start_time,
              'end_time': end_time,
              'user_id': user_id
            },
          },
        );

        // Perform an update on the available_slots
        transaction.update(
          available_slots,
          {
            '${DateFormat.yMMMd().format(selectedDate)}.$slot.booking_status':
                true
          },
        );

        // Return the new count
        return appointments;
      },
    ).then(
      (value) {
        //Show toast message to the user confirming the booking
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking Confirmed!"),
          ),
        );

        //Navigate to current bookings screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CurrentBookings(),
          ),
        );
      },
    ).catchError((error) => print("Failed: $error"));
  }
}
