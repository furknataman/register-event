// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginApiResponseImpl _$$LoginApiResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginApiResponseImpl(
      basarili: json['basarili'] as bool,
      id: (json['id'] as num?)?.toInt(),
      ad: json['ad'] as String?,
      soyad: json['soyad'] as String?,
      okul: json['okul'] as String?,
      unvan: json['unvan'] as String?,
      eposta: json['eposta'] as String?,
      telefon: json['telefon'] as String?,
      ekBilgi: json['ekBilgi'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$LoginApiResponseImplToJson(
        _$LoginApiResponseImpl instance) =>
    <String, dynamic>{
      'basarili': instance.basarili,
      'id': instance.id,
      'ad': instance.ad,
      'soyad': instance.soyad,
      'okul': instance.okul,
      'unvan': instance.unvan,
      'eposta': instance.eposta,
      'telefon': instance.telefon,
      'ekBilgi': instance.ekBilgi,
      'token': instance.token,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      school: json['school'] as String?,
      branch: json['branch'] as String?,
      registeredEventIds: (json['registeredEventIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      attendedEventIds: (json['attendedEventIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'school': instance.school,
      'branch': instance.branch,
      'registeredEventIds': instance.registeredEventIds,
      'attendedEventIds': instance.attendedEventIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
