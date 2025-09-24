import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/db.dart';
import 'package:guff/widgets/widgets.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenToFCM();
  }

  void listenToFCM() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.title ?? 'No Title'),
          duration: const Duration(seconds: 2),
        ),
      );
    });

    // When tapping notification opens app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('App opened via notification: ${message.notification?.title}');
    });
  }

  Future<List<RecordModel>> getUsers() async {
    final records = await ref
        .watch(pocketbaseProvider)
        .collection('groups')
        .getFullList(
          filter: "members~'${ref.watch(pocketbaseProvider).authStore.record!.id}'",
          expand: "members,createdBy",
          sort: '-updated',
        );
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
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const BouncingScrollPhysics(),
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 12, endIndent: 12),

                  itemCount: asyncSnapshot.data!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= asyncSnapshot.data!.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemChatWidget(data: asyncSnapshot.data![index]),
                    );
                  },
                ),
              ),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
