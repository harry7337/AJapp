import 'package:flutter/material.dart';

class UploadFinish extends StatelessWidget {
  const UploadFinish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AJ Hospital'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 20,
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Text(
            'Congrats! The video has been uploaded. You can now wait until your next reminder',
            style: TextStyle(fontSize: 30, color: Colors.green),
          ),
        ),
      ),
    );
  }
}
