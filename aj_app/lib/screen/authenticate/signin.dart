import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:aj_app/screen/authenticate/phone_signin.dart';
import 'package:aj_app/services/auth.dart';
import 'package:aj_app/shared/constants.dart';
import 'package:aj_app/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleViewParameter;
  const SignIn({required this.toggleViewParameter});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _errorController = TextEditingController();
  bool showPhoneSignInButton = true;
  bool loading = false;
  dynamic result;
  void loginFunction() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      result = await _auth.signInWithEmailAndPassword(
          _emailController.text, _passController.text);
      if (result == null) {
        setState(() {
          loading = false;
          _errorController.text = 'Could Not Sign In Those Credentials';
        });
      } else {
        setState(() {
          loading = false;
          print("Signed in!");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome"),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Sign In to AJ'),
              centerTitle: true,
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      //Email Field
                      TextFormField(
                        decoration: textInputDecoration,
                        controller: _emailController,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Password Field
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val!.length < 6
                            ? 'Enter a password longer than 6 characters'
                            : null,
                        obscureText: true,
                        controller: _passController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Sign In Button
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: loginFunction,
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      //Error text
                      TextField(
                        controller: _errorController,
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      Divider(),
                      //Dont have an acc?
                      Row(
                        children: [
                          Text('Don\'t have an account?'),
                          TextButton(
                            onPressed: () {
                              widget.toggleViewParameter();
                            },
                            child: Text('Sign Up'),
                          ),
                        ],
                      ),

                      //Phone Sign In
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhoneSignIn(),
                          ),
                        ),
                        child: Text('Sign In with Phone'),
                      ),
                      //Google Sign In
                      SignInButton(
                        Buttons.Google,
                        text: "Sign In with Google",
                        onPressed: () => AuthService().signInWithGoogle(),
                      )
                    ],
                  )),
            ),
          );
  }
}
