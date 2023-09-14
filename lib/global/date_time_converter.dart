import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassTime {
  final String? year;
  final String? day;
  final String? month;
  final String? clock;
  final String? shortMonth;
  final String? endTime;

  ClassTime({this.year, this.day, this.month, this.clock, this.shortMonth, this.endTime});
}

ClassTime classConverter(DateTime dateTime, int minutes) {
  DateTime parseDate = DateTime.parse(dateTime.toString());
  DateTime addDuration = parseDate.add(Duration(minutes: minutes));
  ClassTime? time = ClassTime(
      year: DateFormat.y().format(dateTime),
      clock: DateFormat.Hm().format(dateTime),
      shortMonth: DateFormat.LLL().format(dateTime),
      month: DateFormat.LLLL().format(dateTime),
      endTime: DateFormat.Hm().format(addDuration),
      day: DateFormat.d().format(dateTime));
  return time;
}

String dateConvert(String firstTime, String duration) {
  List<String> timeParts = firstTime.split(':');
  TimeOfDay oldTime =
      TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));

  TimeOfDay newTime = oldTime.replacing(minute: oldTime.minute + int.parse(duration));

  if (newTime.minute >= 60) {
    newTime = newTime.replacing(hour: newTime.hour + 1, minute: newTime.minute - 60);
  }

  String formattedOldTime =
      "${oldTime.hour.toString().padLeft(2, '0')}:${oldTime.minute.toString().padLeft(2, '0')}";

  String formattedNewTime =
      "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";

  String combinedTime = "$formattedOldTime - $formattedNewTime";
  return combinedTime;
}
