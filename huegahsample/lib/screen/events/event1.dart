import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:huegahsample/screen/slots/hourly_slots.dart';
import 'package:huegahsample/services/update_doc.dart';
import 'package:intl/intl.dart';

class Event1 extends StatefulWidget {
  @override
  _Event1State createState() => _Event1State();
}

class _Event1State extends State<Event1> {
  final today = DateTime.now();
  var selectedDate;
  bool dataAvailable = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final appointments = firestore
        .collection('event_1')
        .doc('hourly')
        .collection('appointments');
    return ListView(
      children: [
        FormBuilder(
          child: Column(
            children: [
              //Select date
              FormBuilderDateTimePicker(
                name: 'date',
                inputType: InputType.date,
                firstDate: today,
                initialDate: today,
                decoration: InputDecoration(
                  hintText: 'Pick a date',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.calendar_today_sharp),
                ),
                onChanged: (DateTime date) {
                  selectedDate = date;
                },
              ),

              //Search for slots
              ElevatedButton(
                child: Text(
                  'Search',
                ),
                onPressed: () {
                  setState(
                    () {
                      if (selectedDate != null) {
                        //Query if the selected date is already listed in the database
                        appointments.doc('available_slots').get().then(
                          (DocumentSnapshot docSnapshot) async {
                            Map<String, dynamic> data = docSnapshot.data()[
                                '${DateFormat.yMMMd().format(selectedDate)}'];
                            if (data != null) {
                              dataAvailable = true;
                              print("data is available");
                            } else {
                              //If not upload a new map of the selected date
                              await UpdateDoc().updateDoc(selectedDate);
                              print("Doc is updated");
                              dataAvailable = true;
                            }
                          },
                        );
                      }
                    },
                  );
                },
              ),
              if (dataAvailable == false)
                Text('Pick a Date')
              else
                HourlySlots(selectedDate)
            ],
          ),
        ),
      ],
    );
  }
}
