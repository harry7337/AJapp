import 'dart:io';

import 'package:aj_app/services/upload_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UpdateDoc {
  static final userDoc = FirebaseFirestore.instance
      .collection('jaw_movements')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final String timePath;
  final String datePath;
  final String userPath;
  late UploadVideo upVid;

  UpdateDoc({
    required this.timePath,
    required this.datePath,
    required this.userPath,
  }) {
    this.upVid = new UploadVideo(
        timePath: timePath, datePath: datePath, userPath: userPath);
  }

  Future<void> updateDoc(File videoFile) async {
    final videoPath = userPath + '_' + timePath;
    Map<String, Object> updatedValue = {};
    updatedValue['video_paths.${datePath}.${timePath}'] = videoPath;
    this
        .upVid
        .uploadFile(videoFile)
        .whenComplete(() => userDoc.update(updatedValue));
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getUploadedStatusFromDatabase() {
    return userDoc.get();
  }

  static Future<List> getReminders() async {
    final now = DateTime.now();
    var times = await FirebaseFirestore.instance
        .collection('jaw_movements')
        .doc('reminders')
        .get();
    List reminders = times.data()!['times'];
    List<Map<DateTime, bool>> finalList = [];
    reminders.forEach((element) {
      Timestamp timestamp = element;
      finalList.add({
        DateTime(
            now.year,
            now.month,
            now.day,
            DateTime.fromMillisecondsSinceEpoch(
                    timestamp.millisecondsSinceEpoch)
                .hour,
            DateTime.fromMillisecondsSinceEpoch(
                    timestamp.millisecondsSinceEpoch)
                .minute): false
      });
    });
    return finalList;
  }
}
