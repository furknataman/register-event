import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({
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
              fontSize: 45),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "18. IB Day",
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          "Better Together",
          style: TextStyle(color: Colors.white, fontSize: 20),
        )
      ]),
    );
  }
}
