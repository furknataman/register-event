import 'package:flutter/cupertino.dart';

Container textContainer(String? text, TextStyle? textStyle, {double bottomPadding = 5}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text!,
        style: textStyle,
      ),
    );
  }