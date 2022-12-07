import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String assetName = 'assets/svg/elipseregister.svg';
final Widget elipse = SvgPicture.asset(assetName, width: 450);

const String assetName2 = 'assets/svg/TOK.svg';

final Widget logo = SvgPicture.asset(
  assetName2,
  color: Colors.white,
);
final Widget logo2 = SvgPicture.asset(
  assetName2,
  width: 100,
  height: 100,
  color: const Color(0xff485FFF),
);

const String assetName3 = 'assets/svg/Vector.svg';

final Widget googleLogo = SvgPicture.asset(
  assetName3,
);

const String assetName4 = 'assets/svg/home.svg';

final Widget homeIcon = SvgPicture.asset(
  assetName4,
);

const String assetName5 = 'assets/svg/homeBold.svg';

final Widget homeIconBold = SvgPicture.asset(
  assetName5,
);
