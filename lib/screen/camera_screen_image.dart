import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class ImagePreview extends StatefulWidget {
  ImagePreview({super.key, required this.file});

  XFile file;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  // Future<void> _aaaa() async {
  //   final bytes =
  //       await rootBundle.load('assets/images/BongGioDisplayRegular.ttf.zip');
  //   final font = img.BitmapFont.fromZip(bytes.buffer.asUint8List());
  //   log(bytes.buffer.asUint8List().toString());
  //   final image =
  //       img.decodeImage(File('assets/images/aaaaa.jpg').readAsBytesSync())!;
  //   img.drawString(image, font, 10, 10, 'Hello world!');
  //   File('assets/images/aaaaa.jpg').writeAsBytesSync(img.encodeJpg(image));
  // }

  String _dateTime = "";
  String _location = "";
  String _lat = "";
  String _lon = "";
  String IP = "";
  String _hashedPassword = '';
  String _dateday = "";

  void initState() {
    super.initState();
    _getCurrentLocation();
    _getDateTime();
    _getHashedPassword();
    _getDate();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Position position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
      // _lat = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      await http.get(Uri.parse('http://ip-api.com/json')).then((value) {
        _location = json.decode(value.body)['regionName'].toString();
        _lat = json.decode(value.body)['lat'].toString();
        _lon = json.decode(value.body)['lon'].toString();
        IP = json.decode(value.body)['query'].toString();
      });
      setState(() {
        //String? location;

        //   _lat = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   String? location;
  //   try {
  //     await http.get(Uri.parse('http://ip-api.com/json')).then((value) {
  //       location = json.decode(value.body)['regionName'].toString();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void _getDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
    setState(() {
      _dateTime = formattedDate;
    });
  }

  void _getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    setState(() {
      _dateday = formattedDate;
    });
  }

  // Future<void> main() async {
  //   await hashPassword();
  // }

  // Future<void> _getHashedPassword() async {
  //   DateTime now = DateTime.now();
  //   String password = now.toString();
  //   String salt = await FlutterBcrypt.salt();
  //   String hashedPassword =
  //       await FlutterBcrypt.hashPw(password: password, salt: salt);
  //   setState(() {
  //     _hashedPassword = hashedPassword;
  //   });
  // }

  Future<void> _getHashedPassword() async {
    DateTime now = DateTime.now();
    String password = _dateday;
    String salt = '@&gKQsaukd';
    String hashedPassword =
        sha256.convert(utf8.encode(password + salt)).toString();
    String firstFiveChars = hashedPassword.substring(0, 5);
    String lastFiveChars = hashedPassword.substring(hashedPassword.length - 5);
    String result = '$firstFiveChars...$lastFiveChars';
    setState(() {
      _hashedPassword = result;
    });
  }

  @override
  Future<File> saveImageToGallery(File imageFile) async {
    final directory = await getExternalStorageDirectory();
    final imagePath =
        '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final newImage = await imageFile.copy(imagePath);

    return newImage;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Color(0xFF0071E3),
          //  title: Text("Image Preview"),
          ),
      body: Stack(
        children: [
          Center(
            child: Image.file(File(widget.file.path)),
          ),
          // _aaaa();

          Positioned(
            top: 5,
            left: 0,
            child: SizedBox(
                width: 189,
                height: 150,
                //  height: 200,
                child: Image.asset(
                  'assets/images/images_logodiva3.png',
                  fit: BoxFit.fill,
                )),
          ),
          Positioned(
            top: 10,
            left: 60,
            child: Text(
              "Code: $_hashedPassword",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 173, 173, 173),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont'),
            ),
          ),
          Positioned(
            top: 45,
            left: 10,
            child: Text(
              "${_dateTime}",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont'),
            ),
          ),
          Positioned(
            top: 65,
            left: 10,
            child: Text(
              "$_location",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont'),
            ),
          ),
          Positioned(
            top: 85,
            left: 10,
            child: Row(
              children: [
                Text(
                  "Location: $_lat",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Myfont'),
                ),
                Text(
                  ", $_lon",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Myfont'),
                ),
              ],
            ),
          ),

          // Positioned(
          //   top: 100,
          //   left: 10,
          //   child: Text(
          //     _lon,
          //     style: TextStyle(
          //       fontSize: 20,
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Positioned(
            top: 105,
            left: 10,
            child: Text(
              "IP: ${IP}",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Myfont'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveImage();
            //main();
          },
          child: Image.asset(
            'assets/images/savebutton.png',
            width: 84,
            fit: BoxFit.cover,
          )),
    );
  }

  void _saveImage() async {
    final ByteData logoByteData =
        await rootBundle.load('assets/images/images_logodiva3.png');
    final Uint8List logoBytes = logoByteData.buffer.asUint8List();
    final img.Image logoImage = img.decodeImage(logoBytes)!;

    final img.Image originalImage =
        img.decodeImage(File(widget.file.path).readAsBytesSync())!;

    final double logoRatio = logoImage.width / logoImage.height;
    // final int logoWidth = 770;
    // final int logoHeight = 310;
    final int logoWidth = 600;
    final int logoHeight = 420;
    final img.Image resizedLogo =
        img.copyResize(logoImage, width: logoWidth, height: logoHeight);

    final int logoX = -100;
    final int logoY = -20;
    img.drawImage(originalImage, resizedLogo, dstX: logoX, dstY: logoY);

    //final font = img.arial_48;
    // final fileZip = File("assets/images/BongGioDisplayRegular.ttf.zip");

    // final font = img.BitmapFont.fromZip(fileZip.readAsBytesSync());
    final bytes =
        await rootBundle.load('assets/images/BongGioDisplayRegular.ttf.zip');
    final font = img.BitmapFont.fromZip(bytes.buffer.asUint8List());
    // final fontZipFile =
    //     await File('assets/images/BongGioDisplayRegular.ttf.zip').readAsBytes();
    // final font = img.BitmapFont.fromZip(fontZipFile);
    // final image = img.Image(width: 320, height: 200);

    final color = img.getColor(255, 255, 255);
    final color1 = img.getColor(173, 173, 173);
    final dateText = _dateTime;
    final locationText = _location;
    final locationText1 = "Location: $_lat, $_lon";
    final locationText2 = "IP: $IP";
    final locationText3 = "Code: $_hashedPassword";
    final textPadding = 50;
    final textOffset = img.Point(textPadding, textPadding);
    final datePosition =
        img.Point(textOffset.x, textOffset.y + textPadding * 1);
    final locationPosition =
        img.Point(textOffset.x, textOffset.y + textPadding * 2);
    final locationPosition1 =
        img.Point(textOffset.x, textOffset.y + textPadding * 3);
    final locationPosition2 =
        img.Point(textOffset.x, textOffset.y + textPadding * 4);
    final locationPosition3 = img.Point(textOffset.x * 3.7, textOffset.y / 5);
    final x1 = datePosition.x.toInt();
    final y1 = datePosition.y.toInt();
    img.drawString(originalImage, font, x1, y1, dateText, color: color);
    final x2 = locationPosition.x.toInt();
    final y2 = locationPosition.y.toInt();
    final x3 = locationPosition1.x.toInt();
    final y3 = locationPosition1.y.toInt();
    final x4 = locationPosition2.x.toInt();
    final y4 = locationPosition2.y.toInt();
    final x5 = locationPosition3.x.toInt();
    final y5 = locationPosition3.y.toInt();
    img.drawString(originalImage, font, x2, y2, locationText, color: color);
    img.drawString(originalImage, font, x3, y3, locationText1, color: color);
    img.drawString(originalImage, font, x4, y4, locationText2, color: color);
    img.drawString(originalImage, font, x5, y5, locationText3, color: color1);

    // Save the modified image to the gallery
    final directory = await getExternalStorageDirectory();
    final imagePath =
        '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    File(imagePath).writeAsBytesSync(img.encodeJpg(originalImage));

    final result = await GallerySaver.saveImage(imagePath);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể lưu ảnh")),
      );
    } else if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã lưu ảnh")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không thể lưu ảnh")),
      );
    }
  }

  // void _saveImage() async {
  //   final image = img.decodeImage(File(widget.file.path).readAsBytesSync())!;

  //   final font = img.arial_48;

  //   final color = img.getColor(255, 255, 255);
  //   final dateText = _dateTime;
  //   final locationText = _location;
  //   final locationText1 = "Tọa độ: $_lat, $_lon";
  //   final locationText2 = "IP: $IP";
  //   final textPadding = 50;
  //   final textOffset = img.Point(textPadding, textPadding);
  //   final datePosition = textOffset;
  //   final locationPosition = img.Point(
  //     textOffset.x,
  //     textOffset.y + textPadding,
  //   );
  //   final locationPosition1 = img.Point(
  //     textOffset.x,
  //     textOffset.y + textPadding * 2,
  //   );
  //   final locationPosition2 = img.Point(
  //     textOffset.x,
  //     textOffset.y + textPadding * 3,
  //   );
  //   final x1 = datePosition.x.toInt();
  //   final y1 = datePosition.y.toInt();
  //   img.drawString(image, font, x1, y1, dateText, color: color);

  //   final x2 = locationPosition.x.toInt();
  //   final y2 = locationPosition.y.toInt();
  //   final x3 = locationPosition1.x.toInt();
  //   final y3 = locationPosition1.y.toInt();
  //   final x4 = locationPosition2.x.toInt();
  //   final y4 = locationPosition2.y.toInt();
  //   img.drawString(image, font, x2, y2, locationText, color: color);
  //   img.drawString(image, font, x3, y3, locationText1, color: color);
  //   img.drawString(image, font, x4, y4, locationText2, color: color);
  //   // img.drawString(image, font, datePosition, dateText, color: color);
  //   // img.drawString(image, font, locationPosition, locationText, color: color);
  //   final directory = await getExternalStorageDirectory();
  //   final imagePath =
  //       '${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   // File(imagePath).writeAsBytesSync(img.encodeJpg(image));
  //   File(imagePath).writeAsBytesSync(img.encodeJpg(image));

  //   final result = await GallerySaver.saveImage(imagePath);
  //   if (result == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save image")),
  //     );
  //   } else if (result == true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Image saved to gallery")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save image")),
  //     );
  //   }
  // }

  // void _saveImage() async {
  //   final result = await GallerySaver.saveImage(widget.file.path);
  //   if (result == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save image")),
  //     );
  //   } else if (result == true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Image saved to gallery")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save image")),
  //     );
  //   }
  // }
}
