import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:guff/db.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_provider.g.dart';

@Riverpod()
class ChatsRepository extends _$ChatsRepository {
  @override
  FutureOr<List<RecordModel>> build(String toUserId) {
    return getMessages(toUserId);
  }

  Future<List<RecordModel>> getMessages(String toUserId) async {
    final records = await pocketDB.collection('chats').getFullList(sort: 'updated');
    return records;
  }

  Future<RecordModel> sendMessages(String toUserId, String message) async {
    final data = {'userId': pocketDB.authStore.record!.id, 'toUserId': toUserId, 'message': message};
    return await pocketDB.collection('chats').create(body: data);
  }

  Future<RecordModel> sendReaction(String reactionById, String messageId, String reaction) async {
    final data = {'userId': reactionById, 'reaction': reaction, 'chatId': messageId};
    return await pocketDB.collection('chat_reactions').create(body: data);
  }
}

@Riverpod()
class ChatsProvider extends _$ChatsProvider {
  List<Message> initialMessages = [];
  late ChatController chatController;

  @override
  ChatViewState build(ChatUser toUser) {
    chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      currentUser: pocketDB.authStore.record != null
          ? ChatUser(id: pocketDB.authStore.record!.id, name: pocketDB.authStore.record!.getStringValue("name"))
          : ChatUser(id: '', name: ''),
      otherUsers: [toUser],
    );
    initialize(toUser.id);

    return ChatViewState.loading;
  }

  Future<void> initialize(String toUserId) async {
    state = ChatViewState.loading;
    List<RecordModel> records = await ref.watch(chatsRepositoryProvider(toUserId).future);
    initialMessages = records
        .map(
          (e) => Message(
            id: e.getStringValue("id"),
            message: e.getStringValue("message"),
            createdAt: DateTime.tryParse(e.getStringValue("created")) ?? DateTime.now(),
            sentBy: e.getStringValue("userId") == pocketDB.authStore.record!.id ? pocketDB.authStore.record!.id : toUserId,
          ),
        )
        .toList();
    chatController.initialMessageList = [...initialMessages];
    state = ChatViewState.hasMessages;
    pocketDB.collection('chats').subscribe("*", (e) {
      if (e.action == "create" && e.record != null) {
        final msg = e.record!;
        // Add only if relevant
        if (msg.getStringValue('toUserId') == pocketDB.authStore.record!.id) {
          chatController.addMessage(
            Message(
              id: msg.getStringValue("id"),
              message: msg.getStringValue("message"),
              createdAt: DateTime.tryParse(msg.getStringValue("created")) ?? DateTime.now(),
              sentBy: msg.getStringValue("userId"),
              reaction: Reaction(reactions: ["love"], reactedUserIds: [pocketDB.authStore.record!.id]),
            ),
          );
          state = ChatViewState.hasMessages;
        }
      }
    });
  }

  Future<void> sendMessage(String toUserId, Message message) async {
    chatController.addMessage(message);
    RecordModel createdMessage = await ref.read(chatsRepositoryProvider(toUserId).notifier).sendMessages(toUserId, message.message);
    message = message.copyWith(id: createdMessage.id);
    chatController.initialMessageList = [
      for (final m in chatController.initialMessageList)
        if (m.id == message.id) message else m,
    ];
  }

  Future<void> addReaction(String toUserId, Message message, String emoji) async {
    RecordModel createdMessage = await ref.read(chatsRepositoryProvider(toUserId).notifier).sendReaction(toUserId, message.id, emoji);
    message = message.copyWith(id: createdMessage.id);
    chatController.initialMessageList = [
      for (final m in chatController.initialMessageList)
        if (m.id == message.id) message else m,
    ];
  }
}

@Riverpod()
class GroupsRepository extends _$GroupsRepository {
  @override
  FutureOr<List<RecordModel>> build(String groupId) {
    return getMessages(groupId);
  }

  Future<List<RecordModel>> getMessages(String groupId) async {
    final records = await pocketDB.collection('chats').getFullList(filter: "groupId = '$groupId'", sort: 'updated');
    return records;
  }

  Future<RecordModel> sendMessages(String groupId, String message) async {
    final data = {'userId': pocketDB.authStore.record!.id, 'groupId': groupId, 'message': message};
    return await pocketDB.collection('chats').create(body: data);
  }

  Future<RecordModel> sendReaction(String reactionById, String messageId, String reaction) async {
    final data = {'userId': reactionById, 'reaction': reaction, 'chatId': messageId};
    return await pocketDB.collection('chat_reactions').create(body: data);
  }
}

@Riverpod()
class GroupsProvider extends _$GroupsProvider {
  List<Message> initialMessages = [];
  late ChatController chatController;

  late RecordModel groupRecord;

  @override
  ChatViewState build(RecordModel group) {
    groupRecord = group;
    chatController = ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      currentUser: pocketDB.authStore.record != null
          ? ChatUser(id: pocketDB.authStore.record!.id, name: pocketDB.authStore.record!.getStringValue("name"))
          : ChatUser(id: '', name: ''),
      otherUsers: group
          .get<List<RecordModel>>("expand.members")
          .where((element) => (pocketDB.authStore.record!.id != element.id))
          .map((element) => ChatUser(id: element.id, name: element.getStringValue('name')))
          .toList(),
    );
    initialize(group.id);
    subscription(group.id);
    ref.onDispose(() {
      chatController.dispose();
      pocketDB.collection('chats').unsubscribe();
    });
    return ChatViewState.loading;
  }

  void subscription(String groupId) {
    pocketDB.collection('chats').subscribe("*", (e) {
      if (e.action == "create" && e.record != null) {
        final msg = e.record!;
        // Add only if relevant
        if (msg.getStringValue('groupId') == groupId && msg.getStringValue('userId') != pocketDB.authStore.record!.id) {
          chatController.addMessage(
            Message(
              id: msg.getStringValue("id"),
              message: msg.getStringValue("message"),
              createdAt: DateTime.tryParse(msg.getStringValue("created")) ?? DateTime.now(),
              sentBy: msg.getStringValue("userId"),
            ),
          );
          state = ChatViewState.hasMessages;
        }
      }
    });
  }

  Future<void> initialize(String groupId) async {
    state = ChatViewState.loading;
    List<RecordModel> records = await ref.watch(groupsRepositoryProvider(groupId).future);
    initialMessages = records
        .map(
          (e) => Message(
            id: e.getStringValue("id"),
            message: e.getStringValue("message"),
            createdAt: DateTime.tryParse(e.getStringValue("created")) ?? DateTime.now(),
            sentBy: e.getStringValue("userId"),
          ),
        )
        .toList();
    chatController.initialMessageList = [...initialMessages];
    state = ChatViewState.hasMessages;
  }

  Future<void> sendMessage(Message message) async {
    chatController.addMessage(message);
    RecordModel createdMessage = await ref.read(groupsRepositoryProvider(group.id).notifier).sendMessages(group.id, message.message);
    message = message.copyWith(id: createdMessage.id);
    chatController.initialMessageList = [
      for (final m in chatController.initialMessageList)
        if (m.id == message.id) message else m,
    ];
  }

  Future<void> addReaction(String toUserId, Message message, String emoji) async {
    RecordModel createdMessage = await ref.read(chatsRepositoryProvider(toUserId).notifier).sendReaction(toUserId, message.id, emoji);
    message = message.copyWith(id: createdMessage.id);
    chatController.initialMessageList = [
      for (final m in chatController.initialMessageList)
        if (m.id == message.id) message else m,
    ];
  }
}
