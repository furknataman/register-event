import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  // Primary brand color
  Color get appColor => const Color(0xFF4679B1);
  Color get unregister => brightness == Brightness.light
      ? const Color(0xffEB5757)
      : const Color.fromARGB(255, 144, 65, 65);
  // Secondary color – white for both modes to match request
  Color get mainColor => Colors.white;

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
