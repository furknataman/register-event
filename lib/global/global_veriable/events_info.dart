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

  Future<void> writeNewEvent({
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
      key: event.key,
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
        .doc("eventnew2");
    await docRef.set(user);
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
      key: event.key,
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
      key: event.key,
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

List<ClassModelEvents> eventsinfo = [];

final getEventsList = FutureProvider<List>((ref) async {
  List<ClassModelEvents> events = [];
  eventsinfo = [];
  final databaseReference = FirebaseFirestore.instance;
  await databaseReference
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
        eventsinfo.add(element.data());
      }
      events;
      //print(events.first.dateTime);
    },
  );

  return events;
});

final getEvent = FutureProvider.family<ClassModelEvents, String>((ref, name) async {
  final databaseReference = FirebaseFirestore.instance;

  final ref = databaseReference.collection("events").doc(name).withConverter(
        fromFirestore: ClassModelEvents.fromFirestore,
        toFirestore: (ClassModelEvents city, _) => city.toFirestore(),
      );
  final docSnap = await ref.get();
  ClassModelEvents? event = docSnap.data(); // Convert to City object
  return event!;
});

final eventsInfoConfig = ChangeNotifierProvider((ref) => EventsInfo());
