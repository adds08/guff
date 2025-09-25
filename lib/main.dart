import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guff/core/routing/route_manager.dart';
import 'package:guff/features/auth/provider/auth_provider.dart';
import 'package:guff/theme/theme_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: 'Guff App',
      theme: ThemeApp.configTheme,
    );
  }
}
