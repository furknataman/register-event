import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/event.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    required String location,
    required String speaker,
    @JsonKey(name: 'speaker_title') String? speakerTitle,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'max_participants') required int maxParticipants,
    @JsonKey(name: 'current_participants') required int currentParticipants,
    @JsonKey(name: 'is_registered') required bool isRegistered,
    @JsonKey(name: 'is_attended') required bool isAttended,
    List<String>? tags,
    String? materials,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

// Legacy model mapping - adapts old ClassModelPresentation to new structure
@freezed
class LegacyEventModel with _$LegacyEventModel {
  const factory LegacyEventModel({
    int? id,
    String? baslik,
    String? aciklama,
    String? sunumTarihi,
    String? sunumSaati,
    String? bitisSaati,
    String? sunumYeri,
    String? sunucu,
    String? sunucuUnvani,
    String? resimUrl,
    int? maxKatilimci,
    int? mevcutKatilimci,
    bool? kayitli,
    bool? katildi,
    String? etiketler,
    String? materyaller,
  }) = _LegacyEventModel;

  factory LegacyEventModel.fromJson(Map<String, dynamic> json) =>
      _$LegacyEventModelFromJson(json);
}

extension EventModelExtension on EventModel {
  Event toDomain() {
    return Event(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      speaker: speaker,
      speakerTitle: speakerTitle,
      imageUrl: imageUrl,
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
      isRegistered: isRegistered,
      isAttended: isAttended,
      tags: tags,
      materials: materials,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension EventDomainExtension on Event {
  EventModel toModel() {
    return EventModel(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      speaker: speaker,
      speakerTitle: speakerTitle,
      imageUrl: imageUrl,
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
      isRegistered: isRegistered,
      isAttended: isAttended,
      tags: tags,
      materials: materials,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension LegacyEventModelExtension on LegacyEventModel {
  Event toDomain() {
    return Event(
      id: id ?? 0,
      title: baslik ?? '',
      description: aciklama ?? '',
      startTime: _parseDateTime(sunumTarihi, sunumSaati),
      endTime: _parseDateTime(sunumTarihi, bitisSaati),
      location: sunumYeri ?? '',
      speaker: sunucu ?? '',
      speakerTitle: sunucuUnvani,
      imageUrl: resimUrl,
      maxParticipants: maxKatilimci ?? 0,
      currentParticipants: mevcutKatilimci ?? 0,
      isRegistered: kayitli ?? false,
      isAttended: katildi ?? false,
      tags: etiketler?.split(',').map((e) => e.trim()).toList(),
      materials: materyaller,
      createdAt: null,
      updatedAt: null,
    );
  }

  DateTime _parseDateTime(String? date, String? time) {
    try {
      if (date == null || time == null) {
        return DateTime.now();
      }
      
      // Assuming date format: "dd.MM.yyyy" and time format: "HH:mm"
      final dateParts = date.split('.');
      final timeParts = time.split(':');
      
      if (dateParts.length == 3 && timeParts.length == 2) {
        return DateTime(
          int.parse(dateParts[2]), // year
          int.parse(dateParts[1]), // month
          int.parse(dateParts[0]), // day
          int.parse(timeParts[0]), // hour
          int.parse(timeParts[1]), // minute
        );
      }
    } catch (e) {
      // If parsing fails, return current time
    }
    return DateTime.now();
  }
}