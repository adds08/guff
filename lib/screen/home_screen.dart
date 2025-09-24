import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:guff/db.dart';
import 'package:guff/features/screens.dart';
import 'package:guff/screen/create_group_screen.dart';
import 'package:guff/screen/status_screen.dart';
import 'package:guff/theme/theme_app.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController personNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<List<RecordModel>> getUsers() async {
    final records = await ref
        .watch(pocketbaseProvider)
        .collection('users')
        .getFullList(filter: "id != '${ref.watch(pocketbaseProvider).authStore.record!.id}'", sort: '-updated');
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
            onPressed: () async {
              (await SharedPreferences.getInstance()).clear();
              ref.read(pocketbaseProvider).authStore.clear();
              ref.read(routerProvider).replaceNamed("login");
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
