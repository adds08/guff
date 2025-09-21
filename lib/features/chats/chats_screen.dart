import 'package:flutter/material.dart';
import 'package:guff/db.dart';
import 'package:guff/widgets/widgets.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  Future<List<RecordModel>> getUsers() async {
    final records = await pocketDB.collection('groups').getFullList(expand: "members", sort: '-updated');
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUsers(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.done) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error: ${asyncSnapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: asyncSnapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemChatWidget(data: asyncSnapshot.data![index]);
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
