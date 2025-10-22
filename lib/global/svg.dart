import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../core/theme/app_colors.dart';

const String assetName = 'assets/svg/elipseregister.svg';
Widget elipse(double widthElipse) {
  return SvgPicture.asset(
    assetName,
    width: widthElipse,
    colorFilter: const ColorFilter.mode(AppColors.primaryLightBlue, BlendMode.srcIn),
  );
}


const String assetName3 = 'assets/svg/Vector.svg';

final Widget googleLogo = SvgPicture.asset(
  assetName3,
);
