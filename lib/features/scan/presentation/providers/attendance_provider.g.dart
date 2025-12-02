// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AttendanceNotifier)
const attendanceProvider = AttendanceNotifierProvider._();

final class AttendanceNotifierProvider extends $AsyncNotifierProvider<
    AttendanceNotifier, AttendanceResponseModel?> {
  const AttendanceNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'attendanceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$attendanceNotifierHash();

  @$internal
  @override
  AttendanceNotifier create() => AttendanceNotifier();
}

String _$attendanceNotifierHash() =>
    r'4299d6eed33dca80aec56e7770d160f28e166957';

abstract class _$AttendanceNotifier
    extends $AsyncNotifier<AttendanceResponseModel?> {
  FutureOr<AttendanceResponseModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<AttendanceResponseModel?>, AttendanceResponseModel?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AttendanceResponseModel?>,
            AttendanceResponseModel?>,
        AsyncValue<AttendanceResponseModel?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
