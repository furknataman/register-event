import 'package:intl/intl.dart';

class ClassTime {
  final String? year;
  final String? day;
  final String? month;
  final String? clock;
  final String? shortMonth;

  ClassTime({this.year, this.day, this.month, this.clock, this.shortMonth});
}

ClassTime classConverter(DateTime dateTime) {
  ClassTime? time = ClassTime(
      year: DateFormat.y().format(dateTime),
      clock: DateFormat.Hm().format(dateTime),
      shortMonth: DateFormat.LLL().format(dateTime),
      month: DateFormat.LLLL().format(dateTime),
      day: DateFormat.d().format(dateTime));
  return time;
}
