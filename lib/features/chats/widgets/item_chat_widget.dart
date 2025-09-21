import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:guff/features/chats/chat_view_screen.dart';
import 'package:guff/models/models.dart';
import 'package:guff/features/screens.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../theme/theme_app.dart';

class ItemChatWidget extends StatelessWidget {
  RecordModel data;

  ItemChatWidget({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final String timeString = data.get<String>('updated').substring(0, 2);
    final int stringToNumber = int.parse(timeString);
    final String pmOram = stringToNumber > 12 ? " p.m." : " a.m.";
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatViewScreen2(recordModel: data);
            },
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: ThemeApp.grayPale,
        backgroundImage: NetworkImage(
          "https://images.pexels.com/photos/11298964/pexels-photo-11298964.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load",
        ),
        radius: 22,
      ),

      title: Text(data.get<String>('name'), style: const TextStyle(fontWeight: FontWeight.w500)),

      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${data.get<String>('updated')}$pmOram",
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, color: ThemeApp.gray),
          ),
        ],
      ),
    );
  }
}
