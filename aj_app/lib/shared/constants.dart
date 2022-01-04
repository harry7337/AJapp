import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.greenAccent,
      width: 2,
    ),
  ),
);
const phoneInputDecoration = InputDecoration(
  hintText: 'Phone Number',
  prefixText: '+91',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.zero),
    borderSide: BorderSide(
      color: Colors.teal,
      width: 2,
    ),
  ),
);
