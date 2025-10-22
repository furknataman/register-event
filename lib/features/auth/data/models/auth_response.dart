import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

// API'den dönen Türkçe response modeli
@freezed
class LoginApiResponse with _$LoginApiResponse {
  const factory LoginApiResponse({
    required bool basarili,
    int? id,
    String? ad,
    String? soyad,
    String? okul,
    String? unvan,
    String? eposta,
    String? telefon,
    String? ekBilgi,
    String? token,
  }) = _LoginApiResponse;

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginApiResponseFromJson(json);
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

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required UserModel user,
    required String token,
    String? refreshToken,
    int? expiresIn,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    required String name,
    String? phone,
    String? school,
    String? branch,
    List<int>? registeredEventIds,
    List<int>? attendedEventIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
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