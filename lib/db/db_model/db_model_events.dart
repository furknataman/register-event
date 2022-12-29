import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModelEvents {
  final String? eventsCollentionName;
  final String? name;
  final String? description;
  final String? imageUrl;
  final bool? active;
  final int? id;
  final int? capacity;
  final List<String>? speakers;
  final Timestamp? timestamp;
  final DateTime? dateTime;
  final String? eventsLocation;
  final int? duration;
  final String? eventLocationlUrl;
  final int? participantsNumber;
  final String? key;

  ClassModelEvents(
      {this.duration,
      this.name,
      this.description,
      this.imageUrl,
      this.active,
      this.id,
      this.capacity,
      this.speakers,
      this.dateTime,
      this.timestamp,
      this.eventsCollentionName,
      this.eventLocationlUrl,
      this.eventsLocation,
      this.key,
      this.participantsNumber});

  factory ClassModelEvents.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClassModelEvents(
      name: data?['name'],
      duration: data?['duration'],
      key: data?['key'],
      description: data?['description'],
      imageUrl: data?['imageUrl'],
      active: data?['active'],
      eventLocationlUrl: data?['eventLocationlUrl'],
      participantsNumber: data?['participantsNumber'],
      eventsLocation: data?['eventsLocation'],
      id: data?['id'],
      eventsCollentionName: snapshot.id,
      timestamp: data?['timestamp'],
      dateTime: data?['timestamp'].toDate(),
      capacity: data?['capacity'],
      speakers: data?['speakers'] is Iterable ? List.from(data?['speakers']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (participantsNumber != null) "participantsNumber": participantsNumber,
      if (eventLocationlUrl != null) "eventLocationlUrl": eventLocationlUrl,
      if (eventsLocation != null) "eventsLocation": eventsLocation,
      if (name != null) "name": name,
      if (duration != null) "duration": duration,
      if (key != null) "key": key,
      if (timestamp != null) "timestamp": timestamp,
      if (description != null) "description": description,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (active != null) "active": active,
      if (id != null) "id": id,
      if (capacity != null) "capacity": capacity,
      if (speakers != null) "speakers": speakers,
    };
  }
}
