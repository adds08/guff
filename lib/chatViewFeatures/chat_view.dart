import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class ChatViewWidget extends StatelessWidget {
  ChatViewWidget({super.key});
  final chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    currentUser: ChatUser(id: '1', name: 'Flutter'),
    otherUsers: [ChatUser(id: '2', name: 'Simform')],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        chatController: chatController,
        onSendTap: (message, replyMessage, messageType) {},
        chatViewState: ChatViewState.hasMessages, // Add this state once data is available
      ),
    );
  }
}
