import 'package:cloud_firestore/cloud_firestore.dart';

class Cancellation {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> cancel(
      String slot, String user_id, DateTime start_time, DateTime end_time) {
    final CollectionReference event_1 = firestore.collection('event_1');
    final DocumentReference hourly = event_1.doc('hourly');
    final CollectionReference appointments = hourly.collection('appointments');
    final DocumentReference available_slots =
        appointments.doc('available_slots');
    final DocumentReference bookings = appointments.doc('bookings');

    available_slots.update(
      {
        '$slot': {
          {'start_time': start_time},
          {'end_time': end_time},
        },
      },
    );
    return bookings.update({'$slot': FieldValue.delete()});
  }
}
