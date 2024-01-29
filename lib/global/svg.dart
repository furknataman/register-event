import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String assetName = 'assets/svg/elipseregister.svg';
Widget elipse(double widthElipse) {
  return SvgPicture.asset(
    assetName,
    width: widthElipse,
  );
}

const String assetName3 = 'assets/svg/Vector.svg';

final Widget googleLogo = SvgPicture.asset(
  assetName3,
);
