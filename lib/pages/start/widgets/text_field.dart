import 'package:flutter/material.dart';
import 'package:autumn_conference/db/sharedPreferences/token_stroge.dart';
import 'package:autumn_conference/notification/toast_message/toast_message.dart';
import 'package:autumn_conference/pages/route_page/route_page.dart';
import 'package:autumn_conference/services/service.dart';
import '../../../authentication/login_service.dart';
import 'package:autumn_conference/l10n/app_localizations.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
    required this.getGoogle,
  });

  final GoogleProvider getGoogle;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPasswordObscured = ValueNotifier<bool>(true);

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
      toastMessage(AppLocalizations.of(context)!.loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loginTextField(
            labelText: AppLocalizations.of(context)!.email,
            icon: Icons.alternate_email,
            controller: getGoogle.controllerEmail),
        loginTextField(
            labelText: AppLocalizations.of(context)!.password,
            icon: Icons.lock_outline,
            obs: true,
            controller: getGoogle.controllerPassword),
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
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 120,
                        height: 46,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 190, 51, 41),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ));
            },
          ),
        ),
      ],
    );
  }

  Widget loginTextField({
    required String? labelText,
    IconData? icon,
    bool obs = false,
    required TextEditingController? controller,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordObscured,
      builder: (context, isObscured, child) {
        return TextField(
          controller: controller,
          keyboardType: obs ? TextInputType.visiblePassword : TextInputType.text,
          obscureText: obs ? isObscured : false,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            suffixIcon: obs
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _isPasswordObscured.value = !isObscured;
                    },
                  )
                : Icon(
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
            ),
          ),
        );
      },
    );
  }
}
