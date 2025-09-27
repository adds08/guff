// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatsRepository)
const chatsRepositoryProvider = ChatsRepositoryFamily._();

final class ChatsRepositoryProvider
    extends $AsyncNotifierProvider<ChatsRepository, List<RecordModel>> {
  const ChatsRepositoryProvider._({
    required ChatsRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatsRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatsRepositoryHash();

  @override
  String toString() {
    return r'chatsRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatsRepository create() => ChatsRepository();

  @override
  bool operator ==(Object other) {
    return other is ChatsRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatsRepositoryHash() => r'68f95a2cf1cc18a09949182dff6c4b6ad05bcfe5';

final class ChatsRepositoryFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatsRepository,
          AsyncValue<List<RecordModel>>,
          List<RecordModel>,
          FutureOr<List<RecordModel>>,
          String
        > {
  const ChatsRepositoryFamily._()
    : super(
        retry: null,
        name: r'chatsRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatsRepositoryProvider call(String groupId) =>
      ChatsRepositoryProvider._(argument: groupId, from: this);

  @override
  String toString() => r'chatsRepositoryProvider';
}

abstract class _$ChatsRepository extends $AsyncNotifier<List<RecordModel>> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  FutureOr<List<RecordModel>> build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<RecordModel>>, List<RecordModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RecordModel>>, List<RecordModel>>,
              AsyncValue<List<RecordModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChatsProvider)
const chatsProviderProvider = ChatsProviderFamily._();

final class ChatsProviderProvider
    extends $NotifierProvider<ChatsProvider, ChatViewState> {
  const ChatsProviderProvider._({
    required ChatsProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatsProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatsProviderHash();

  @override
  String toString() {
    return r'chatsProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatsProvider create() => ChatsProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatsProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatsProviderHash() => r'e39bd7ce0960bdc6ea9a9628b987a19d8505039d';

final class ChatsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatsProvider,
          ChatViewState,
          ChatViewState,
          ChatViewState,
          String
        > {
  const ChatsProviderFamily._()
    : super(
        retry: null,
        name: r'chatsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatsProviderProvider call(String groupId) =>
      ChatsProviderProvider._(argument: groupId, from: this);

  @override
  String toString() => r'chatsProviderProvider';
}

abstract class _$ChatsProvider extends $Notifier<ChatViewState> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  ChatViewState build(String groupId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ChatViewState, ChatViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatViewState, ChatViewState>,
              ChatViewState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
