import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? name;
  final String? email;
  final String? password;
  final bool? capital;
  final int? id;
  final List<int>? registeredEvents;
  final List<int>? attendedEvents;

  User({
    this.name,
    this.email,
    this.password,
    this.capital,
    this.id,
    this.registeredEvents,
    this.attendedEvents,
  });

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      name: data?['name'],
      email: data?['email'],
      password: data?['password'],
      capital: data?['capital'],
      id: data?['id'],
      registeredEvents: data?['registeredEvents'] is Iterable
          ? List.from(data?['registeredEvents'])
          : null,
      attendedEvents:
          data?['attendedEvents'] is Iterable ? List.from(data?['attendedEvents']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (capital != null) "capital": capital,
      if (id != null) "id": id,
      if (registeredEvents != null) "registeredEvents": registeredEvents,
      if (attendedEvents != null) "attendedEvents": attendedEvents,
    };
  }
}
