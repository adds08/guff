import 'package:flutter/material.dart';

import '../theme/theme_app.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ListTile(
            leading: CircleAvatar(radius: 25.0, child: Text("AS")),
            title: Text("My status"),
            subtitle: Text("Tab to add status update"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Recent updates",
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: ThemeApp.gray),
            ),
          ),
        ],
      ),
    );
  }
}
