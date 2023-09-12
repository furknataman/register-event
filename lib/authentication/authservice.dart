import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr/db/db_model/token_response_model.dart';
import 'package:qr/global/global_variable/global.dart';
import 'package:qr/pages/start/start_page.dart';
import 'package:qr/pages/route_page/route_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const RoutePage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const StartPage();
          }
        });
  }
}
