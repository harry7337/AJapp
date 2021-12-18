import 'package:flutter/material.dart';
import 'package:aj_app/screen/authenticate/signin.dart';
import './register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn
          ? SignIn(
              toggleViewParameter: toggleView,
            )
          : Register(
              toggleViewParameter: toggleView,
            ),
    );
  }
}
