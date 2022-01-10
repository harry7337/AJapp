import 'dart:io';

import 'package:aj_app/screen/congrats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aj_app/screen/account_info/account_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '/shared/loading.dart';

import '/screen/wrapper.dart';
import '/services/auth.dart';
import '../../services/alarm_page.dart';
import '/services/update_doc.dart';

final userPath = FirebaseAuth.instance.currentUser!.uid;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();

  final today = DateTime.now();
  final firestore = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;
  final phoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  final userUID = FirebaseAuth.instance.currentUser!.uid;
  final _picker = ImagePicker();
  File? videoFile;
  int count = 0;
  VideoPlayerController? videoPlayerController;
  // late String videoPath;

  bool loading = false;
  dynamic result;
  bool _enable = false;

  @override
  void initState() {
    super.initState();
  }

  Widget drawerWidget() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Drawer Head
          drawerHead(),

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
    );
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
      videoFile = new File(recordedVideo.path);
      setState(() {
        _enableUpload();
      });
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
          onPressed: () {
            videoPlayerController!.dispose().then((_) {
              Navigator.pop(context);
              videoPlayerController = null;
              _onImageButtonPressed(ImageSource.camera);
            });
          },
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
              drawer: drawerWidget(),
              body: Container(
                margin: const EdgeInsets.all(200),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 110,
                        child: AlarmPage(),
                      ),
                    ),
                    if (videoPlayerController != null)
                      Container(
                        height: 600,
                        child: Column(
                          children: [
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
                                              aspectRatio:
                                                  videoPlayerController!
                                                      .value.aspectRatio,
                                              child: VideoPlayer(
                                                  videoPlayerController!))
                                          : Container())
                                      : const Text('')),
                            ),

                            //upload button
                            IconButton(
                              onPressed: _enable ? _upload : null,
                              icon: const Icon(Icons.upload),
                              iconSize: 30,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
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
                  FloatingActionButtonLocation.centerFloat,
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

  void _upload() async {
    final datePath = DateFormat.yMMMMd('en_US').format(DateTime.now());
    final timePath = DateFormat.j().format(DateTime.now().add(nextReminder!));
    final _upDoc =
        UpdateDoc(timePath: timePath, datePath: datePath, userPath: userPath);

    await _upDoc.updateDoc(videoFile!).then((value) {
      AlarmPage.onUploadSucess();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UploadFinish(),
        ),
      );
    });
  }

  void _enableUpload() async {
    var time = await getTime();
    time.forEach((element) {
      var reminder = element.keys.first;
      var isCompleted = element.values.first;
      if (DateTime.now().isAfter(reminder) &&
          DateTime.now().isBefore(reminder.add(timeout))) {
        setState(() {
          _enable = isCompleted;
        });
      }
    });
  }
}
