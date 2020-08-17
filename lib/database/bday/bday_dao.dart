import 'dart:async';

import 'package:virgo/database/bday/bday_database.dart';
import 'package:virgo/models/friend.dart';

class BdayDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // Add a new birthday record
  Future<int> createBday(Friend friend) async {
    final db = await dbProvider.database;
    var result = db.insert(bdayTABLE, friend.toMap());
    return result;
  }

  // Get all birthdays
  Future<List<Friend>> getBdays({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(
          bdayTABLE,
          columns: columns,
          where: 'description LIKE ?',
          whereArgs: ['%$query%'],
        );
    } else {
      result = await db.query(bdayTABLE, columns: columns);
    }

    List<Friend> birthdays = result.isNotEmpty
        ? result.map((item) => Friend.fromMap(item)).toList()
        : [];
    return birthdays;
  }

  // Update birthdays
  Future<int> updateBday(Friend friend) async {
    final db = await dbProvider.database;

    var result = await db.update(
      bdayTABLE,
      friend.toMap(),
      where: 'id = ?',
      whereArgs: [friend.id],
    );

    return result;
  }

  // Delete birthday :(
  Future<int> deleteBday(String id) async {
    final db = await dbProvider.database;

    var result = await db.delete(
      bdayTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  // Delete ALL birthdays
  Future deleteAllBdays() async {
    final db = await dbProvider.database;
    var result = await db.delete(bdayTABLE);
    return result;
  }
}
