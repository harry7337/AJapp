import 'dart:async';
import 'dart:io';

import 'package:aj_app/services/alarm_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

final firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;
final firebase_storage.Reference initialRef =
    firebase_storage.FirebaseStorage.instance.ref('jaw_movement_videos');
final firestore = FirebaseFirestore.instance;

class UploadVideo {
  final String datePath;
  final String timePath;
  final String userPath;
  late firebase_storage.Reference ref;

  UploadVideo({
    required this.timePath,
    required this.datePath,
    required this.userPath,
  }) {
    this.ref = initialRef
        .child(this.datePath)
        .child(this.timePath)
        .child(this.userPath);
  }

  Future<bool> uploadFile(File videoFile) async {
    bool success = true;
    try {
      await ref
          .child('video_' + this.userPath + '_' + this.timePath)
          .putFile(videoFile);
    } on firebase_core.FirebaseException catch (e) {
      success = false;
      // e.g, e.code == 'canceled'
      print(e);
    } finally {
      print("Reached the end of upload method");
    }
    return success;
  }
}
