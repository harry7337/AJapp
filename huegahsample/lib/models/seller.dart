import 'package:flutter/material.dart';
import 'package:huegahsample/models/person.dart';

import 'buyer.dart';

class Seller extends Person {
  final String _enterpriceName;
  final String _address;
  String bio;
  List<String> productGenre;
  Map<String, Image> productPictures;
  List<Buyer> followers;

  Seller(
    String name,
    String phNo,
    String email,
    String userName,
    this._enterpriceName,
    this._address, {
    this.bio,
  }) : super(name, phNo, email, userName);

  String getAddress() {
    return this._address;
  }

  List<Buyer> getFollowers() {
    return this.followers;
  }

  int getFollowerCount() {
    return this.followers.length;
  }
}
