class ClassModelPresentation {
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
  final DateTime? presentationTime;
  final String? presentationPlace;
  final String? presentationQuota;
  final int? remainingQuota;

  ClassModelPresentation(
      {this.id,
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
      this.presentationPlace,
      this.presentationQuota,
      this.remainingQuota});

  factory ClassModelPresentation.fromJson(Map<String, dynamic> json) {
    String timeFromJson = json['presentationTime'] ?? "09:00:00";
    List<String> timeParts = timeFromJson.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);
    return ClassModelPresentation(
      id: json['id'] ?? 0,
      title: capitalizeFirstLetter(json['title']),
      description: json['description'] ?? " ",
      presenter1Name: json['presenter1Name'] ?? " ",
      presenter1Email: json['presenter1Email'] ?? " ",
      presenter2Name: json['presenter2Name'],
      presenter2Email: json['presenter2Email'],
      branch: json['branch'] ?? " ",
      audience: json['audience'] ?? " ",
      school: json['school'] ?? " ",
      duration: json['duration'],
      language: json['language'] ?? " ",
      type: json['type'] ?? " ",
      presentationTime: DateTime(2023, 10, 14, hour, minute, second),
      presentationPlace: json['presentationPlace'] ?? " ",
      presentationQuota: json['presentationQuota'] ?? "0",
      remainingQuota: json['kalanKota'] ?? 0,
    );
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return "";
  }

  return text.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return "";
  }).join(' ');
}
