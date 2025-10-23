import 'package:flutter/material.dart';
import 'package:autumn_conference/db/sharedPreferences/token_stroge.dart';
import 'package:autumn_conference/pages/start/start_page.dart';
import 'package:autumn_conference/features/home/presentation/pages/home_page.dart';

class AuthService {
  //Determine if the user is authenticated.
  /*handleAuthState() {
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
  }*/

  Widget loginwithApi() {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data != null) {
          return const HomePage();
        } else {
          return const StartPage();
        }
      },
    );
  }
}
