import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastMessage(String message,
    {int time = 2, ToastGravity gravity = ToastGravity.TOP}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: time,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
