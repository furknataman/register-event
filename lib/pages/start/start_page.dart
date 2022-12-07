import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/global/svg.dart';
import '../../authentication/login_serice.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getGoogle = ref.watch<GoogleProvder>(googleConfig);
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
                          controller: getGoogle.controllerEmail),
                      loging(
                          labelText: "Password",
                          icon: Icons.lock_outline,
                          obs: true,
                          controller: getGoogle.controllerPassword),
                      InkWell(
                          onTap: () {
                            getGoogle.signIn();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 120,
                            height: 46,
                            decoration: const BoxDecoration(
                                color: Color(0xff485FFF),
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
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
