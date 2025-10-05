import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rive/rive.dart' as rive;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'firebase_options.dart';

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rive.RiveNative.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    final messaging = FirebaseMessaging.instance;

    // iOS & macOS: request permissions
    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
    print('Permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // final groupId = message.data['groupId'];
      // Navigator.pushNamed(context, '/groupDetail', arguments: groupId);
    });

    // Get FCM token
    final token = await messaging.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((message) {
      SystemSound.play(SystemSoundType.alert);
      if (context.mounted) {
        showToast(
          context: context,
          dismissible: true,
          showDuration: Duration(seconds: 5),
          builder: (context, overlay) => Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${message.notification?.title ?? 'No Title'} has a message"),
                    Text(message.notification?.body ?? 'No Body'),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });

    // When tapping notification opens app
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('App opened via notification: ${message.notification?.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: 'Guff App',
      theme: ThemeData(),
      // scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
