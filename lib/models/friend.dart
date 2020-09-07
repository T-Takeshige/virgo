import 'package:equatable/equatable.dart';
import 'package:virgo/miscellaneous/schedule_notifications.dart';
import 'package:virgo/models/my_date.dart';

class Friend extends Equatable {
  final String _id;
  final String _name;
  final MyDate _birthday;
  final String notes;
  final int alertBirthdayId;
  // notification ID for the reminders, null if there are no notification
  final List<int> notifyMeId;

  Friend(
    this._id,
    this._name,
    this._birthday, {
    this.notes = '',
    this.alertBirthdayId,
    this.notifyMeId = const [null, null, null],
  });

  String get id => this._id;

  String get name => this._name;

  MyDate get birthday => this._birthday;

  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(
      data['id'],
      data['name'],
      MyDate(
        month: data['month'],
        day: data['day'],
      ),
      notes: data['notes'],
      alertBirthdayId: data['alertBirthdayId'],
      notifyMeId: [
        data['notifyDayId'],
        data['notifyWeekId'],
        data['notifyDayId'],
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'name': this.name,
      'month': this._birthday.month,
      'day': this._birthday.day,
      'notes': this.notes,
      'alertBirthdayId': this.alertBirthdayId,
      'notifyDayId': this.notifyMeId[0],
      'notifyWeekId': this.notifyMeId[1],
      'notifyMonthId': this.notifyMeId[2],
    };
  }

  Friend copyWith({
    String name,
    MyDate birthday,
    String notes,
    int alertBirthdayId,
    List<int> notifyMeId,
  }) {
    return Friend(
      this.id,
      name ?? this.name,
      birthday ?? this.birthday,
      notes: notes ?? this.notes,
      alertBirthdayId: alertBirthdayId ?? this.alertBirthdayId,
      notifyMeId: notifyMeId ?? List.from(this.notifyMeId),
    );
  }

  @override
  List<Object> get props =>
      [id, name, birthday, notes, alertBirthdayId, notifyMeId];

  @override
  String toString() =>
      'Friend: { id: $id, name: $name, birthday: ${birthday.toString()}, notes: $notes, alertBirthdayId: $alertBirthdayId, notifyMeId: $notifyMeId }';
}

List<Friend> sortFriends(List<Friend> list) {
  DateTime today = DateTime.now();
  list.sort((a, b) {
    if (a.birthday.month == b.birthday.month &&
        a.birthday.day == b.birthday.day)
      return 0;
    else {
      DateTime aDatetime =
          DateTime(today.year, a.birthday.month, a.birthday.day);
      if (aDatetime.month == today.month && aDatetime.day == today.day)
        return 0;
      if (aDatetime.isBefore(today))
        aDatetime = DateTime(today.year + 1, a.birthday.month, a.birthday.day);

      DateTime bDatetime =
          DateTime(today.year, b.birthday.month, b.birthday.day);
      if (bDatetime.month == today.month && bDatetime.day == today.day)
        return 1;
      if (bDatetime.isBefore(today))
        bDatetime = DateTime(today.year + 1, b.birthday.month, b.birthday.day);

      if (aDatetime.isAfter(bDatetime))
        return 1;
      else
        return 0;
    }
  });
  return list;
}

int makeBirthdayReminder(ScheduleNotifications notifications, String friendName,
    MyDate friendBirthday, String friendId,
    {int recency}) {
  if (recency == null) {
    return notifications.schedule(
      friendBirthday.toDateTime(),
      title: "It's $friendName's birthday!",
      body: "Wish them a happy birthday!",
      payload: friendId,
    );
  } else {
    String _makeNotificationTitle(String name, MyDate birthday, int index) {
      Map<int, String> recency = {
        0: 'in a day',
        1: 'in a week',
        2: 'in a month',
      };

      return "$name's birthday (${birthday.toString()}) is ${recency[index]}!";
    }

    DateTime notificationDate;
    if (recency == 0)
      notificationDate = friendBirthday.toDateTimeOfBefore(0, 1);
    else if (recency == 1)
      notificationDate = friendBirthday.toDateTimeOfBefore(0, 7);
    else if (recency == 2)
      notificationDate = friendBirthday.toDateTimeOfBefore(1, 0);
    return notifications.schedule(
      notificationDate,
      title: _makeNotificationTitle(friendName, friendBirthday, recency),
      body: 'Begin preparing something for them!',
      payload: friendId,
    );
  }
}
