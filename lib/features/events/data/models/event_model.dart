import '../../domain/entities/event.dart';

class EventModel {
  final int id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String speaker;
  final String? speakerTitle;
  final String? imageUrl;
  final int maxParticipants;
  final int currentParticipants;
  final bool isRegistered;
  final bool isAttended;
  final List<String>? tags;
  final String? materials;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.speaker,
    this.speakerTitle,
    this.imageUrl,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isRegistered,
    required this.isAttended,
    this.tags,
    this.materials,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String,
      speaker: json['speaker'] as String,
      speakerTitle: json['speaker_title'] as String?,
      imageUrl: json['image_url'] as String?,
      maxParticipants: json['max_participants'] as int,
      currentParticipants: json['current_participants'] as int,
      isRegistered: json['is_registered'] as bool,
      isAttended: json['is_attended'] as bool,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      materials: json['materials'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'speaker': speaker,
      'speaker_title': speakerTitle,
      'image_url': imageUrl,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'is_registered': isRegistered,
      'is_attended': isAttended,
      'tags': tags,
      'materials': materials,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// Legacy model mapping - adapts old ClassModelPresentation to new structure
class LegacyEventModel {
  final int? id;
  final String? baslik;
  final String? aciklama;
  final String? sunumTarihi;
  final String? sunumSaati;
  final String? bitisSaati;
  final String? sunumYeri;
  final String? sunucu;
  final String? sunucuUnvani;
  final String? resimUrl;
  final int? maxKatilimci;
  final int? mevcutKatilimci;
  final bool? kayitli;
  final bool? katildi;
  final String? etiketler;
  final String? materyaller;

  const LegacyEventModel({
    this.id,
    this.baslik,
    this.aciklama,
    this.sunumTarihi,
    this.sunumSaati,
    this.bitisSaati,
    this.sunumYeri,
    this.sunucu,
    this.sunucuUnvani,
    this.resimUrl,
    this.maxKatilimci,
    this.mevcutKatilimci,
    this.kayitli,
    this.katildi,
    this.etiketler,
    this.materyaller,
  });

  factory LegacyEventModel.fromJson(Map<String, dynamic> json) {
    return LegacyEventModel(
      id: json['id'] as int?,
      baslik: json['baslik'] as String?,
      aciklama: json['aciklama'] as String?,
      sunumTarihi: json['sunumTarihi'] as String?,
      sunumSaati: json['sunumSaati'] as String?,
      bitisSaati: json['bitisSaati'] as String?,
      sunumYeri: json['sunumYeri'] as String?,
      sunucu: json['sunucu'] as String?,
      sunucuUnvani: json['sunucuUnvani'] as String?,
      resimUrl: json['resimUrl'] as String?,
      maxKatilimci: json['maxKatilimci'] as int?,
      mevcutKatilimci: json['mevcutKatilimci'] as int?,
      kayitli: json['kayitli'] as bool?,
      katildi: json['katildi'] as bool?,
      etiketler: json['etiketler'] as String?,
      materyaller: json['materyaller'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'aciklama': aciklama,
      'sunumTarihi': sunumTarihi,
      'sunumSaati': sunumSaati,
      'bitisSaati': bitisSaati,
      'sunumYeri': sunumYeri,
      'sunucu': sunucu,
      'sunucuUnvani': sunucuUnvani,
      'resimUrl': resimUrl,
      'maxKatilimci': maxKatilimci,
      'mevcutKatilimci': mevcutKatilimci,
      'kayitli': kayitli,
      'katildi': katildi,
      'etiketler': etiketler,
      'materyaller': materyaller,
    };
  }
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
