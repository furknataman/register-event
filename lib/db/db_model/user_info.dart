class InfoUser {
  final int? id;
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final String? telephone;
  final String? school;
  final String? job;
  final List<int>? kayitOlduguSunumId;

  InfoUser({
     this.id,
     this.name,
     this.surname,
     this.email,
     this.password,
     this.telephone,
     this.school,
     this.job,
     this.kayitOlduguSunumId,
  });

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      id: json['id']?? 0,
      name: json['name']?? " ",
      surname: json['surname']?? " ",
      email: json['email']?? " ",
      password: json['password']?? " ",
      telephone: json['telephone']?? " ",
      school: json['school']?? " ",
      job: json['job']?? " ",
      kayitOlduguSunumId: (json['kayitOlduguSunumId'] != null) ? List<int>.from(json['kayitOlduguSunumId']) : null,
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
