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
