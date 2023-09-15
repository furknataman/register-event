import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final googleConfig = ChangeNotifierProvider((ref) => GoogleProvider());

class GoogleProvider extends ChangeNotifier {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
 // final FirebaseAuth _auth = FirebaseAuth.instance;
//  get user => _auth.currentUser;

  //SIGN UP METHOD
  /*Future signUp({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn() async {
    String userName = controllerEmail.text;
    String password = controllerPassword.text;
    try {
      await _auth.signInWithEmailAndPassword(email: userName, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      controllerPassword.text = "";
      toastMessage("Username or password is incorrect");

      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }*/
}

/*currentUser() async {
  String mail = FirebaseAuth.instance.currentUser!.email.toString();
  return mail;
}*/
