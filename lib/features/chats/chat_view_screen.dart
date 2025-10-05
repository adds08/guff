import 'package:go_router/go_router.dart';
import 'package:guff/db.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/features/chats/provider/chats_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ChatScreen extends ConsumerWidget {
  final String groupName;
  final String groupId;
  const ChatScreen({super.key, required this.groupName, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(chatsProviderProvider(groupId));

    ref.listen(
      chatsProviderProvider(groupId),
      (previous, next) {
        if (next == ChatViewState.error) {
          showToast(
            context: context,
            builder: (context, _) => Text("Oops! Something went wrong"),
            showDuration: Duration(seconds: 5),
            dismissible: true,
          );
        }
      },
    );

    return Scaffold(
      headers: [
        AppBar(
          title: Text(groupName),
          leading: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () => context.pop(),
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        Divider(),
      ],
      child: ChatView(
        loadingWidget: CircularProgressIndicator(),
        sendMessageConfig: SendMessageConfiguration(
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          textFieldBackgroundColor: Colors.gray,
        ),

        chatController: ref.watch(chatsProviderProvider(groupId).notifier).chatController,
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
            ref.read(chatsProviderProvider(groupId).notifier).sendMessage(msg);
          }
        },
        reactionPopupConfig: ReactionPopupConfiguration(
          userReactionCallback: (message, emoji) {
            ref.read(chatsProviderProvider(groupId).notifier).addReaction(message, emoji);
          },
        ),
        chatViewState: provider, // Add this state once data is available
        chatBackgroundConfig: ChatBackgroundConfiguration(
          padding: EdgeInsets.all(18),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          inComingChatBubbleConfig: ChatBubble(color: Colors.red, borderRadius: BorderRadius.circular(12)),
          outgoingChatBubbleConfig: ChatBubble(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
