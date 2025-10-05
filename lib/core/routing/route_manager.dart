import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guff/db.dart';
import 'package:guff/features/auth/login_screen.dart';
import 'package:guff/features/auth/provider/auth_provider.dart';
import 'package:guff/features/auth/splash_screen.dart';
import 'package:guff/features/chats/chat_view_screen.dart';
import 'package:guff/features/groups/group_screen.dart';
import 'package:guff/screen/home_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: "/",
    redirect: (context, state) {
      if (ref.watch(pocketbaseProvider).baseURL.isEmpty) {
        return "/";
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        routes: [],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        redirect: (context, state) async {
          if (await ref.read(authProviderProvider.notifier).isAuthValid()) {
            return '/home';
          }
          return null;
        },
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
            path: 'group',
            name: 'group',
            builder: (BuildContext context, GoRouterState state) {
              return GroupScreen();
            },
            routes: [
              GoRoute(
                path: 'chat/:id',
                name: 'chat',
                builder: (BuildContext context, GoRouterState state) {
                  String groupId = state.pathParameters["id"]!;
                  String groupName = state.uri.queryParameters["name"]!;
                  return ChatScreen(
                    groupName: groupName,
                    groupId: groupId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
