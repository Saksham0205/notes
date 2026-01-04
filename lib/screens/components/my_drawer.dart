import 'package:flutter/material.dart';
import 'package:notes/screens/settings_screen.dart';
import 'drawer_title.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //header
          DrawerHeader(child: Icon(Icons.note)),

          //notes title
          DrawerTitle(
            title: "Notes",
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerTitle(
            title: "Settings",
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsScreen()));
              
            },
          ),
          //settings title
        ],
      ),
    );
  }
}

