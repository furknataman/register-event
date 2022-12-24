import 'package:cloud_firestore/cloud_firestore.dart';

class ClassUserModel {
  final String? name;
  final String? email;
  final String? password;
  final bool? active;
  final int? id;
  final List<int>? registeredEvents;
  final List<int>? attendedEvents;
  final List<Timestamp>? dateTimeList;

  ClassUserModel({
    this.name,
    this.email,
    this.password,
    this.active,
    this.id,
    this.registeredEvents,
    this.attendedEvents,
    this.dateTimeList,
  });

  factory ClassUserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ClassUserModel(
      name: data?['name'],
      email: data?['email'],
      password: data?['password'],
      active: data?['active'],
      id: data?['id'],
      registeredEvents: data?['registeredEvents'] is Iterable
          ? List.from(data?['registeredEvents'])
          : null,
      attendedEvents:
          data?['attendedEvents'] is Iterable ? List.from(data?['attendedEvents']) : null,
      dateTimeList:
          data?['dateTimeList'] is Iterable ? List.from(data?['dateTimeList']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (active != null) "active": active,
      if (id != null) "id": id,
      if (registeredEvents != null) "registeredEvents": registeredEvents,
      if (attendedEvents != null) "attendedEvents": attendedEvents,
      if (dateTimeList != null) "dateTimeList": dateTimeList,
    };
  }
}
