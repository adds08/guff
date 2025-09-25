import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketbaseProvider = Provider<PocketBase>((ref) {
  return PocketBase('https://guffapi.codebigya.com');
});
