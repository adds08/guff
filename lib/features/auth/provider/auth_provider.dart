import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guff/db.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.g.dart';

//home_state.dart
sealed class AuthState {}

class LoadingState extends AuthState {}

class AuthInvalidState extends AuthState {}

class AuthValidState extends AuthState {}

@Riverpod(keepAlive: true)
class AuthProvider extends _$AuthProvider {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<bool> isAuthValid() async {
    final pb = ref.watch(pocketbaseProvider);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("pb_auth_token");
    final model = prefs.getString("pb_auth_model");
    if (token != null && model != null) {
      pb.authStore.save(token, RecordModel.fromJson(json.decode(model)));
      if (pb.authStore.isValid) {
        return true;
      }
    }
    return false;
  }

  Future<void> login(String email, String password) async {
    final pb = ref.watch(pocketbaseProvider);

    RecordAuth auth = await pb.collection('users').authWithPassword(email, password);
    pb.authStore.save(auth.token, auth.record);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("pb_auth_token", auth.token);
    await prefs.setString("pb_auth_model", auth.record.toString());
    try {
      final messaging = FirebaseMessaging.instance;
      // Get FCM token
      final token = await messaging.getToken();
      await pb.collection('userDevices').create(body: {"user": auth.record.id, "fcmToken": token});
    } catch (err) {}
  }
}
