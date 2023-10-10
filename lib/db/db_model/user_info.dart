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
  final String? generalForm;
  final bool? generalRollCall;
  final List<int>? registeredEventId;
  final List<DateTime>? registeredEventTime;
  final List<int>? attendedToEventId;

  InfoUser(
      {this.id,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.telephone,
      this.school,
      this.generalRollCall,
      this.job,
      this.generalForm,
      this.registeredEventId,
      this.registeredEventTime,
      this.attendedToEventId});

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    DateTime dontTrustFool(String time) {
      final parsedTime = DateFormat('HH:mm').parse(time);
      final formatedData = DateTime(2023, 10, 14, parsedTime.hour, parsedTime.minute);
      return formatedData;
    }

    return InfoUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? " ",
      generalForm: json['anketLinki'],
      surname: json['surname'] ?? " ",
      email: json['email'] ?? " ",
      generalRollCall: json['genelYoklama'] ?? false,
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
              .map((time) => dontTrustFool(time.toString()))
              .toList()
          : null,
      attendedToEventId: (json['yoklamaTrueSunumId'] != null)
          ? List<int>.from(json['yoklamaTrueSunumId'])
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
