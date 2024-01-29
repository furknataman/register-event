import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr/const/app_text.dart';

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
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 45, fontFamily: 'Raleway'),
        ),
        const SizedBox(
          height: 10,
        ),
        SvgPicture.asset(
          'assets/svg/TOK.svg',
          height: 100,
          width: 100,
        ),
        const Text(
          ProjectText.appDescription,
          style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Raleway'),
        )
      ]),
    );
  }
}
