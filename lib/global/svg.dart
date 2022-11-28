import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

final String assetName = 'assets/svg/elipseregister.svg';
final Widget elipse = SvgPicture.asset(assetName, width: 450);

final String assetName2 = 'assets/svg/TOK.svg';

final Widget logo = SvgPicture.asset(
  assetName2,
  color: const Color(0xffFFFFFF),
);

final String assetName3 = 'assets/svg/Vector.svg';

final Widget googleLogo = SvgPicture.asset(
  assetName3,
);
