import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UpdateDoc {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateDoc(DateTime selectedDate) {
    final appointments = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments');

    return appointments.doc('available_slots').update(
      {
        '${DateFormat.yMMMd().format(selectedDate)}': {
          'slot_1': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  9, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  10, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_2': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  10, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  11, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_3': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  11, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  12, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_4': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  12, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  13, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_5': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  13, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  14, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_6': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  14, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  15, 0, 0),
            ),
            'booking_status': false,
          },
          
          'slot_7': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  15, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  16, 0, 0),
            ),
            'booking_status': false,
          },
        },
      },
    );
  }
}
