import 'dart:async';

import 'package:virgo/database/database.dart';
import 'package:virgo/models/friend.dart';

class BirthdayDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Add a new birthday record
  Future<int> createBirthday(Friend friend) async {
    final db = await dbProvider.database;
    var result = db.insert(birthdayTABLE, friend.toMap());
    return result;
  }

  // Get all birthdays
  Future<List<Friend>> getBirthdays(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(
          birthdayTABLE,
          columns: columns,
          where: 'description LIKE ?',
          whereArgs: ['%$query%'],
        );
    } else {
      result = await db.query(birthdayTABLE, columns: columns);
    }

    List<Friend> birthdays = result.isNotEmpty
        ? result.map((item) => Friend.fromMap(item)).toList()
        : [];
    return birthdays;
  }

  // Update birthdays
  Future<int> updateBirthday(Friend friend) async {
    final db = await dbProvider.database;

    var result = await db.update(
      birthdayTABLE,
      friend.toMap(),
      where: 'id = ?',
      whereArgs: [friend.id],
    );

    return result;
  }

  // Delete birthday :(
  Future<int> deleteBirthday(int id) async {
    final db = await dbProvider.database;

    var result = await db.delete(
      birthdayTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  // Delete ALL birthdays
  Future deleteAllBirthdays() async {
    final db = await dbProvider.database;
    var result = await db.delete(birthdayTABLE);
    return result;
  }
}
