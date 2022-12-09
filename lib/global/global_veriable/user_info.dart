import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/db_model/db_model_user.dart';

class UserInfo extends ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;
  ClassUserModel? user = ClassUserModel(
      name: "",
      email: "",
      password: "",
      active: false,
      id: 23,
      registeredEvents: [31, 1231],
      attendedEvents: [1231, 21321]);
  Future<void> readUser() async {
    String mail = FirebaseAuth.instance.currentUser!.email.toString();

    final ref = databaseReference.collection("users").doc(mail).withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    user = docSnap.data(); // Convert to City object

    notifyListeners();
  }

  Future<void> writeUser({
    @required String? name,
    @required String? email,
    @required String? password,
    @required bool? active,
    @required int? id,
    @required List<int>? registeredEvents,
    @required List<int>? attendedEvents,
  }) async {
    final user = ClassUserModel(
        name: name,
        email: email,
        password: password,
        active: active,
        id: id,
        registeredEvents: registeredEvents,
        attendedEvents: attendedEvents);

    final docRef = databaseReference
        .collection("users")
        .withConverter(
          fromFirestore: ClassUserModel.fromFirestore,
          toFirestore: (ClassUserModel city, options) => city.toFirestore(),
        )
        .doc(user.email);
    await docRef.set(user);
  }
}

final userInfoConfig = ChangeNotifierProvider((ref) => UserInfo());
