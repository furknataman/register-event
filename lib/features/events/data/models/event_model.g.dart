// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      speaker: json['speaker'] as String,
      speakerTitle: json['speaker_title'] as String?,
      imageUrl: json['image_url'] as String?,
      maxParticipants: (json['max_participants'] as num).toInt(),
      currentParticipants: (json['current_participants'] as num).toInt(),
      isRegistered: json['is_registered'] as bool,
      isAttended: json['is_attended'] as bool,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      materials: json['materials'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'location': instance.location,
      'speaker': instance.speaker,
      'speaker_title': instance.speakerTitle,
      'image_url': instance.imageUrl,
      'max_participants': instance.maxParticipants,
      'current_participants': instance.currentParticipants,
      'is_registered': instance.isRegistered,
      'is_attended': instance.isAttended,
      'tags': instance.tags,
      'materials': instance.materials,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$LegacyEventModelImpl _$$LegacyEventModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LegacyEventModelImpl(
      id: (json['id'] as num?)?.toInt(),
      baslik: json['baslik'] as String?,
      aciklama: json['aciklama'] as String?,
      sunumTarihi: json['sunumTarihi'] as String?,
      sunumSaati: json['sunumSaati'] as String?,
      bitisSaati: json['bitisSaati'] as String?,
      sunumYeri: json['sunumYeri'] as String?,
      sunucu: json['sunucu'] as String?,
      sunucuUnvani: json['sunucuUnvani'] as String?,
      resimUrl: json['resimUrl'] as String?,
      maxKatilimci: (json['maxKatilimci'] as num?)?.toInt(),
      mevcutKatilimci: (json['mevcutKatilimci'] as num?)?.toInt(),
      kayitli: json['kayitli'] as bool?,
      katildi: json['katildi'] as bool?,
      etiketler: json['etiketler'] as String?,
      materyaller: json['materyaller'] as String?,
    );

Map<String, dynamic> _$$LegacyEventModelImplToJson(
        _$LegacyEventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baslik': instance.baslik,
      'aciklama': instance.aciklama,
      'sunumTarihi': instance.sunumTarihi,
      'sunumSaati': instance.sunumSaati,
      'bitisSaati': instance.bitisSaati,
      'sunumYeri': instance.sunumYeri,
      'sunucu': instance.sunucu,
      'sunucuUnvani': instance.sunucuUnvani,
      'resimUrl': instance.resimUrl,
      'maxKatilimci': instance.maxKatilimci,
      'mevcutKatilimci': instance.mevcutKatilimci,
      'kayitli': instance.kayitli,
      'katildi': instance.katildi,
      'etiketler': instance.etiketler,
      'materyaller': instance.materyaller,
    };
