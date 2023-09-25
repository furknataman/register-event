import 'package:flutter/material.dart';
import 'package:qr/db/sharedPreferences/token_stroge.dart';
import 'package:qr/notification/toast_message/toast_message.dart';
import 'package:qr/pages/route_page/route_page.dart';
import 'package:qr/services/service.dart';
import '../../../authentication/login_service.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
    required this.getGoogle,
  });

  final GoogleProvider getGoogle;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  Future<void> _handleLogin(BuildContext context) async {
    _isLoading.value = true;

    await WebService().login(
        getGoogle.controllerEmail.text,
        getGoogle
            .controllerPassword.text); //.login("furkan.ataman@eyuboglu.k12.tr", "12345");

    //
    String? localToken = await getToken();
    _isLoading.value = false;

    if (localToken != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const RoutePage()));
    } else {
      toastMessage("Username or password is incorrect");
    }
  }

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
        /* InkWell(
            onTap: () {
              //  getGoogle.signIn();
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
            )),*/
        SizedBox(
          height: 33,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        _handleLogin(context);
                        //  getGoogle.signIn();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 120,
                        height: 46,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 190, 51, 41),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ));
            },
          ),
        ),
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
