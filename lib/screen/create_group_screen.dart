import 'package:flutter/material.dart';
import 'package:guff/db.dart';
import 'package:guff/features/chats/chat_view_screen.dart';
import 'package:pocketbase/pocketbase.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  List<dynamic> users = [];
  List<String> selectedUserIds = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    try {
      final result = await pocketDB.collection('users').getFullList(); // adjust collection name
      setState(() {
        users = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching users: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleSelection(String userId) {
    setState(() {
      if (selectedUserIds.contains(userId)) {
        selectedUserIds.remove(userId);
      } else {
        selectedUserIds.add(userId);
      }
    });
  }

  Future<void> createGroup() async {
    if (selectedUserIds.isEmpty) return;

    setState(() => isLoading = true);
    try {
      final group = await pocketDB
          .collection('groups')
          .create(
            body: {
              'name': 'New Group', // You can ask for a group name in a TextField
              'members': selectedUserIds,
            },
          );
      final groupFetchAgain = await pocketDB.collection('groups').getOne(group.id, expand: "members");
      // Navigate to group chat
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatViewScreen2(recordModel: groupFetchAgain)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating group: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: createGroup)],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user.id;
                final isSelected = selectedUserIds.contains(userId);

                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.getStringValue('name') ?? 'Unnamed'),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                  onTap: () => toggleSelection(userId),
                );
              },
            ),
    );
  }
}

// Dummy GroupChatScreen
class GroupChatScreen extends StatelessWidget {
  final String groupId;
  const GroupChatScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group: $groupId")),
      body: const Center(child: Text("Chat messages here")),
    );
  }
}
