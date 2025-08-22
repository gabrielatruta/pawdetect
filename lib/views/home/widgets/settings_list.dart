import 'package:flutter/material.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: const [
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Notifications"),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Privacy"),
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text("Help & Support"),
        ),
      ],
    );
  }
}
