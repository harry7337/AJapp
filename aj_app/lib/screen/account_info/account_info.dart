import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aj_app/screen/account_info/profile_picture.dart';
import '/models/user.dart';

class AccountInfo extends StatelessWidget {
  final firebaseUser = FirebaseAuth.instance.currentUser;

  AccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.cyanAccent[100],
      ),
      backgroundColor: Colors.cyanAccent[100],
      body: ListView(
        children: [
          ProfilePicture(imagePath: firebaseUser!.photoURL!),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              firebaseUser!.displayName!,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              firebaseUser!.email!,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
          Card(
            color: Colors.cyanAccent[100],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //name
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: firebaseUser!.displayName,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.ac_unit_sharp),
                          ),
                        ),
                      ),
                    ),

                    //contact number
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: firebaseUser!.phoneNumber,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Contact Number',
                              prefixIcon: Icon(Icons.phone)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
