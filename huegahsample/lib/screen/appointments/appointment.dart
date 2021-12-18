import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:huegahsample/screen/calendars/calendar.dart';
import 'package:intl/intl.dart';
import 'package:huegahsample/services/event_firestore.dart';

class Appointments extends StatefulWidget {
  final String userId;

  Appointments(this.userId);
  @override
  _AppointmentsState createState() => _AppointmentsState(userId: userId);
}

class _AppointmentsState extends State<Appointments> {
  double hours = 1;
  final List<String> events = [
    'Event 1',
    'Event 2',
    'Event 3',
    'Event 4',
    'Event 5'
  ];
  final _formKey = GlobalKey<FormBuilderState>();
  final String userId;
  _AppointmentsState({this.userId});

  DateTime dateTime = DateTime.now(), selectedDate = DateTime.now();
  DateTime selectedStartTime;
  DateTime selectedEndTime;

  DateTime updatedTime(DateTime input, DateTime date) {
    input = DateTime(input.year, input.month, input.day, date.hour);
    return input;
  }

  void saveFunction() async {
    bool validated = _formKey.currentState.validate();
    print(
      "Validation is:$validated",
    );

    _formKey.currentState.save();
    if (validated) {
      final data = Map<String, dynamic>.from(_formKey.currentState.value);
      //data["date"] = (data["date"] as DateTime)
      // This is tweaking with the data a lil, as it could not be done in the FormBuilder Objects
      data.update('start_time', (value) => value = this.selectedStartTime);
      data.update('end_time', (value) => value = this.selectedEndTime);
      data.update('start_date', (value) => value = this.selectedDate);
      //print(data);

      Map<String, dynamic> fdata = {};

      data.forEach((key, value) {
        fdata[key] = value;
      });
      fdata.remove('start_date');

      print(fdata);
      //create
      await eventDBS.create(fdata);
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //CLEAR Button
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        //Save Button
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: saveFunction,
              child: Text('Save'),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                //Pick START Date
                FormBuilderDateTimePicker(
                  name: "start_date",
                  firstDate: DateTime.now(),
                  format: DateFormat('EEEE, dd MMMM,yyyy'),
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    hintText: 'Pick a date',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                  onChanged: (DateTime selectedDate) {
                    setState(() {
                      this.selectedDate = selectedDate ?? DateTime.now();
                    });
                  },
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                    ],
                  ),
                ),
                Divider(),
                //Pick START Time
                FormBuilderDateTimePicker(
                  name: "start_time",
                  initialDate: this.selectedDate,
                  firstDate: this.selectedDate,
                  initialTime: TimeOfDay(hour: 8, minute: 0),
                  alwaysUse24HourFormat: true,
                  inputType: InputType.time,
                  decoration: InputDecoration(
                    hintText: 'Pick Start Time',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.access_alarm_outlined),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                    ],
                  ),
                  onChanged: (DateTime selectedStartTime) {
                    setState(() {
                      this.selectedStartTime = selectedStartTime;
                      this.selectedStartTime = updatedTime(
                        this.selectedDate,
                        this.selectedStartTime,
                      );
                      this.selectedDate = updatedTime(
                          this.selectedDate, this.selectedStartTime);
                    });
                  },
                ),

                Divider(),
                //Pick EVENT
                new FormBuilderDropdown(
                  name: "Event",
                  //initialValue: _selectedEvent,
                  hint: Text('Select Event'),
                  items: events.map(
                    (event) {
                      return DropdownMenuItem(
                        value: event,
                        child: new Text(event),
                      );
                    },
                  ).toList(),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                    ],
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.account_tree_outlined),
                  ),
                ),

                Divider(),
                //Pick End Time
                FormBuilderDateTimePicker(
                  name: "end_time",
                  initialDate: this.selectedDate,
                  firstDate: this.selectedDate,
                  fieldHintText: "Add Date",
                  inputType: InputType.time,
                  alwaysUse24HourFormat: true,
                  decoration: InputDecoration(
                    hintText: 'Pick End Time',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.access_alarm_outlined),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                    ],
                  ),
                  onChanged: (DateTime selectedEndTime) {
                    setState(() {
                      this.selectedEndTime = selectedEndTime;
                      this.selectedEndTime = updatedTime(
                        this.selectedDate,
                        this.selectedEndTime,
                      );
                      selectedEndTime = updatedTime(
                        this.selectedDate,
                        this.selectedEndTime,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          //Calendar
          SizedBox(
            height: 400,
            width: 400,
            child: Calendar(),
          ),
        ],
      ),
    );
  }
}
