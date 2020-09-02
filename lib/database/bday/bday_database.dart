import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final bdayTABLE = 'Birthdays';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await createDatabase();
      return _database;
    }
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Virgo.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
      onUpgrade: onUpgrade,
    );
    return database;
  }
}

// Optional, for version control
void onUpgrade(Database database, int oldVersion, int newVersion) {}

void initDB(Database database, int version) async {
  await database.execute('CREATE TABLE $bdayTABLE ('
      'id TEXT PRIMARY KEY, '
      'name TEXT, '
      'month INTEGER, '
      'day INTEGER, '
      'notes TEXT, '
      'alertBirthdayId Integer, '
      'notifyDayId INTEGER, '
      'notifyWeekId INTEGER, '
      'notifyMonthId INTEGER'
      ')');
}
