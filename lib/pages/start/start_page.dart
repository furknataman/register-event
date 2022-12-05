import 'package:flutter/material.dart';
import 'package:qr/global/svg.dart';
import 'package:qr/route_page/route_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  TextEditingController? controllerEmail;
  TextEditingController? controllerPassword;
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
                SizedBox(
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
                Container(
                  margin: const EdgeInsets.only(left: 90, right: 90),
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      loging(
                          labelText: "E-mail",
                          icon: Icons.alternate_email,
                          controller: controllerEmail),
                      loging(
                          labelText: "Password",
                          icon: Icons.lock_outline,
                          obs: true,
                          controller: controllerPassword),
                      FloatingActionButton.extended(
                        backgroundColor: const Color(0xff485FFF),
                        label: const Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const RoutePage()));
                        },
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          "I forgot my password",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                /*FloatingActionButton.extended(
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
                )*/
              ],
            ),
          ),
        ]),
      ),
    );
  }

  TextField loging(
      {@required String? labelText,
      IconData? icon,
      bool obs = false,
      @required TextEditingController? controller}) {
    // ignore: prefer_const_constructors
    return TextField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obs,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
          suffixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.white),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.white),
          )),
    );
  }
}
