// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GroupsRepository)
const groupsRepositoryProvider = GroupsRepositoryProvider._();

final class GroupsRepositoryProvider
    extends $AsyncNotifierProvider<GroupsRepository, List<RecordModel>> {
  const GroupsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsRepositoryHash();

  @$internal
  @override
  GroupsRepository create() => GroupsRepository();
}

String _$groupsRepositoryHash() => r'3469e11ca6eb79ce66e1249f354d274494d48cd5';

abstract class _$GroupsRepository extends $AsyncNotifier<List<RecordModel>> {
  FutureOr<List<RecordModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
const groupsProviderProvider = GroupsProviderProvider._();

final class GroupsProviderProvider
    extends $NotifierProvider<GroupsProvider, GroupsState> {
  const GroupsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsProviderHash();

  @$internal
  @override
  GroupsProvider create() => GroupsProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupsState>(value),
    );
  }
}

String _$groupsProviderHash() => r'40fef6fff76a13da33c50d7765662e453e528ef8';

abstract class _$GroupsProvider extends $Notifier<GroupsState> {
  GroupsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GroupsState, GroupsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GroupsState, GroupsState>,
              GroupsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
