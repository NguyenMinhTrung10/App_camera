import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Picture Detail')),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
          Text('Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}'),
        ],
      ),
    );
  }
}
