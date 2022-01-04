import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screen/account_info/account_info.dart';
import '/screen/wrapper.dart';
import '/shared/loading.dart';

import '/services/alarm.dart';
import '/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  //.millisecondsSinceEpoch + 1000 * 5;
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
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
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Positioned(
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

  Widget body() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Alarm(),
      ]),
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
                title: const Text('AJ Hospital'),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 5,
              ),
              drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Drawer Head
                    drawerHead(),

                    //Bookings
                    ListTile(
                        title: const Text(
                          'Bookings',
                        ),
                        leading: const Icon(Icons.assignment_sharp),
                        onTap: () {}),
                    //Contact us
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.contact_support_outlined,
                      ),
                      title: const Text('Contact Us'),
                    ),
                    //Account Info
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AccountInfo(),
                        ),
                      ),
                      leading: const Icon(
                        Icons.account_circle_sharp,
                      ),
                      title: const Text('Account'),
                    ),
                    //About Us
                    ListTile(
                      onTap: () {},
                      leading: const Icon(
                        Icons.info_outline,
                      ),
                      title: const Text('About Us'),
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
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                // ignore: deprecated_member_use
                backgroundColor: Theme.of(context).accentColor,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
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
              body: body(),
            ),
          );
  }
}
