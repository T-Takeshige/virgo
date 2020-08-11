import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:virgo/models/my_date.dart';

class Friend {
  String _name;
  MyDate _birthday;
  String notes;
  List<bool> notifyMe;

  Friend(name, birthday) {
    this._name = name;
    this._birthday = birthday;
    this.notes = '';
    this.notifyMe = [false, false, false];
  }

  String get name {
    return _name;
  }

  set name(String name) {
    this._name = name;
  }

  MyDate get birthday {
    return _birthday;
  }

  set birthday(MyDate birthday) {
    this._birthday = birthday;
  }
}

class FriendsList extends ChangeNotifier {
  final List<Friend> _list = [];
  UnmodifiableListView<Friend> get friends => UnmodifiableListView(_list);

  add(Friend friend) {
    _list.add(friend);
    notifyListeners();
  }

  remove(Friend friend) {
    bool success = _list.remove(friend);
    if (success)
      notifyListeners();
    else
      print('Error: cannot find Friend to delete');
  }

  update(Friend oldFriend, Friend newFriend) {
    int index = _list.indexOf(oldFriend);
    if (index != -1) {
      _list[index] = newFriend;
      notifyListeners();
    } else
      print('Error: cannot find Friend to update');
  }

  bool isUniqueName(String name) {
    for (int i = 0; i < _list.length; i++)
      if (_list[i].name == name) return false;

    return true;
  }

  updateName(Friend friend, String name) {
    int f = _list.indexOf(friend);
    _list[f].name = name;
    notifyListeners();
  }

  updateBirthday(Friend friend, DateTime birthday) {
    int f = _list.indexOf(friend);
    _list[f].birthday = MyDate(month: birthday.month, day: birthday.day);
    notifyListeners();
  }

  updateNotes(Friend friend, String notes) {
    int f = _list.indexOf(friend);
    _list[f].notes = notes;
    notifyListeners();
  }

  updateNotifyMe(Friend friend, int index) {
    if (index < 0 || index > 3) {
      print('Error: index out of bounds: notifyMe list');
    } else {
      int f = _list.indexOf(friend);
      _list[f].notifyMe[index] ^= true;
      notifyListeners();
    }
  }

  sortFrom(DateTime today) {
    _list.sort((a, b) {
      if (a.birthday.month == b.birthday.month &&
          a.birthday.day == b.birthday.day)
        return 0;
      else {
        DateTime aDatetime =
            DateTime(today.year, a.birthday.month, a.birthday.day);
        if (aDatetime.month == today.month && aDatetime.day == today.day)
          return 0;
        if (aDatetime.isBefore(today))
          aDatetime =
              DateTime(today.year + 1, a.birthday.month, a.birthday.day);

        DateTime bDatetime =
            DateTime(today.year, b.birthday.month, b.birthday.day);
        if (bDatetime.month == today.month && bDatetime.day == today.day)
          return 1;
        if (bDatetime.isBefore(today))
          bDatetime =
              DateTime(today.year + 1, b.birthday.month, b.birthday.day);

        if (aDatetime.isAfter(bDatetime))
          return 1;
        else
          return 0;
      }
    });
  }
}
