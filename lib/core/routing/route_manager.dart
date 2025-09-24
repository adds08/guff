import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guff/features/auth/login_screen.dart';
import 'package:guff/features/auth/provider/auth_provider.dart';
import 'package:guff/features/auth/splash_screen.dart';
import 'package:guff/features/chats/chat_view_screen.dart';
import 'package:guff/screen/home_screen.dart';
import 'package:pocketbase/pocketbase.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: "/home",
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: '/',

        redirect: (context, state) async {
          if (await ref.read(authProviderProvider.notifier).isAuthValid()) {
            return '/home';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        routes: [],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        redirect: (context, state) async {
          if (await ref.read(authProviderProvider.notifier).isAuthValid()) {
            return null;
          }
          return '/login';
        },
        routes: [
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (BuildContext context, GoRouterState state) {
              RecordModel data = state.extra as RecordModel;
              return ChatViewScreen(
                recordModel: data,
              );
            },
          ),
        ],
      ),
    ],
  ),
);
