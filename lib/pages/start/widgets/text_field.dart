import 'package:flutter/material.dart';

import '../../../authentication/login_service.dart';


class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.getGoogle,
  });

  final GoogleProvider getGoogle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loginTextField(
            labelText: "E-mail",
            icon: Icons.alternate_email,
            controller: getGoogle.controllerEmail),
        loginTextField(
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
            "I forgot my password", // TODO add forgot password
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
      ],
    );
  }
}

TextField loginTextField(
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
