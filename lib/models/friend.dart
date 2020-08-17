import 'package:equatable/equatable.dart';
import 'package:virgo/models/my_date.dart';

class Friend extends Equatable {
  final String _id;
  final String _name;
  final MyDate _birthday;
  final String notes;
  final List<bool> notifyMe;

  Friend(this._id, this._name, this._birthday,
      {this.notes = '', this.notifyMe = const [false, false, false]});

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
        notifyMe: [
          data['notifyDay'] == 1 ? true : false,
          data['notifyWeek'] == 1 ? true : false,
          data['notifyMonth'] == 1 ? true : false,
        ]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'name': this.name,
      'month': this._birthday.month,
      'day': this._birthday.day,
      'notes': this.notes,
      'notifyDay': this.notifyMe[0] ? 1 : 0,
      'notifyWeek': this.notifyMe[1] ? 1 : 0,
      'notifyMonth': this.notifyMe[2] ? 1 : 0,
    };
  }

  Friend copyWith(
      {String name, MyDate birthday, String notes, List<bool> notifyMe}) {
    return Friend(
      this.id,
      name ?? this.name,
      birthday ?? this.birthday,
      notes: notes ?? this.notes,
      notifyMe: notifyMe ?? this.notifyMe,
    );
  }

  @override
  List<Object> get props => [id, name, birthday, notes, notifyMe];

  @override
  String toString() =>
      'Friend: { id: $id, name: $name, birthday: ${birthday.toString()}, notes: $notes, notifyMe: $notifyMe }';
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
