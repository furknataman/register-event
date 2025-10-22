import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required int id,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String location,
    required String speaker,
    String? speakerTitle,
    String? imageUrl,
    required int maxParticipants,
    required int currentParticipants,
    required bool isRegistered,
    required bool isAttended,
    List<String>? tags,
    String? materials,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Event;
}