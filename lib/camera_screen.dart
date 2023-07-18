import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/page_camera.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chụp ảnh'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Color(0xFF0071E3)),
                onPressed: () {},
                child: Text(
                  'Chọn ảnh từ thiết bị',
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Color(0xFF0071E3)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Pagecamera()));
                },
                child: Text(
                  'Chụp ảnh',
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
