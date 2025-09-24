import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketbaseProvider = Provider<PocketBase>((ref) {
  return PocketBase('http://142.93.211.137');
});
