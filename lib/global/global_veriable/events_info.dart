import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';

class EventsInfo extends ChangeNotifier {
  List<ClassModelEvents> events = [];
  final databaseReference = FirebaseFirestore.instance;
  ClassModelEvents? event = ClassModelEvents(
      name: " ",
      description: "açıklama",
      imageUrl: "wwww",
      active: true,
      id: 4,
      capacity: 20,
      speakers: ["123", "123"],
      timestamp: Timestamp.now());

  Future readEvents(String eventName) async {
    final ref = databaseReference.collection("events").doc(eventName).withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    event = docSnap.data(); // Convert to City object
    // print(event!.dateTime);
    notifyListeners();
  }

  Future<void> writeEvents({
    @required ClassModelEvents? event,
  }) async {
    int? totalParticipantsNumber = event!.participantsNumber! + 1;
    final user = ClassModelEvents(
      eventLocationlUrl: event.eventLocationlUrl,
      eventsLocation: event.eventsLocation,
      name: event.name,
      imageUrl: event.imageUrl,
      description: event.description,
      active: event.active,
      id: event.id,
      participantsNumber: totalParticipantsNumber,
      capacity: event.capacity,
      speakers: event.speakers,
      timestamp: event.timestamp,
      duration: event.duration,
    );

    final docRef = databaseReference
        .collection("events")
        .withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, options) => city.toFirestore(),
        )
        .doc(event.eventsCollentionName);
    await docRef.set(user);
  }

  Future<void> removeEventUser({
    @required ClassModelEvents? event,
  }) async {
    event!.participantsNumber! + 1;
    final user = ClassModelEvents(
      eventLocationlUrl: event.eventLocationlUrl,
      eventsLocation: event.eventsLocation,
      name: event.name,
      imageUrl: event.imageUrl,
      description: event.description,
      active: event.active,
      id: event.id,
      participantsNumber: event.participantsNumber,
      capacity: event.capacity,
      speakers: event.speakers,
      timestamp: event.timestamp,
      duration: event.duration,
    );

    final docRef = databaseReference
        .collection("events")
        .withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, options) => city.toFirestore(),
        )
        .doc(event.eventsCollentionName);
    await docRef.set(user);
  }
}


final getEventsList = FutureProvider<List>((ref) {
  List<ClassModelEvents> events = [];
  final databaseReference = FirebaseFirestore.instance;
  databaseReference
      .collection("events")
      .withConverter(
        fromFirestore: ClassModelEvents.fromFirestore,
        toFirestore: (ClassModelEvents city, _) => city.toFirestore(),
      )
      .get()
      .then(
    (value) {
      for (var element in value.docs) {
        events.add(element.data());
      }
      //print(events.first.dateTime);
    },
  );
  return events;
});

final eventsInfoConfig = ChangeNotifierProvider((ref) => EventsInfo());
