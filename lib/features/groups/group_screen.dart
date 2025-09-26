import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/features/groups/item_chat_widget.dart';
import 'package:guff/features/groups/provider/groups_provider.dart';
import 'package:guff/features/groups/provider/groups_state.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupProvider = ref.watch(groupsProviderProvider);
    return switch (groupProvider) {
      GroupsViewData(:final data) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(groupsProviderProvider.notifier).initialize();
          },
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => ItemChatWidget(data: data[index]),
          ),
        ),
      ),
      GroupsViewError() => Text("Could not load data"),
      _ => Center(child: CircularProgressIndicator()),
    };
  }
}
