import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/attendance_remote_datasource.dart';
import '../../data/models/attendance_response_model.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../domain/repositories/attendance_repository.dart';

part 'attendance_provider.g.dart';

// Attendance DataSource provider
final attendanceRemoteDataSourceProvider =
    Provider<AttendanceRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AttendanceRemoteDatasourceImpl(apiClient);
});

// Attendance repository provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final remoteDataSource = ref.watch(attendanceRemoteDataSourceProvider);
  return AttendanceRepositoryImpl(remoteDataSource);
});

// Attendance notifier
@riverpod
class AttendanceNotifier extends _$AttendanceNotifier {
  @override
  FutureOr<AttendanceResponseModel?> build() {
    return null;
  }

  Future<AttendanceResponseModel?> takeAttendance(String qrCode) async {
    if (!ref.mounted) return null;
    state = const AsyncValue.loading();

    final repository = ref.read(attendanceRepositoryProvider);
    final result = await repository.takeAttendance(qrCode);

    return result.fold(
      (failure) {
        if (ref.mounted) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        }
        throw Exception(failure.message);
      },
      (response) {
        if (ref.mounted) {
          state = AsyncValue.data(response);
        }
        return response;
      },
    );
  }
}
