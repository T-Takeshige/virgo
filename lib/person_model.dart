import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:virgo/my_date.dart';

class Person {
  String _name;
  MyDate _birthday;
  String notes;
  List<bool> notifyMe;

  Person(name, birthday) {
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

class Persons extends ChangeNotifier {
  final List<Person> _persons = [];
  UnmodifiableListView<Person> get persons => UnmodifiableListView(_persons);

  add(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  remove(Person person) {
    bool success = _persons.remove(person);
    if (success)
      notifyListeners();
    else
      print('Error: cannot find person to delete');
  }

  update(Person oldPerson, Person newPerson) {
    int index = _persons.indexOf(oldPerson);
    if (index != -1) {
      _persons[index] = newPerson;
      notifyListeners();
    } else
      print('Error: cannot find person to update');
  }

  sortFrom(DateTime today) {
    _persons.sort((a, b) {
      if (a.birthday.month == b.birthday.month &&
          a.birthday.day == b.birthday.day)
        return 0;
      else {
        DateTime a_datetime =
            DateTime(today.year, a.birthday.month, a.birthday.day);
        if (a_datetime.month == today.month && a_datetime.day == today.day)
          return 0;
        if (a_datetime.isBefore(today))
          a_datetime =
              DateTime(today.year + 1, a.birthday.month, a.birthday.day);

        DateTime b_datetime =
            DateTime(today.year, b.birthday.month, b.birthday.day);
        if (b_datetime.month == today.month && b_datetime.day == today.day)
          return 1;
        if (b_datetime.isBefore(today))
          b_datetime =
              DateTime(today.year + 1, b.birthday.month, b.birthday.day);

        if (a_datetime.isAfter(b_datetime))
          return 1;
        else
          return 0;
      }
    });
  }
}
