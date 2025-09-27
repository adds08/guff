import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:guff/db.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../theme/theme_app.dart';

class GroupAvatars extends StatelessWidget {
  final List<RecordModel> members;
  final double radius;

  const GroupAvatars({super.key, required this.members, this.radius = 12});

  /// Get initials from name
  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Deterministic color from string
  Color _getColorFromString(String input) {
    final hash = input.codeUnits.fold(0, (prev, elem) => prev + elem);
    final random = Random(hash);
    return Colors.primaries[random.nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    final avatars = <Widget>[];
    final showCount = members.length > 4 ? 3 : members.length;

    for (int i = 0; i < showCount; i++) {
      final member = members[i];
      final name = member.getStringValue("name");
      final initials = _getInitials(name);
      final color = _getColorFromString(name);

      avatars.add(
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: color,
            child: Text(
              initials,
              style: TextStyle(color: Colors.white, fontSize: radius * 0.9),
            ),
          ),
        ),
      );
    }

    if (members.length > 4) {
      final extra = members.length - 3;
      avatars.add(
        CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade400,
          child: Text(
            "+$extra",
            style: TextStyle(color: Colors.white, fontSize: radius * 0.9, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: avatars);
  }
}

class ItemChatWidget extends ConsumerWidget {
  final RecordModel data;

  const ItemChatWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String timeString = data.get<String>('updated');
    final members = data.get<List<RecordModel>>("expand.members");
    final createdBy = data.get<RecordModel>("expand.createdBy"); // assuming you have this field

    return ListTile(
      onTap: () {
        ref
            .read(routerProvider)
            .pushNamed(
              'chat',
              queryParameters: {"name": data.get<String>('name')},
              pathParameters: {"id": data.id},
            );
      },
      leading: GroupAvatars(members: [ref.watch(pocketbaseProvider).authStore.record!], radius: 18),
      title: Text(data.get<String>('name'), style: const TextStyle(fontWeight: FontWeight.w500)),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text("by ${createdBy.getStringValue('name')} with", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
              SizedBox(width: 6),
              GroupAvatars(
                members: members.where((element) => element.id != ref.watch(pocketbaseProvider).authStore.record!.id).toList(),
                radius: 12,
              ),
            ],
          ),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Text(
              GetTimeAgo.parse(DateTime.parse(timeString)),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13.0, color: ThemeApp.gray),
            ),
          ),
        ],
      ),
    );
  }
}
