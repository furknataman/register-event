import 'package:flutter/material.dart';

class StartPageWidgets extends StatelessWidget {
  const StartPageWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        const Text(
          "Welcome To",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 45,
              fontFamily: 'Raleway'),
        ),
        const SizedBox(
          height: 10,
        ),
        Image.asset(
          "assets/images/atc_icon.png",
          height: 90,
          color: Colors.white,
        ),
        const Text(
          "Autumn Teachers Conference",
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Raleway'),
        )
      ]),
    );
  }
}
