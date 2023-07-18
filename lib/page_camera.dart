import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'display_picture_screen.dart';

class Pagecamera extends StatefulWidget {
  const Pagecamera({super.key});

  @override
  State<Pagecamera> createState() => _PagecameraState();
}

class _PagecameraState extends State<Pagecamera> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;

  void takePicture() async {
    try {
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.png',
      );

      await _controller!.takePicture();

      Navigator.push(
        BuildContext as BuildContext,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      if (cameras!.length > 0) {
        _controller = CameraController(cameras![0], ResolutionPreset.medium);
        _initializeControllerFuture = _controller!.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: takePicture,
      ),
    );
  }
}
