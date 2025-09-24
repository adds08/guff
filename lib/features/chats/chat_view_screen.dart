import 'package:go_router/go_router.dart';
import 'package:guff/db.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/features/chats/provider/chats_provider.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatViewScreen extends ConsumerWidget {
  final RecordModel recordModel;
  const ChatViewScreen({super.key, required this.recordModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(groupsProviderProvider(recordModel));
    return Scaffold(
      body: ChatView(
        sendMessageConfig: SendMessageConfiguration(
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          textFieldBackgroundColor: Colors.grey.shade200,
          textFieldConfig: TextFieldConfiguration(textStyle: TextStyle(color: Colors.black)),
        ),
        appBar: AppBar(
          title: Text(recordModel.getStringValue('name')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),

        chatController: ref.watch(groupsProviderProvider(recordModel).notifier).chatController,
        onSendTap: (message, replyMessage, messageType) {
          if (messageType.isText) {
            final String randomId = "temp-id-${DateTime.now().millisecondsSinceEpoch}";
            Message msg = Message(
              id: randomId,
              message: message,
              createdAt: DateTime.now(),
              sentBy: ref.watch(pocketbaseProvider).authStore.record!.id,
              messageType: MessageType.text,
              replyMessage: replyMessage,
              status: MessageStatus.pending,
            );
            ref.read(groupsProviderProvider(recordModel).notifier).sendMessage(msg);
          }
        },

        reactionPopupConfig: ReactionPopupConfiguration(
          userReactionCallback: (message, emoji) {
            ref.read(groupsProviderProvider(recordModel).notifier).addReaction(message, emoji);
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
