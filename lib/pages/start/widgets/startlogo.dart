import 'package:flutter/material.dart';
import 'package:qr/global/svg.dart';

class StartPageWidgets extends StatelessWidget {
  const StartPageWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(children: [
        const SizedBox(
          height: 55,
        ),
        const Text(
          "Welcome To",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 45,
              fontFamily: 'Raleway'),
        ),
        logo,
        const Text(
          "Theory of Knowledge",
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Raleway'),
        )
      ]),
    );
  }
}
