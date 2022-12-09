import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModelEvents {
  final String? name;
  final String? description;
  final String? imageUrl;
  final bool? active;
  final int? id;
  final int? capacity;
  final List<String>? speakers;

  final int? dateTime;

  ClassModelEvents(
      {this.name,
      this.description,
      this.imageUrl,
      this.active,
      this.id,
      this.capacity,
      this.speakers,
      this.dateTime});

  factory ClassModelEvents.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClassModelEvents(
      name: data?['name'],
      description: data?['description'],
      imageUrl: data?['imageUrl'],
      active: data?['active'],
      id: data?['id'],
      dateTime: data?['dateTime'] is Iterable ? (data?['dateTime']).toDate() : null,
      capacity: data?['capacity'],
      speakers: data?['speakers'] is Iterable ? List.from(data?['speakers']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (dateTime != null) "dateTime": dateTime,
      if (description != null) "email": description,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (active != null) "active": active,
      if (id != null) "id": id,
      if (capacity != null) "capacity": capacity,
      if (speakers != null) "speakers": speakers,
    };
  }
}
