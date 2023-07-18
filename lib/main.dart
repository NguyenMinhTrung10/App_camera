import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/camera_screen.dart';
import 'package:flutter_application_1/screen/camera_screen_image.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CameraApp());
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: CameraPreview(_controller),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: MaterialButton(
                      //  color: Colors.white,
                      onPressed: () async {
                        if (!_controller.value.isInitialized) {
                          return null;
                        }
                        if (_controller.value.isTakingPicture) {
                          return null;
                        }

                        try {
                          await _controller.setFlashMode(FlashMode.auto);
                          XFile file = await _controller.takePicture();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ImagePreview(file: file)));
                        } on CameraException catch (e) {
                          debugPrint("Error occured while taking picture :$e");
                          return null;
                        }
                      },
                      child: Image.asset(
                        'assets/images/Shootbutton.png',
                        width: 84,
                        fit: BoxFit.cover,
                      )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
