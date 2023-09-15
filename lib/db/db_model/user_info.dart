class InfoUser {
  final int id;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String telephone;
  final String school;
  final String job;
  final List<int>? kayitOlduguSunumId;

  InfoUser({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.telephone,
    required this.school,
    required this.job,
     this.kayitOlduguSunumId,
  });

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      password: json['password'],
      telephone: json['telephone'],
      school: json['school'],
      job: json['job'],
      kayitOlduguSunumId: List<int>.from(json['kayitOlduguSunumId']),
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
      'kayitOlduguSunumId': kayitOlduguSunumId,
    };
  }
}
