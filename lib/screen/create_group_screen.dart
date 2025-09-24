import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/db.dart';
import 'package:guff/features/chats/chat_view_screen.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  List<dynamic> users = [];
  List<String> selectedUserIds = [];
  bool isLoading = true;
  TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final pb = ref.read(pocketbaseProvider);
    setState(() => isLoading = true);
    try {
      final result = await pb.collection('users').getFullList(filter: "id != '${pb.authStore.record!.id}'"); // adjust collection name
      setState(() {
        users = result;
      });
    } catch (e) {
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
    if (groupNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Group name cannot be empty")));
      return;
    }
    if (selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select at least one member")));
      return;
    }
    final pb = ref.read(pocketbaseProvider);
    setState(() => isLoading = true);
    try {
      final group = await pb
          .collection('groups')
          .create(
            body: {
              'name': groupNameController.text, // You can ask for a group name in a TextField
              'members': [pb.authStore.record!.id, ...selectedUserIds],
              'createdBy': pb.authStore.record!.id,
            },
          );
      final groupFetchAgain = await pb.collection('groups').getOne(group.id, expand: "members");
      // Navigate to group chat
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatViewScreen(recordModel: groupFetchAgain)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating group: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group"), actions: []),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Members", style: Theme.of(context).textTheme.titleMedium),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
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
                    ),
                  ),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: groupNameController,
                              decoration: const InputDecoration(hintText: "Add group Name"),
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.check), onPressed: createGroup),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
