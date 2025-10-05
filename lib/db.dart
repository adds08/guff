import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_drift/pocketbase_drift.dart';

const String envValue = String.fromEnvironment("env", defaultValue: "https://guffapi.codebigya.com");

final guffSchemaProvider = AsyncNotifierProvider<GuffSchemaNotifier, String>(GuffSchemaNotifier.new);
final pocketbaseProvider = NotifierProvider<PocketbaseNotifier, $PocketBase>(PocketbaseNotifier.new);

class GuffSchemaNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    final schema = rootBundle.loadString('assets/guff_schema.json');
    return schema;
  }
}

class PocketbaseNotifier extends Notifier<$PocketBase> {
  $PocketBase pocketbase = $PocketBase.database("");

  @override
  $PocketBase build() {
    pocketbase = ref
        .watch(guffSchemaProvider)
        .maybeWhen(
          orElse: () => pocketbase,
          data: (data) {
            pocketbase.close();
            return $PocketBase.database(envValue)..cacheSchema(data);
          },
        );
    return pocketbase;
  }
}
