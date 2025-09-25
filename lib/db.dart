import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

const String envValue = String.fromEnvironment("env", defaultValue: "https://guffapi.codebigya.com");

final pocketbaseProvider = Provider<PocketBase>((ref) {
  PocketBase pocketBase = PocketBase(envValue);
  return pocketBase;
});
