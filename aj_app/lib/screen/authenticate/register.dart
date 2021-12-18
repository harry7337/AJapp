import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:aj_app/screen/authenticate/phone_signin.dart';
import 'package:aj_app/services/auth.dart';
import 'package:aj_app/shared/constants.dart';
import 'package:aj_app/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleViewParameter;
  const Register({required this.toggleViewParameter});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _errorController = TextEditingController();
  bool loading = false;
  dynamic result;

  void register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      result = await _auth.registerWithEmailAndPassword(
          _emailController.text, _passController.text);
      if (result == null) {
        setState(() {
          _errorController.text = 'Please enter a valid email';
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => Wrapper(),
          //   ),
          // );
          print("Signed in!");
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
              elevation: 10,
              title: Text('Sign Up to AJ'),
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
                      TextFormField(
                        decoration: textInputDecoration,
                        controller: _emailController,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        // onChanged: (val) {
                        //   setState(() {
                        //     email = val;
                        //   });
                        // },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        controller: _passController,
                        validator: (val) => val!.length < 6
                            ? 'Enter a password longer than 6 characters'
                            : null,
                        // onChanged: (val) {
                        //   setState(() {
                        //     pass = val;
                        //   });
                        // },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: register,
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: _errorController,
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('\tHave an account?'),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextButton(
                              onPressed: () {
                                widget.toggleViewParameter();
                              },
                              child: Text('Sign In'),
                            ),
                          ),
                        ],
                      ),
                      //Phone Sign Up
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhoneSignIn(),
                          ),
                        ),
                        child: Text('Sign Up with Phone'),
                      ),
                      //Google Sign In
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () => AuthService().signInWithGoogle(),
                      )
                    ],
                  )),
            ),
          );
  }
}
