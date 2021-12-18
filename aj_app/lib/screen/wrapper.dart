import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen/authenticate/login_screen.dart';
import '../screen/home/home.dart';
import '../services/auth.dart';
import '../shared/loading.dart';

class Wrapper extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              print("Not Null");
              _auth.userPrivileges(snapshot.data as User);

              return Home();
            } else {
              print("Null User");
              return Authenticate();
            }
          }
          //snapshot.connectionState==ConnectionState.waiting
          return Loading();
        });

    // if (_auth.checkAuth() != null) {
    //   // _auth.userPrivileges(authUser);
    //   return Home();
    // } else {
    //   return Authenticate();
    // }
  }
}
