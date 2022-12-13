import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class ClassTime {
  final String? year;
  final String? day;
  final String? month;
  final String? clock;
  final String? shortMonth;
  final String? endTime;

  ClassTime({this.year, this.day, this.month, this.clock, this.shortMonth,this.endTime});
}

ClassTime classConverter(DateTime dateTime, int minutes) {
  DateTime parseDate=DateTime.parse(dateTime.toString());
  DateTime addDuration = parseDate.add(Duration(minutes: minutes));
  ClassTime? time = ClassTime(
      year: DateFormat.y().format(dateTime),
      clock: DateFormat.Hm().format(dateTime),
      shortMonth: DateFormat.LLL().format(dateTime),
      month: DateFormat.LLLL().format(dateTime),
      endTime:  DateFormat.Hm().format(addDuration) ,
      day: DateFormat.d().format(dateTime));
  return time;
}
