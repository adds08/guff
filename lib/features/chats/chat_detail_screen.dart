// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import 'package:guff/db.dart';
// import 'package:guff/features/chats/provider/chats_provider.dart';
// import 'package:guff/features/chats/widgets/chat_bubble_widget.dart';

// import '../../theme/theme_app.dart';

// class ChatDetailScreen extends ConsumerWidget {
//   final String image;
//   final String id;
//   const ChatDetailScreen({super.key, required this.image, required this.id});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final TextEditingController messageController = TextEditingController();
//     final provider = ref.watch(chatsProviderProvider(id));
//     return Scaffold(
//       backgroundColor: ThemeApp.grayYellow,
//       appBar: _appBarChat(name: id, image: image),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 9,
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: provider.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ChatBubbleWidget(
//                     message: provider[index].getStringValue("message"),
//                     isMyMessage: provider[index].getStringValue("userId") == pocketDB.authStore.record!.id,
//                     timestamp: provider[index].getStringValue("created"),
//                   );
//                 },
//               ),
//             ),
//             Flexible(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
//                   width: double.infinity,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: messageController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: "Message",
//                             prefixIcon: const Icon(Icons.sentiment_satisfied_alt, color: Color(0xff8796A2)),
//                             suffixIcon: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(Icons.attach_file_outlined, color: Color(0xff8796A2)),
//                                 SizedBox(width: 16),
//                                 Icon(Icons.camera_alt_rounded, color: Color(0xff8796A2)),
//                                 SizedBox(width: 16),
//                               ],
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14.0),
//                             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
//                             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8.0),
//                       GestureDetector(
//                         onTap: () {
//                           ref.read(chatsProviderProvider(id).notifier).sendMessage(id, messageController.text);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.all(10.0),
//                           decoration: const BoxDecoration(color: Color(0xff00A884), shape: BoxShape.circle),
//                           child: Icon(true ? Icons.send : Icons.mic, size: 28.0, color: ThemeApp.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _appBarChat extends StatelessWidget implements PreferredSizeWidget {
//   final String name;
//   final String image;

//   const _appBarChat({Key? key, required this.name, required this.image}) : super(key: key);

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leadingWidth: 20,
//       title: Row(
//         children: [
//           CircleAvatar(backgroundColor: ThemeApp.grayPale, backgroundImage: NetworkImage(image)),
//           const SizedBox(width: 7.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: const TextStyle(fontSize: 16.0)),
//                 const Text("Last seen today 19:00 pm", style: TextStyle(fontSize: 14.0, color: Colors.white60)),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
//         IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
//         IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//       ],
//     );
//   }
// }
