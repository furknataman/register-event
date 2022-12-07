import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final googleConfig = ChangeNotifierProvider((ref) => GoogleProvder());

class GoogleProvder extends ChangeNotifier {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future signUp({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      print("object");
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn() async {
    String userName = "furknataman@flutter.com"; //controllerEmail.text;
    String password = "1234567"; //controllerPassword.text;
    try {
      await _auth.signInWithEmailAndPassword(email: userName, password: password);

      print("object");
      return null;
    } on FirebaseAuthException catch (e) {
      print("Username or password incorrect");

      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}