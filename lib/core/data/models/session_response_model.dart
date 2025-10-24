import 'presentation_model.dart';

class RegisteredPresentationModel {
  final int? id;
  final int? sunumId;
  final int? oturum;

  RegisteredPresentationModel({
    this.id,
    this.sunumId,
    this.oturum,
  });

  factory RegisteredPresentationModel.fromJson(Map<String, dynamic> json) {
    return RegisteredPresentationModel(
      id: json['id'],
      sunumId: json['sunumId'],
      oturum: json['oturum'],
    );
  }
}

class SessionResponseModel {
  final List<ClassModelPresentation> oturum1;
  final List<ClassModelPresentation> oturum2;
  final List<ClassModelPresentation> oturum3;
  final List<ClassModelPresentation> oturum4;
  final List<RegisteredPresentationModel> kayitliSunum;

  SessionResponseModel({
    required this.oturum1,
    required this.oturum2,
    required this.oturum3,
    required this.oturum4,
    required this.kayitliSunum,
  });

  factory SessionResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionResponseModel(
      oturum1: (json['oturum1'] as List<dynamic>?)?.map((data) => ClassModelPresentation.fromJson(data)).toList() ?? [],
      oturum2: (json['oturum2'] as List<dynamic>?)?.map((data) => ClassModelPresentation.fromJson(data)).toList() ?? [],
      oturum3: (json['oturum3'] as List<dynamic>?)?.map((data) => ClassModelPresentation.fromJson(data)).toList() ?? [],
      oturum4: (json['oturum4'] as List<dynamic>?)?.map((data) => ClassModelPresentation.fromJson(data)).toList() ?? [],
      kayitliSunum: (json['kayitliSunum'] as List<dynamic>?)
              ?.map((data) => RegisteredPresentationModel.fromJson(data))
              .toList() ??
          [],
    );
  }

  // Tüm sunumları birleştir
  List<ClassModelPresentation> getAllPresentations() {
    return [...oturum1, ...oturum2, ...oturum3, ...oturum4];
  }

  // Kayıtlı sunumları getir
  List<ClassModelPresentation> getRegisteredPresentations() {
    final allPresentations = getAllPresentations();
    final registeredIds = kayitliSunum.map((r) => r.sunumId).toSet();
    return allPresentations.where((p) => registeredIds.contains(p.id)).toList();
  }

  // Oturuma göre sunumları getir
  List<ClassModelPresentation> getPresentationsBySession(int session) {
    switch (session) {
      case 1:
        return oturum1;
      case 2:
        return oturum2;
      case 3:
        return oturum3;
      case 4:
        return oturum4;
      default:
        return [];
    }
  }
}
