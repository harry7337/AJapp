import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huegahsample/screen/slots/booking_confirmation.dart';
import 'package:huegahsample/services/booking.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:huegahsample/shared/loading.dart';

class HourlySlots extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DateTime today = DateTime.now();
  final DateTime selectedDate;
  final email = FirebaseAuth.instance.currentUser.email;

  HourlySlots(this.selectedDate);

  void confirmBooking(String slot, String user_id, DateTime selectedDate,
      DateTime start_time, DateTime end_time, BuildContext context) {
    Booking().book(slot, user_id, selectedDate, start_time, end_time, context);
  }

  @override
  Widget build(BuildContext context) {
    var slot_1, slot_2, slot_3, slot_4, slot_5, slot_6, slot_7, slotCollection;
    //This is a nested document list
    //The heirarchy is:
    //event_1(collection) -> hourly,bihourly,trihourly,quadhourly(documents);
    //hourly(documents)-> appointments(collections)-> available slots,bookings(documents);
    //available slots(documents)->slot_1,slot_2...(fields)
    final DocumentReference available_slots = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments')
        .doc('available_slots');

    return FutureBuilder<DocumentSnapshot>(
      future: available_slots.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          snapshot.data.data().forEach((date, slots) {
            if (date == '${DateFormat.yMMMd().format(selectedDate)}')
              slotCollection = slots;
          });

          slot_1 = slotCollection['slot_1'];
          slot_2 = slotCollection['slot_2'];
          slot_3 = slotCollection['slot_3'];
          slot_4 = slotCollection['slot_4'];
          slot_5 = slotCollection['slot_5'];
          slot_6 = slotCollection['slot_6'];
          slot_7 = slotCollection['slot_7'];

          return new Column(
            children: [
              //For Slot 1
              !slot_1['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_1',
                            email,
                            selectedDate,
                            slot_1['start_time'].toDate(),
                            slot_1['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmed(),
                          ),
                        );
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_1['start_time'].toDate())} - ${DateFormat.Hm().format(slot_1['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 2
              !slot_2['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_2',
                            email,
                            selectedDate,
                            slot_2['start_time'].toDate(),
                            slot_2['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmed(),
                          ),
                        );
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_2['start_time'].toDate())} - ${DateFormat.Hm().format(slot_2['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 3
              !slot_3['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_3',
                            email,
                            selectedDate,
                            slot_3['start_time'].toDate(),
                            slot_3['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmed(),
                          ),
                        );
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_3['start_time'].toDate())} - ${DateFormat.Hm().format(slot_3['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 4
              !slot_4['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_4',
                            email,
                            selectedDate,
                            slot_4['start_time'].toDate(),
                            slot_4['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmed(),
                            ));
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_4['start_time'].toDate())} - ${DateFormat.Hm().format(slot_4['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 5
              !slot_5['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_5',
                            email,
                            selectedDate,
                            slot_5['start_time'].toDate(),
                            slot_5['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmed(),
                            ));
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_5['start_time'].toDate())} - ${DateFormat.Hm().format(slot_5['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 6

              !slot_6['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_6',
                            email,
                            selectedDate,
                            slot_6['start_time'].toDate(),
                            slot_6['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmed(),
                          ),
                        );
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_6['start_time'].toDate())} - ${DateFormat.Hm().format(slot_6['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),

              //For Slot 7
              !slot_7['booking_status']
                  ? ElevatedButton(
                      onPressed: () {
                        confirmBooking(
                            'slot_7',
                            email,
                            selectedDate,
                            slot_7['start_time'].toDate(),
                            slot_7['end_time'].toDate(),
                            context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmed(),
                          ),
                        );
                      },
                      child: Text(
                        "${DateFormat.Hm().format(slot_7['start_time'].toDate())} - ${DateFormat.Hm().format(slot_7['end_time'].toDate())}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  : Text(''),
            ],
          );
        }
        return Loading();
      },
    );
  }
}
