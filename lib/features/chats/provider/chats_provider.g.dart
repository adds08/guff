// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$groupsRepositoryHash() => r'a6c6deae9ad552f60d26ee6281d489f549159cd2';

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

String _$groupsProviderHash() => r'e1f7dfa236c5159a0811604b6141184ea570d44f';

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
