import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  final _dbName = "llas_costume_db.db";

  DBProvider._();
  static final DBProvider instance = DBProvider._();

  Database? _database;
  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async{
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    await deleteDatabase(path);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join("assets","db",_dbName));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    return await openDatabase(path);
  }
}