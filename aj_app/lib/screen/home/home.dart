import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aj_app/screen/account_info/account_info.dart';

import '/shared/loading.dart';

import '/screen/wrapper.dart';
import '/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DateTime today = DateTime.now();
  final firestore = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;
  final phoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  final userUID = FirebaseAuth.instance.currentUser!.uid;
  bool loading = false;
  dynamic result;
  bool admin = false;

  @override
  void initState() {
    super.initState();
  }

  Widget drawerHead() {
    return DrawerHeader(
      margin: EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Positioned(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            bottom: 1.0,
            left: 0.5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                title: Text('AJ Hospital'),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 20,
              ),
              drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Drawer Head
                    drawerHead(),

                    //Bookings
                    ListTile(
                        title: Text(
                          'Bookings',
                        ),
                        leading: Icon(Icons.assignment_sharp),
                        onTap: () {}),
                    //Contact us
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.contact_support_outlined,
                      ),
                      title: Text('Contact Us'),
                    ),
                    //Account Info
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AccountInfo(),
                        ),
                      ),
                      leading: Icon(
                        Icons.account_circle_sharp,
                      ),
                      title: Text('Account'),
                    ),
                    //About Us
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.info_outline,
                      ),
                      title: Text('About Us'),
                    ),
                    //Logout
                    ListTile(
                      onTap: () async {
                        await _auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Wrapper(),
                          ),
                          (route) => false,
                        );
                      },
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      'Events',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          );
  }
}
