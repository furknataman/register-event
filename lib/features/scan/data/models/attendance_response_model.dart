enum AttendanceStatus {
  generalAttendanceAlreadyTaken(0),
  generalAttendanceSuccess(1),
  presentationAttendanceSuccess(2),
  presentationAttendanceAlreadyTaken(3),
  notRegisteredForPresentation(4),
  invalidQrCode(5);

  final int value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromValue(int value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AttendanceStatus.invalidQrCode,
    );
  }
}

class AttendanceResponseModel {
  final bool success;
  final AttendanceStatus status;

  AttendanceResponseModel({
    required this.success,
    required this.status,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    final statusValue = json['status'];
    final statusInt = statusValue is int
        ? statusValue
        : int.tryParse(statusValue.toString()) ?? 5;

    return AttendanceResponseModel(
      success: json['basarili'] ?? false,
      status: AttendanceStatus.fromValue(statusInt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basarili': success,
      'status': status.value,
    };
  }

  bool get isSuccess =>
      status == AttendanceStatus.generalAttendanceSuccess ||
      status == AttendanceStatus.presentationAttendanceSuccess;

  bool get isAlreadyTaken =>
      status == AttendanceStatus.generalAttendanceAlreadyTaken ||
      status == AttendanceStatus.presentationAttendanceAlreadyTaken;

  bool get isError =>
      status == AttendanceStatus.notRegisteredForPresentation ||
      status == AttendanceStatus.invalidQrCode;
}
