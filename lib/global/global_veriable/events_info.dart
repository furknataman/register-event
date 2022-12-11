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

  Future readEvents() async {
    final ref = databaseReference.collection("events").doc("lasdas").withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    event = docSnap.data(); // Convert to City object
    print(event!.dateTime!.hour);
    notifyListeners();
  }

  /*Future readAllevents() async {
    events = [];
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
      },
    );
    notifyListeners();
  }*/

  Future<void> writeEvents(
      {@required String? name,
      @required String? description,
      @required String? imageUrl,
      @required bool? active,
      @required int? id,
      @required int? capacity,
      @required List<String>? speakers,
      @required List<int>? attendedEvents,
      @required Timestamp? timestamp}) async {
    final user = ClassModelEvents(
      name: name,
      imageUrl: imageUrl,
      description: description,
      active: active,
      id: id,
      capacity: capacity,
      speakers: speakers,
      timestamp: timestamp,
    );

    final docRef = databaseReference
        .collection("events")
        .withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, options) => city.toFirestore(),
        )
        .doc("dasdas");
    await docRef.set(user);
  }
}

final GetEvents = FutureProvider<List>((ref) {
  List<ClassModelEvents> events = [];
  final databaseReference = FirebaseFirestore.instance;

  events = [];
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
    },
  );
  return events;
});

final eventsInfoConfig = ChangeNotifierProvider((ref) => EventsInfo());
