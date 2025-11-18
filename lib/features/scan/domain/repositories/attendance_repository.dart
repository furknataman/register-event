import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/attendance_response_model.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceResponseModel>> takeAttendance(String qrCode);
}
