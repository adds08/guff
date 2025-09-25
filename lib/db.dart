import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

const String envValue = String.fromEnvironment("env", defaultValue: "http://127.0.0.1:8090");

final pocketbaseProvider = Provider<PocketBase>((ref) {
  PocketBase pocketBase = PocketBase(envValue);
  return pocketBase;
});
