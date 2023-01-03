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
    List<int>? addevent = user!.registeredEvents;
    addevent!.add(registeredEvents!);
    List<Timestamp>? addEventTime = user!.dateTimeList;
    addEventTime!.add(eventTime!);
    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: addevent,
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
    List<int>? addevent = user!.attendedEvents;
    addevent!.add(registeredEvents!);

    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: user!.registeredEvents,
        attendedEvents: addevent,
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
    List<int>? addevent = user!.registeredEvents;
    List<Timestamp>? addEventTime = user!.dateTimeList;
    addevent!.removeWhere((item) => item == registeredEvents!);
    addEventTime!.removeWhere((item) => item == eventTime!);
    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: addevent,
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
