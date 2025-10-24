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
  final String? videoUrl;
  final String? presenterCount;
  final String? coordinatorName;
  final String? coordinatorEmail;
  final String? experience;
  final String? participantExperience;
  final String? participantCount;
  final String? extraInfo;
  // Detail endpoint specific fields
  final String? position; // gorev
  final String? presentationPlace; // sunumYeri
  final String? time; // saat
  final int? session; // oturum
  final int? quota; // kontenjan
  final int? registrationCount; // kayitSayisi
  final int? status; // status
  // Legacy fields for backward compatibility
  final DateTime? presentationTime;
  final String? presentationQuota;
  final String? ratingForm;
  final int? remainingQuota;

  ClassModelPresentation({
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
    this.videoUrl,
    this.presenterCount,
    this.coordinatorName,
    this.coordinatorEmail,
    this.experience,
    this.participantExperience,
    this.participantCount,
    this.extraInfo,
    this.position,
    this.presentationPlace,
    this.time,
    this.session,
    this.quota,
    this.registrationCount,
    this.status,
    this.presentationTime,
    this.presentationQuota,
    this.ratingForm,
    this.remainingQuota,
  });

  factory ClassModelPresentation.fromJson(Map<String, dynamic> json) {
    return ClassModelPresentation(
      id: json['id'],
      title: json['sunumBaslik'],
      description: json['ozet'],
      presenter1Name: json['sunucu1AdSoyad'],
      presenter1Email: json['sunucu1Eposta'],
      presenter2Name: json['sunucu2AdSoyad'],
      presenter2Email: json['sunucu2Eposta'],
      branch: json['ibAlani'],
      audience: json['dinleyiciKitle'],
      school: json['kurum'],
      duration: json['sure'],
      language: json['sunumDili'],
      type: json['sunumSekli'],
      videoUrl: json['videoUrl'],
      presenterCount: json['sunucuSayisi'],
      coordinatorName: json['koordinatorAdSoyad'],
      coordinatorEmail: json['koordinatorEposta'],
      experience: json['ibDeneyimi'],
      participantExperience: json['katilimciDeneyim'],
      participantCount: json['katilimciSayisi'],
      extraInfo: json['ekBilgi'],
      // Detail endpoint specific fields
      position: json['gorev'],
      presentationPlace: json['sunumYeri'],
      time: json['saat'],
      session: json['oturum'],
      quota: json['kontenjan'],
      registrationCount: json['kayitSayisi'],
      status: json['status'],
      // Legacy fields - set to default values
      presentationTime: DateTime.now().add(const Duration(days: 7)),
      presentationQuota: json['katilimciSayisi'] ?? '30',
      ratingForm: '',
      remainingQuota: json['kontenjan'] ?? 30,
    );
  }
}
