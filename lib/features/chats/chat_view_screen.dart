import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/db.dart';
import 'package:guff/features/chats/provider/chats_provider.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatViewScreen extends ConsumerStatefulWidget {
  final ChatUser otherUser;
  const ChatViewScreen({super.key, required this.otherUser});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends ConsumerState<ChatViewScreen> {
  ChatUser currentUser = ChatUser(id: '', name: '');

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(id: pocketDB.authStore.record!.id, name: pocketDB.authStore.record!.getStringValue("name"));
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatsProviderProvider(widget.otherUser));
    // chatController.loadMoreData(provider);
    return Scaffold(
      body: ChatView(
        appBar: AppBar(
          title: Text(widget.otherUser.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        chatController: ref.watch(chatsProviderProvider(widget.otherUser).notifier).chatController,
        onSendTap: (message, replyMessage, messageType) {
          if (messageType.isText) {
            final String randomId = "temp-id-${DateTime.now().millisecondsSinceEpoch}";
            Message msg = Message(
              id: randomId,
              message: message,
              createdAt: DateTime.now(),
              sentBy: pocketDB.authStore.record!.id,
              reaction: Reaction(reactions: ["react"], reactedUserIds: [pocketDB.authStore.record!.id]),
              messageType: MessageType.text,
            );
            ref.read(chatsProviderProvider(widget.otherUser).notifier).sendMessage(widget.otherUser.id, msg);
          }
        },
        reactionPopupConfig: ReactionPopupConfiguration(
          userReactionCallback: (message, emoji) {
            // ref.read(chatsProviderProvider(widget.otherUser).notifier).addReaction(message, emoji);
          },
        ),
        chatViewState: provider, // Add this state once data is available

        chatBubbleConfig: ChatBubbleConfiguration(
          inComingChatBubbleConfig: ChatBubble(color: Colors.redAccent.shade200, borderRadius: BorderRadius.circular(12)),
          outgoingChatBubbleConfig: ChatBubble(color: Colors.blueAccent.shade200, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class ChatViewScreen2 extends ConsumerStatefulWidget {
  final RecordModel recordModel;
  const ChatViewScreen2({super.key, required this.recordModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewScreen2State();
}

class _ChatViewScreen2State extends ConsumerState<ChatViewScreen2> {
  ChatUser currentUser = ChatUser(id: '', name: '');

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(id: pocketDB.authStore.record!.id, name: pocketDB.authStore.record!.getStringValue("name"));
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(groupsProviderProvider(widget.recordModel));

    // chatController.loadMoreData(provider);
    return Scaffold(
      body: ChatView(
        appBar: AppBar(
          title: Text(widget.recordModel.getStringValue('name')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        chatController: ref.watch(groupsProviderProvider(widget.recordModel).notifier).chatController,
        onSendTap: (message, replyMessage, messageType) {
          if (messageType.isText) {
            final String randomId = "temp-id-${DateTime.now().millisecondsSinceEpoch}";
            Message msg = Message(
              id: randomId,
              message: message,
              createdAt: DateTime.now(),
              sentBy: pocketDB.authStore.record!.id,
              reaction: Reaction(reactions: ["react"], reactedUserIds: [pocketDB.authStore.record!.id]),
              messageType: MessageType.text,
            );
            ref.read(groupsProviderProvider(widget.recordModel).notifier).sendMessage(msg);
          }
        },
        reactionPopupConfig: ReactionPopupConfiguration(
          userReactionCallback: (message, emoji) {
            // ref.read(chatsProviderProvider(widget.otherUser).notifier).addReaction(message, emoji);
          },
        ),
        chatViewState: provider, // Add this state once data is available

        chatBubbleConfig: ChatBubbleConfiguration(
          inComingChatBubbleConfig: ChatBubble(color: Colors.redAccent.shade200, borderRadius: BorderRadius.circular(12)),
          outgoingChatBubbleConfig: ChatBubble(color: Colors.blueAccent.shade200, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
