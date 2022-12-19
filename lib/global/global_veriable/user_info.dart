import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/db_model/db_model_user.dart';

class UserInfo extends ChangeNotifier {
 final databaseReference = FirebaseFirestore.instance;
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  ClassUserModel? user = ClassUserModel(
      name: "Furkan",
      email: "furknataman@gmail.com",
      password: "1231231",
      active: false,
      id: 23,
      registeredEvents: [31, 1231],
      attendedEvents: [1231, 21321]);

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
  }) async {
    List<int>? addevent = user!.registeredEvents;
    addevent!.add(registeredEvents!);
    final ClassUserModel registerEvent = ClassUserModel(
        name: user!.name,
        email: user!.email,
        password: user!.password,
        active: user!.active,
        id: user!.id,
        registeredEvents: addevent,
        attendedEvents: user!.attendedEvents);

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
