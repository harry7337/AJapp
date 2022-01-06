import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aj_app/screen/account_info/account_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '/shared/loading.dart';

import '/screen/wrapper.dart';
import '/services/auth.dart';
import '/services/alarm.dart';

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
  final ImagePicker _picker = ImagePicker();
  int count = 0;
  VideoPlayerController? videoPlayerController;
  // late String videoPath;

  bool loading = false;
  dynamic result;
  bool admin = false;

  @override
  void initState() {
    super.initState();
  }

  //record video methos
  void _onImageButtonPressed(ImageSource source) async {
    final XFile? recordedVideo = (await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 20),
        preferredCameraDevice: CameraDevice.front));
    if (recordedVideo != null && recordedVideo.path != null) {
      // _pickVideo = recordedVideo;
      // videoPath = recordedVideo.path;

      videoPlayerController =
          VideoPlayerController.file(File(recordedVideo.path))
            ..initialize().then((_) {
              setState(() {});
              videoPlayerController!.play(); //.pause() for pausing
              videoPlayerController!.setVolume(0.0);
            });

      setState(() {});
    }
  }

  //alert dialog when retaking a video
  Widget _confirmRetakeDialog() {
    return AlertDialog(
      title: const Text('Are you sure you want to retake this video?'),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        // ignore: deprecated_member_use
        FlatButton(
          onPressed: () => videoPlayerController!
              .dispose()
              .then((_) => Navigator.pop(context)),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  //app drawer
  Widget drawerHead() {
    return DrawerHeader(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: const [
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
                title: const Text('AJ Hospital'),
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
              body: 
                   Container(
                      margin: const EdgeInsets.all(200),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: Column(
                        children: [
                          Center(
                          child: Alarm(),
                          ),
                          if(videoPlayerController != null)
                          Column(
                          children:[
                          //video player screen view
                          GestureDetector(
                            onTap: () {
                              count++;
                              pauseAndPlay(count);
                            },
                            child: Container(
                                height: 500,
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                child: (videoPlayerController != null)
                                    ? (videoPlayerController!
                                            .value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio: videoPlayerController!
                                                .value.aspectRatio,
                                            child: VideoPlayer(
                                                videoPlayerController!))
                                        : Container())
                                    : const Text('')),
                          ),

                          //upload button
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.upload),
                          )
                          ],
                          ),
                        ],
                      ),),
                  
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  videoPlayerController == null
                      ? _onImageButtonPressed(ImageSource.camera)
                      : showDialog(
                          context: context,
                          builder: (_) => _confirmRetakeDialog());
                },
                heroTag: 'video1',
                tooltip: 'Take a Video',
                child: const Icon(Icons.videocam),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          );
  }

  //controls pause and play for video
  void pauseAndPlay(int count) {
    if (count % 2 != 0) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }
}
