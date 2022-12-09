import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/db/db_model/db_model_events.dart';

class EventsInfo extends ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;
  ClassModelEvents? events = ClassModelEvents(
      name: " ",
      description: "açıklama",
      imageUrl: "wwww",
      active: true,
      id: 4,
      capacity: 20,
      speakers: ["123", "123"],
      dateTime: DateTime.now()) ;

  Future readEvents() async {
    final ref = databaseReference.collection("events").doc("lasdas").withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    events = docSnap.data(); // Convert to City object
    print(events!.dateTime);
    print(Timestamp.fromDate(DateTime.now()));
    notifyListeners();
  }

  Future<void> writeEvents(
      {@required String? name,
      @required String? description,
      @required String? imageUrl,
      @required bool? active,
      @required int? id,
      @required int? capacity,
      @required List<String>? speakers,
      @required List<int>? attendedEvents,
      @required DateTime? dateTime}) async {
    final user = ClassModelEvents(
      name: name,
      imageUrl: imageUrl,
      description: description,
      active: active,
      id: id,
      capacity: capacity,
      speakers: speakers,
      dateTime: dateTime,
    );

    final docRef = databaseReference
        .collection("events")
        .withConverter(
          fromFirestore: ClassModelEvents.fromFirestore,
          toFirestore: (ClassModelEvents city, options) => city.toFirestore(),
        )
        .doc("lasdas");
    await docRef.set(user);
  }
}

final eventsInfoConfig = ChangeNotifierProvider((ref) => EventsInfo());
