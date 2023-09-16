class Presentation {
  final int? id;
  final String? title;
  final String? description;
  final String? presenter1Name;
  final String? presenter1Email;
  final String? presenter2Name;
  final String? presenter2Email;
  final String? branch;
  final String? audience;
  final String? school;
  final String? duration;
  final String? language;
  final String? type;
  final String? presentationTime;
  // final String? presentationPlace;
  //final String presentationQuota;

  Presentation({
    this.id,
     this.title,
     this.description,
     this.presenter1Name,
     this.presenter1Email,
    this.presenter2Name,
    this.presenter2Email,
     this.branch,
     this.audience,
     this.school,
     this.duration,
     this.language,
     this.type,
    this.presentationTime,
    // this.presentationPlace,
    //required this.presentationQuota,
  });

  factory Presentation.fromJson(Map<String, dynamic> json) {
    return Presentation(
      id: json['id']?? 0,
      title: json['title']?? " ",
      description: json['description']?? " ",
      presenter1Name: json['presenter1Name']?? " ",
      presenter1Email: json['presenter1Email']?? " ",
      presenter2Name: json['presenter2Name'],
      presenter2Email: json['presenter2Email'],
      branch: json['branch']?? " ",
      audience: json['audience']?? " ",
      school: json['school']?? " ",
      duration: json['duration'],
      language: json['language']?? " ",
      type: json['type']?? " ",
      presentationTime: json['presentationTime'],
      //  presentationPlace: json['presentationPlace'],
      //presentationQuota: json['presentationQuota'],
    );
  }
}
