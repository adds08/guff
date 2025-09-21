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

String _$chatsRepositoryHash() => r'71ac57bb2361c1cb81627bc355e755088af0a2ee';

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

  ChatsRepositoryProvider call(String toUserId) =>
      ChatsRepositoryProvider._(argument: toUserId, from: this);

  @override
  String toString() => r'chatsRepositoryProvider';
}

abstract class _$ChatsRepository extends $AsyncNotifier<List<RecordModel>> {
  late final _$args = ref.$arg as String;
  String get toUserId => _$args;

  FutureOr<List<RecordModel>> build(String toUserId);
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
    required ChatUser super.argument,
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

String _$chatsProviderHash() => r'938a66f79f9ac0a1cd91c767bb994f6e5394381b';

final class ChatsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatsProvider,
          ChatViewState,
          ChatViewState,
          ChatViewState,
          ChatUser
        > {
  const ChatsProviderFamily._()
    : super(
        retry: null,
        name: r'chatsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatsProviderProvider call(ChatUser toUser) =>
      ChatsProviderProvider._(argument: toUser, from: this);

  @override
  String toString() => r'chatsProviderProvider';
}

abstract class _$ChatsProvider extends $Notifier<ChatViewState> {
  late final _$args = ref.$arg as ChatUser;
  ChatUser get toUser => _$args;

  ChatViewState build(ChatUser toUser);
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

@ProviderFor(GroupsRepository)
const groupsRepositoryProvider = GroupsRepositoryFamily._();

final class GroupsRepositoryProvider
    extends $AsyncNotifierProvider<GroupsRepository, List<RecordModel>> {
  const GroupsRepositoryProvider._({
    required GroupsRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groupsRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupsRepositoryHash();

  @override
  String toString() {
    return r'groupsRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GroupsRepository create() => GroupsRepository();

  @override
  bool operator ==(Object other) {
    return other is GroupsRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupsRepositoryHash() => r'65a98bbb056e191114daa1fae792cb64d931672e';

final class GroupsRepositoryFamily extends $Family
    with
        $ClassFamilyOverride<
          GroupsRepository,
          AsyncValue<List<RecordModel>>,
          List<RecordModel>,
          FutureOr<List<RecordModel>>,
          String
        > {
  const GroupsRepositoryFamily._()
    : super(
        retry: null,
        name: r'groupsRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupsRepositoryProvider call(String groupId) =>
      GroupsRepositoryProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupsRepositoryProvider';
}

abstract class _$GroupsRepository extends $AsyncNotifier<List<RecordModel>> {
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

@ProviderFor(GroupsProvider)
const groupsProviderProvider = GroupsProviderFamily._();

final class GroupsProviderProvider
    extends $NotifierProvider<GroupsProvider, ChatViewState> {
  const GroupsProviderProvider._({
    required GroupsProviderFamily super.from,
    required RecordModel super.argument,
  }) : super(
         retry: null,
         name: r'groupsProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groupsProviderHash();

  @override
  String toString() {
    return r'groupsProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GroupsProvider create() => GroupsProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupsProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupsProviderHash() => r'643cf74b032be6381350b7b01273149ede9e51ee';

final class GroupsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          GroupsProvider,
          ChatViewState,
          ChatViewState,
          ChatViewState,
          RecordModel
        > {
  const GroupsProviderFamily._()
    : super(
        retry: null,
        name: r'groupsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroupsProviderProvider call(RecordModel group) =>
      GroupsProviderProvider._(argument: group, from: this);

  @override
  String toString() => r'groupsProviderProvider';
}

abstract class _$GroupsProvider extends $Notifier<ChatViewState> {
  late final _$args = ref.$arg as RecordModel;
  RecordModel get group => _$args;

  ChatViewState build(RecordModel group);
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
