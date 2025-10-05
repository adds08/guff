import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:guff/core/routing/route_manager.dart';

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
    final avatars = <AvatarWidget>[];
    final showCount = members.length > 4 ? 3 : members.length;

    for (int i = 0; i < showCount; i++) {
      final member = members[i];
      final name = member.getStringValue("name");
      final initials = _getInitials(name);
      final color = _getColorFromString(name);

      avatars.add(
        Avatar(
          initials: initials,
          backgroundColor: color,
        ),
      );
    }

    return Wrap(children: [AvatarGroup.toLeft(children: avatars)]);
  }
}

class ItemChatWidget extends ConsumerWidget {
  final RecordModel data;

  const ItemChatWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String timeString = data.get<String>('updated');
    // final members = data.get<List<RecordModel>>("expand.members");
    final createdBy = data.get<RecordModel>("expand.createdBy"); // assuming you have this field

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: Button.ghost(
        onPressed: () {
          ref
              .read(routerProvider)
              .pushNamed(
                'chat',
                queryParameters: {"name": data.get<String>('name')},
                pathParameters: {"id": data.id},
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Avatar(
                initials: createdBy.getStringValue('name').split(" ").map((e) => e.substring(0, 1)).join().toUpperCase(),
                borderRadius: 12,
                size: 48,
              ),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(data.get<String>('name')),
                        ),
                        Text(
                          timeago.format(DateTime.parse(timeString), locale: "en_short"),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: ThemeApp.gray,
                          ),
                        ),
                      ],
                    ),
                    Gap(8),
                    Text(
                      "by ${createdBy.getStringValue('name')}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
