import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return SizedBox(
      child: Column(children: [
        Text(
          "Welcome To",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: textColor,
              fontSize: 45),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "18. IB Day",
          style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Better Together",
          style: TextStyle(color: textColor, fontSize: 20),
        )
      ]),
    );
  }
}
