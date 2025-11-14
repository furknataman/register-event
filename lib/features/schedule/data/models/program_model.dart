class ProgramModel {
  final int id;
  final String baslangicSaati;
  final String bitisSaati;
  final String programTr;
  final String programEn;
  final bool renkli;
  final String? kayitliSunumBaslik;

  ProgramModel({
    required this.id,
    required this.baslangicSaati,
    required this.bitisSaati,
    required this.programTr,
    required this.programEn,
    this.renkli = false,
    this.kayitliSunumBaslik,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] ?? 0,
      baslangicSaati: json['baslangicSaati'] ?? '',
      bitisSaati: json['bitisSaati'] ?? '',
      programTr: json['programTr'] ?? '',
      programEn: json['programEn'] ?? '',
      renkli: json['renkli'] ?? false,
      kayitliSunumBaslik: json['kayitliSunumBaslik'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslangicSaati': baslangicSaati,
      'bitisSaati': bitisSaati,
      'programTr': programTr,
      'programEn': programEn,
      'renkli': renkli,
      'kayitliSunumBaslik': kayitliSunumBaslik,
    };
  }

  String getTimeRange() {
    // "08:15:00" formatından "08:15" formatına çevir
    final startTime = baslangicSaati.substring(0, 5);
    final endTime = bitisSaati.substring(0, 5);
    return '$startTime - $endTime';
  }

  String getLocalizedProgram(String languageCode) {
    final baseProgram = languageCode == 'en' ? programEn : programTr;
    if (kayitliSunumBaslik != null && kayitliSunumBaslik!.isNotEmpty) {
      return '$baseProgram - $kayitliSunumBaslik';
    }
    return baseProgram;
  }
}
