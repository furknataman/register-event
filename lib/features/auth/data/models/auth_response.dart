import '../../domain/entities/user.dart';

// API'den dönen Türkçe response modeli
class LoginApiResponse {
  final bool basarili;
  final int? id;
  final String? ad;
  final String? soyad;
  final String? okul;
  final String? unvan;
  final String? eposta;
  final String? telefon;
  final String? ekBilgi;
  final String? token;

  const LoginApiResponse({
    required this.basarili,
    this.id,
    this.ad,
    this.soyad,
    this.okul,
    this.unvan,
    this.eposta,
    this.telefon,
    this.ekBilgi,
    this.token,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      basarili: json['basarili'] as bool? ?? false,
      id: json['id'] as int?,
      ad: json['ad'] as String?,
      soyad: json['soyad'] as String?,
      okul: json['okul'] as String?,
      unvan: json['unvan'] as String?,
      eposta: json['eposta'] as String?,
      telefon: json['telefon'] as String?,
      ekBilgi: json['ekBilgi'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basarili': basarili,
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'okul': okul,
      'unvan': unvan,
      'eposta': eposta,
      'telefon': telefon,
      'ekBilgi': ekBilgi,
      'token': token,
    };
  }
}

// LoginApiResponse'u AuthResponse'a dönüştüren extension
extension LoginApiResponseExtension on LoginApiResponse {
  AuthResponse toAuthResponse() {
    return AuthResponse(
      user: UserModel(
        id: id ?? 0,
        email: eposta ?? '',
        name: '${ad ?? ''} ${soyad ?? ''}'.trim(),
        phone: telefon,
        school: okul,
        branch: unvan,
      ),
      token: token ?? '',
    );
  }
}

class AuthResponse {
  final UserModel user;
  final String token;
  final String? refreshToken;
  final int? expiresIn;

  const AuthResponse({
    required this.user,
    required this.token,
    this.refreshToken,
    this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}

class UserModel {
  final int id;
  final String email;
  final String name;
  final String? phone;
  final String? school;
  final String? branch;
  final List<int>? registeredEventIds;
  final List<int>? attendedEventIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.school,
    this.branch,
    this.registeredEventIds,
    this.attendedEventIds,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      school: json['school'] as String?,
      branch: json['branch'] as String?,
      registeredEventIds: (json['registeredEventIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      attendedEventIds: (json['attendedEventIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'school': school,
      'branch': branch,
      'registeredEventIds': registeredEventIds,
      'attendedEventIds': attendedEventIds,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

extension UserModelExtension on UserModel {
  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      phone: phone,
      school: school,
      branch: branch,
      registeredEventIds: registeredEventIds,
      attendedEventIds: attendedEventIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserDomainExtension on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      phone: phone,
      school: school,
      branch: branch,
      registeredEventIds: registeredEventIds,
      attendedEventIds: attendedEventIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Password Reset Models
class ForgotPasswordResponse {
  final bool basarili;
  final String? mesaj;
  final int? status;

  const ForgotPasswordResponse({
    required this.basarili,
    this.mesaj,
    this.status,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      basarili: json['basarili'] as bool? ?? json['sonuc'] as bool? ?? false,
      mesaj: json['mesaj'] as String?,
      status: json['status'] as int?,
    );
  }
}

class ResetPasswordResponse {
  final bool basarili;
  final String? mesaj;
  final int? status;

  const ResetPasswordResponse({
    required this.basarili,
    this.mesaj,
    this.status,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      basarili: json['basarili'] as bool? ?? json['sonuc'] as bool? ?? false,
      mesaj: json['mesaj'] as String?,
      status: json['status'] as int?,
    );
  }
}
