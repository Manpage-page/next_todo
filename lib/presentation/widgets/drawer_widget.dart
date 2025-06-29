import 'package:flutter/material.dart';

//Drawerの中身
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('メニュー', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
