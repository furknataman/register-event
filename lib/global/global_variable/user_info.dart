import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../db/db_model/db_model_user.dart';

class UserInfo extends ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  ClassUserModel? user;

  Future<void> readUser() async {
    final ref = databaseReference.collection("users").doc(mail).withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    user = docSnap.data(); // Convert to City object

    notifyListeners();
  }

  Future<void> writeUser({
    @required int? registeredEvents,
    @required Timestamp? eventTime,
  }) async {
    List<int>? addEvent = user!.registeredEvents;
    addEvent!.add(registeredEvents!);
    List<Timestamp>? addEventTime = user!.dateTimeList;
    addEventTime!.add(eventTime!);
    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: addEvent,
        attendedEvents: user!.attendedEvents,
        dateTimeList: addEventTime);

    final docRef = databaseReference
        .collection("users")
        .withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, options) => city.toFirestore(),
        )
        .doc(mail);
    await docRef.set(registerEvent);
    readUser();
  }

  Future<void> writeAttend({
    @required int? registeredEvents,
  }) async {
    List<int>? addEvent = user!.attendedEvents;
    addEvent!.add(registeredEvents!);

    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: user!.registeredEvents,
        attendedEvents: addEvent,
        dateTimeList: user!.dateTimeList);

    final docRef = databaseReference
        .collection("users")
        .withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, options) => city.toFirestore(),
        )
        .doc(mail);
    await docRef.set(registerEvent);
    readUser();
  }

  Future<void> removeEvent({
    @required int? registeredEvents,
    @required Timestamp? eventTime,
  }) async {
    List<int>? addEvent = user!.registeredEvents;
    List<Timestamp>? addEventTime = user!.dateTimeList;
    addEvent!.removeWhere((item) => item == registeredEvents!);
    addEventTime!.removeWhere((item) => item == eventTime!);
    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: addEvent,
        attendedEvents: user!.attendedEvents,
        dateTimeList: addEventTime);

    final docRef = databaseReference
        .collection("users")
        .withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, options) => city.toFirestore(),
        )
        .doc(mail);
    await docRef.set(registerEvent);
    readUser();
  }
}

final userInfoConfig = ChangeNotifierProvider((ref) => UserInfo());
