import 'package:chatview/chatview.dart';
import 'package:guff/db.dart';
import 'package:guff/features/groups/provider/groups_state.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_provider.g.dart';

@Riverpod()
class GroupsRepository extends _$GroupsRepository {
  @override
  FutureOr<List<RecordModel>> build() {
    return getGroups();
  }

  Future<List<RecordModel>> getGroups() async {
    final records = await ref
        .read(pocketbaseProvider)
        .collection('groups')
        .getFullList(
          filter: "members~'${ref.watch(pocketbaseProvider).authStore.record!.id}'",
          expand: "members,createdBy",
          sort: '-updated',
        );
    return records;
  }
}

@Riverpod()
class GroupsProvider extends _$GroupsProvider {
  List<RecordModel> initalGroups = [];
  @override
  GroupsState build() {
    final pb = ref.watch(pocketbaseProvider);
    subscribeToGroups(pb);
    initialize();
    ref.onDispose(() {
      pb.collection('groups').unsubscribe();
    });
    return GroupsViewLoading();
  }

  void subscribeToGroups(PocketBase pb) {
    pb
        .collection('groups')
        .subscribe(
          "*",
          (e) {
            if ((e.action == "create" || e.action == "update") && e.record != null) {
              final msg = e.record!;
              // Add only if relevant
              if (msg.getListValue<String>('members').contains(pb.authStore.record!.id)) {
                initalGroups = [msg, ...initalGroups];
                state = state = GroupsViewData(initalGroups);
              }
            }
          },
          filter: "members~'${ref.watch(pocketbaseProvider).authStore.record!.id}'",
          expand: "members,createdBy",
        );
  }

  Future<void> initialize() async {
    state = GroupsViewLoading();
    List<RecordModel> records = await ref.read(groupsRepositoryProvider.future);
    initalGroups = records;
    state = GroupsViewData(initalGroups);
    // chatController.initialMessageList = [...initialMessages];
    // state = ChatViewState.hasMessages;
  }

  Future<void> sendMessage(Message message) async {
    // chatController.addMessage(message);
    // RecordModel createdMessage = await ref
    //     .read(groupsRepositoryProvider(group.id).notifier)
    //     .sendMessages(group.id, message.message, message.replyMessage.messageId);
    // Message responseMessage = message.copyWith(
    //   id: createdMessage.id,
    //   status: MessageStatus.tryParse(createdMessage.getStringValue('status')),
    // );
    // List<Message> newMessages = [
    //   for (final m in chatController.initialMessageList)
    //     if (m.id != message.id) m,
    // ];
    // chatController.initialMessageList = [...newMessages];
    // chatController.addMessage(responseMessage);
  }

  Future<void> addReaction(Message message, String emoji) async {
    // final pb = ref.read(pocketbaseProvider);
    // RecordModel createdMessage = RecordModel.fromJson({});
    // if (message.reaction.reactedUserIds.contains(pb.authStore.record!.id)) {
    //   createdMessage = await ref.read(groupsRepositoryProvider(group.id).notifier).updateReaction(message.id, emoji);
    // } else {
    //   createdMessage = await ref.read(groupsRepositoryProvider(group.id).notifier).sendReaction(message.id, emoji);
    // }

    // Message responseMessage = message.copyWith(
    //   id: createdMessage.id,
    //   status: MessageStatus.tryParse(createdMessage.getStringValue('status')) ?? MessageStatus.delivered,
    // );
    // List<Message> newMessages = [
    //   for (final m in chatController.initialMessageList)
    //     if (m.id == message.id) responseMessage else m,
    // ];
    // chatController.initialMessageList = [...newMessages];
  }
}
