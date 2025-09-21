import 'package:flutter/material.dart';
import 'package:guff/theme/theme_app.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMyMessage;
  final String timestamp;

  const ChatBubbleWidget({super.key, required this.message, required this.isMyMessage, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50, // bubble won’t shrink too small
          maxWidth: MediaQuery.of(context).size.width * 0.7, // cap bubble width
        ),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isMyMessage ? const Color(0xffE7FFDC) : Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(10),
              bottomRight: const Radius.circular(10),
              topLeft: isMyMessage ? const Radius.circular(10) : const Radius.circular(0),
              topRight: isMyMessage ? const Radius.circular(0) : const Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 👈 important: wrap content vertically
            children: [
              Text(message, softWrap: true),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min, // 👈 important: wrap content horizontally
                children: [
                  Text(timestamp, style: const TextStyle(fontSize: 12.0, color: ThemeApp.graySemiPale)),
                  const SizedBox(width: 2.0),
                  const Icon(Icons.check, size: 13, color: ThemeApp.sky),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
