import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/attendance_response_model.dart';

abstract class AttendanceRemoteDatasource {
  Future<AttendanceResponseModel> takeAttendance(String qrCode);
}

class AttendanceRemoteDatasourceImpl implements AttendanceRemoteDatasource {
  final ApiClient apiClient;
  final AppLogger _logger;

  AttendanceRemoteDatasourceImpl(this.apiClient, this._logger);

  @override
  Future<AttendanceResponseModel> takeAttendance(String qrCode) async {
    try {
      final response = await apiClient.post(
        '/Yoklama/YoklamaAl',
        data: jsonEncode({'QrKod': qrCode}),
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      _logger.info('Attendance taken successfully for QR: ${qrCode.substring(0, 10)}...');
      return AttendanceResponseModel.fromJson(response.data);
    } on NetworkException {
      _logger.error('Network error during attendance');
      rethrow;
    } on ServerException {
      _logger.error('Server error during attendance');
      rethrow;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error taking attendance', e, stackTrace);
      throw ServerException('Failed to take attendance');
    }
  }
}
