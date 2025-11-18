import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/attendance_response_model.dart';

abstract class AttendanceRemoteDatasource {
  Future<AttendanceResponseModel> takeAttendance(String qrCode);
}

class AttendanceRemoteDatasourceImpl implements AttendanceRemoteDatasource {
  final ApiClient apiClient;

  AttendanceRemoteDatasourceImpl(this.apiClient);

  @override
  Future<AttendanceResponseModel> takeAttendance(String qrCode) async {
    try {
      final response = await apiClient.post(
        '/Yoklama/YoklamaAl',
        data: {'QrKod': qrCode},
      );

      return AttendanceResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid QR code format');
      }
      rethrow;
    }
  }
}
