class Presentation {
  final int id;
  final String title;
  final String description;
  final String presenter1Name;
  final String presenter1Email;
  final String presenter1Telephone;
  final String presenter2Name;
  final String presenter2Email;
  final String presenter2Telephone;
  final String branch;
  final String audience;
  final String school;
  final String duration;
  final String language;
  final String type;
  final String? needs;
  final String? suggestion;
  final String presentationTime;
  final String? presentationPlace;
  final String presentationQuota;

  Presentation({
    required this.id,
    required this.title,
    required this.description,
    required this.presenter1Name,
    required this.presenter1Email,
    required this.presenter1Telephone,
    required this.presenter2Name,
    required this.presenter2Email,
    required this.presenter2Telephone,
    required this.branch,
    required this.audience,
    required this.school,
    required this.duration,
    required this.language,
    required this.type,
    this.needs,
    this.suggestion,
    required this.presentationTime,
    this.presentationPlace,
    required this.presentationQuota,
  });

  factory Presentation.fromJson(Map<String, dynamic> json) {
    return Presentation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      presenter1Name: json['presenter1Name'],
      presenter1Email: json['presenter1Email'],
      presenter1Telephone: json['presenter1Telephone'],
      presenter2Name: json['presenter2Name'],
      presenter2Email: json['presenter2Email'],
      presenter2Telephone: json['presenter2Telephone'],
      branch: json['branch'],
      audience: json['audience'],
      school: json['school'],
      duration: json['duration'],
      language: json['language'],
      type: json['type'],
      needs: json['needs'],
      suggestion: json['suggestion'],
      presentationTime: json['presentationTime'],
      presentationPlace: json['presentationPlace'],
      presentationQuota: json['presentationQuota'],
    );
  }
}
