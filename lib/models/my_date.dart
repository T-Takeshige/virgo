import 'package:flutter/material.dart';
import 'package:virgo/accessories/astrology_icons.dart';

class MyDate {
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  MyDate({this.month, this.day});

  String toString() => '${monthToString[this.month]} ${this.day.toString()}';

  DateTime toDateTime() {
    DateTime dateTime = DateTime(DateTime.now().year, this.month, this.day);
    if (dateTime.isBefore(DateTime.now()))
      dateTime = DateTime(DateTime.now().year + 1, this.month, this.day);
    return dateTime;
  }

  DateTime toDateTimeOfBefore(int subByMonth, int subByDay) {
    int month = this.month - (subByMonth % 12);
    if (month <= 0) month = 12 - month.abs();
    DateTime dateTime = DateTime(DateTime.now().year, month, this.day)
        .subtract(Duration(days: subByDay));
    if (dateTime.isBefore(DateTime.now()))
      dateTime =
          DateTime(DateTime.now().year + 1, dateTime.month, dateTime.day);
    return dateTime;
  }

  Icon toAstrologyIcon() {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19))
      return Icon(
        Astrology.aries,
        color: Colors.white,
      );
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20))
      return Icon(
        Astrology.taurus,
        color: Colors.white,
      );
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20))
      return Icon(
        Astrology.gemini,
        color: Colors.white,
      );
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22))
      return Icon(
        Astrology.cancer,
        color: Colors.white,
      );
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22))
      return Icon(
        Astrology.leo,
        color: Colors.white,
      );
    if ((month == 8 && day >= 22) || (month == 9 && day <= 22))
      return Icon(
        Astrology.virgo,
        color: Colors.white,
      );
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22))
      return Icon(
        Astrology.libra,
        color: Colors.white,
      );
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return Icon(
        Astrology.scorpio,
        color: Colors.white,
      );
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return Icon(
        Astrology.sagittarius,
        color: Colors.white,
      );
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return Icon(
        Astrology.capricorn,
        color: Colors.white,
      );
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return Icon(
        Astrology.aquarius,
        color: Colors.white,
      );
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20))
      return Icon(
        Astrology.pisces,
        color: Colors.white,
      );
    else
      return Icon(Icons.not_interested);
  }
}

String dateTimeToString(DateTime dateTime) =>
    '${monthToString[dateTime.month]} ${dateTime.day.toString()}';

Map<int, String> monthToString = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

Map<int, int> lengthOfMonth = {
  1: 31,
  2: 29,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};
