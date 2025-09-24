// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthProvider)
const authProviderProvider = AuthProviderProvider._();

final class AuthProviderProvider
    extends $AsyncNotifierProvider<AuthProvider, void> {
  const AuthProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authProviderHash();

  @$internal
  @override
  AuthProvider create() => AuthProvider();
}

String _$authProviderHash() => r'4c973f8dcffe82cd824cce3241a8c49f6b9524d7';

abstract class _$AuthProvider extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
