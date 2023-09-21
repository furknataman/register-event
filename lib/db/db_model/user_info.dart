import 'package:intl/intl.dart';

class InfoUser {
  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final String? telephone;
  final String? school;
  final String? job;
  final List<int>? registeredEventId;
  final List<DateTime>? registeredEventTime;

  InfoUser(
      {this.id,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.telephone,
      this.school,
      this.job,
      this.registeredEventId,
      this.registeredEventTime});

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    DateTime dontTrustFool(String time) {
      final parsedTime = DateFormat('HH:mm').parse(time);
      return DateTime(2023, 10, 14, parsedTime.hour, parsedTime.minute);
    }

    return InfoUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? " ",
      surname: json['surname'] ?? " ",
      email: json['email'] ?? " ",
      password: json['password'] ?? " ",
      telephone: json['telephone'] ?? " ",
      school: json['school'] ?? " ",
      job: json['job'] ?? " ",
      registeredEventId: (json['kayitOlduguSunumId'] != null)
          ? List<int>.from(json['kayitOlduguSunumId'])
          : null,
      registeredEventTime: (json['sunumSaatleri'] != null)
          ? (json['sunumSaatleri'] as List)
              .where((time) => time != null)
              .map((time) => dontTrustFool(time as String))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'telephone': telephone,
      'school': school,
      'job': job,
      'kayitOlduguSunumId': registeredEventId,
    };
  }
}
