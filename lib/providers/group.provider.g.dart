// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GroupProvider)
const groupProviderProvider = GroupProviderProvider._();

final class GroupProviderProvider
    extends $NotifierProvider<GroupProvider, dynamic> {
  const GroupProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupProviderHash();

  @$internal
  @override
  GroupProvider create() => GroupProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(dynamic value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<dynamic>(value),
    );
  }
}

String _$groupProviderHash() => r'3012b92ca2f98134835a4b60bef008fe5ee7e10f';

abstract class _$GroupProvider extends $Notifier<dynamic> {
  dynamic build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<dynamic, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<dynamic, dynamic>,
              dynamic,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
