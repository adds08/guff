import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:guff/db.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_provider.g.dart';

@Riverpod()
class ChatsRepository extends _$ChatsRepository {
  @override
  FutureOr<List<RecordModel>> build(String groupId) {
    return getMessages(groupId);
  }

  Future<List<RecordModel>> getMessages(String groupId) async {
    final records = await ref
        .watch(pocketbaseProvider)
        .collection('chats')
        .getFullList(expand: "chatReactions_via_chatId,replyTo", filter: "groupId = '$groupId'", sort: 'created');
    return records;
  }

  Future<RecordModel> sendMessages(String groupId, String message, String? replyTo) async {
    final pb = ref.watch(pocketbaseProvider);
    final data = {'userId': pb.authStore.record!.id, 'groupId': groupId, 'message': message, 'replyTo': replyTo, 'status': "delivered"};
    return await pb.collection('chats').create(body: data);
  }

  Future<RecordModel> sendReaction(String messageId, String reaction) async {
    final pb = ref.watch(pocketbaseProvider);
    final data = {'reaction': reaction, 'chatId': messageId, 'userId': pb.authStore.record!.id};
    return await pb.collection('chatReactions').create(body: data);
  }

  Future<RecordModel> updateReaction(String messageId, String reaction) async {
    final pb = ref.watch(pocketbaseProvider);
    final data = {'reaction': reaction};
    RecordModel chatReaction = await pb
        .collection('chatReactions')
        .getFirstListItem("chatId='$messageId' && userId='${pb.authStore.record!.id}'");
    return await pb.collection('chatReactions').update(chatReaction.id, body: data);
  }
}

@Riverpod()
class ChatsProvider extends _$ChatsProvider {
  List<Message> initialMessages = [];
  late ChatController chatController;

  late RecordModel groupRecord;

  @override
  ChatViewState build(RecordModel group) {
    final pb = ref.watch(pocketbaseProvider);
    groupRecord = group;
    chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      currentUser: pb.authStore.record != null
          ? ChatUser(
              id: pb.authStore.record!.id,
              name: pb.authStore.record!.getStringValue("name"),
            )
          : ChatUser(id: '', name: ''),
      otherUsers: group
          .get<List<RecordModel>>("expand.members")
          .where((element) => (pb.authStore.record!.id != element.id))
          .map((element) => ChatUser(id: element.id, name: element.getStringValue('name')))
          .toList(),
    );
    initialize(group.id);
    subscribeToChat(pb);
    ref.onDispose(() {
      pb.collection('chats').unsubscribe();
      chatController.dispose();
    });
    return ChatViewState.loading;
  }

  void subscribeToChat(PocketBase pb) {
    pb.collection('chats').subscribe("*", (e) {
      if (e.action == "create" && e.record != null) {
        final msg = e.record!;
        // Add only if relevant
        if (msg.getStringValue('groupId') == group.id && msg.getStringValue('userId') != pb.authStore.record!.id) {
          chatController.addMessage(
            Message(
              id: msg.getStringValue("id"),
              message: msg.getStringValue("message"),
              createdAt: DateTime.tryParse(msg.getStringValue("created")) ?? DateTime.now(),
              sentBy: msg.getStringValue("userId"),
              status: MessageStatus.tryParse(msg.getStringValue('status')) ?? MessageStatus.delivered,
            ),
          );
          state = ChatViewState.hasMessages;
        }
      }
    });
  }

  Future<void> initialize(String groupId) async {
    state = ChatViewState.loading;
    List<RecordModel> records = await ref.read(chatsRepositoryProvider(groupId).future);

    initialMessages = records.map(
      (e) {
        List<RecordModel> reactions = e.getListValue<RecordModel>('expand.chatReactions_via_chatId');
        RecordModel reply = e.get<RecordModel>('expand.replyTo');
        return Message(
          id: e.getStringValue("id"),
          message: e.getStringValue("message"),
          createdAt: DateTime.tryParse(e.getStringValue("created")) ?? DateTime.now(),
          sentBy: e.getStringValue("userId"),
          reaction: Reaction(
            reactions: reactions.map((react) => react.getStringValue('reaction')).toList(),
            reactedUserIds: reactions.map((react) => react.getStringValue('userId')).toList(),
          ),
          replyMessage: ReplyMessage(
            messageId: reply.id,
            message: reply.getStringValue('message'),
            replyBy: e.getStringValue("userId"),
            replyTo: reply.getStringValue('userId'),
          ),
          status: MessageStatus.tryParse(e.getStringValue("status")) ?? MessageStatus.delivered,
        );
      },
    ).toList();
    chatController.initialMessageList = [...initialMessages];
    state = ChatViewState.hasMessages;
  }

  Future<void> sendMessage(Message message) async {
    chatController.addMessage(message);
    RecordModel createdMessage = await ref
        .read(chatsRepositoryProvider(group.id).notifier)
        .sendMessages(group.id, message.message, message.replyMessage.messageId);
    Message responseMessage = message.copyWith(
      id: createdMessage.id,
      status: MessageStatus.tryParse(createdMessage.getStringValue('status')),
    );
    List<Message> newMessages = [
      for (final m in chatController.initialMessageList)
        if (m.id != message.id) m,
    ];
    chatController.initialMessageList = [...newMessages];
    chatController.addMessage(responseMessage);
  }

  Future<void> addReaction(Message message, String emoji) async {
    final pb = ref.read(pocketbaseProvider);
    RecordModel createdMessage = RecordModel.fromJson({});
    if (message.reaction.reactedUserIds.contains(pb.authStore.record!.id)) {
      createdMessage = await ref.read(chatsRepositoryProvider(group.id).notifier).updateReaction(message.id, emoji);
    } else {
      createdMessage = await ref.read(chatsRepositoryProvider(group.id).notifier).sendReaction(message.id, emoji);
    }

    Message responseMessage = message.copyWith(
      id: createdMessage.id,
      status: MessageStatus.tryParse(createdMessage.getStringValue('status')) ?? MessageStatus.delivered,
    );
    List<Message> newMessages = [
      for (final m in chatController.initialMessageList)
        if (m.id == message.id) responseMessage else m,
    ];
    chatController.initialMessageList = [...newMessages];
  }
}
