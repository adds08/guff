import 'package:flutter/material.dart';
import 'package:guff/db.dart';
import 'package:guff/features/screens.dart';
import 'package:guff/screen/create_group_screen.dart';
import 'package:guff/screen/status_screen.dart';
import 'package:guff/theme/theme_app.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController personNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List<RecordModel>> getUsers() async {
    final records = await pocketDB.collection('users').getFullList(filter: "id != '${pocketDB.authStore.record!.id}'", sort: '-updated');
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guff App"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {
              pocketDB.authStore.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemeApp.white,
          indicatorWeight: 3.5,
          labelColor: ThemeApp.white,
          tabs: const [
            Tab(child: Text("CHATS")),
            Tab(child: Text("STATUS")),
            Tab(child: Text("CALL")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupScreen())),
        backgroundColor: ThemeApp.sky,
        child: const Icon(Icons.message, color: ThemeApp.white),
      ),
      body: TabBarView(controller: _tabController, children: [ChatsScreen(), const StatusScreen(), CallScreen()]),
    );
  }
}
