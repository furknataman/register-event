import 'package:flutter/material.dart';
import 'package:qr/global/svg.dart';
import 'package:qr/route_page/route_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff485FFF),
            Color(0xff0D175F),
          ],
        )),
        child: Stack(children: [
          Positioned(bottom: 0, right: 0, child: elipse),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                      style: TextStyle(
                          color: Colors.white, fontSize: 24, fontFamily: 'Raleway'),
                    )
                  ]),
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RoutePage()));
                  },
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      googleLogo,
                      const SizedBox(
                        width: 30,
                      ),
                      const Text("Sign-in With Google ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff131313),
                              fontSize: 22,
                              fontFamily: 'Raleway'))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Google sign-in is required for viewing and registering attending to the seminars.",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: 'Raleway'),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
