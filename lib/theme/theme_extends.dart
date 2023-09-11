import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get appColor => const Color(0xffe43c2f);
  Color get unregister => brightness == Brightness.light
      ? const Color(0xffEB5757)
      : const Color.fromARGB(255, 144, 65, 65);
  Color get mainColor =>
      brightness == Brightness.light ? const Color(0xffe43c2f) : const Color(0xff1E1E1E);

  List<Color> get cardColor => brightness == Brightness.light
      ? [
          const Color.fromRGBO(255, 255, 255, 1),
          const Color.fromRGBO(255, 255, 255, 0),
        ]
      : [
          const Color.fromRGBO(0, 0, 0, 1),
          const Color.fromRGBO(0, 0, 0, 0),
        ];

  Color get disable =>
      brightness == Brightness.light ? const Color(0xffE0E0E0) : const Color(0xff333333);
}
