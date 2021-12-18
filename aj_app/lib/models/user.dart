import 'package:flutter/material.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String photoURL;

  User(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.photoURL});
  //User({this.uid, this.name, this.photoURL});
}
