import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huegahsample/models/book.dart';
import 'package:huegahsample/shared/loading.dart';
import 'package:intl/intl.dart';

class CurrentBookings extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final appointments = [];
  bool status = false;
  @override
  Widget build(BuildContext context) {
    //This is a nested document list
    //The heirarchy is:
    //event_1(collection) -> hourly,bihourly,trihourly,quadhourly(documents);
    //hourly(documents)-> appointments(collections)-> available slots,bookings(documents);
    //available slots(documents)->slot_1,slot_2...(fields)
    final DocumentReference bookings = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments')
        .doc('bookings');

    return FutureBuilder<DocumentSnapshot>(
      future: bookings.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          snapshot.data.data().forEach(
            (date, slots) {
              slots.forEach(
                (k, v) {
                  if (v['user_id'] == FirebaseAuth.instance.currentUser.email) {
                    Book bk = Book(
                        start_time: v['start_time'].toDate(),
                        end_time: v['end_time'].toDate(),
                        id: v['user_id'],
                        slot: k);
                    appointments.add(bk);
                  }
                },
              );
            },
          );
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.brown[500],
            ),
            body: Column(
              children: appointments.map((bookings) {
                return Text(
                  "Your booked slot is from: " +
                      DateFormat.Hm().format(bookings.start_time) +
                      " to: " +
                      DateFormat.Hm().format(bookings.end_time) +
                      " on: " +
                      DateFormat.yMMMd().format(bookings.start_time) +
                      "\n",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }).toList(),
            ),
          );
        }
        return Loading();
      },
    );
  }
}
