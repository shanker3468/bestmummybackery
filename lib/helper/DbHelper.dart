import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Future initDb() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "bestmummy.db");

    final exist = await databaseExists(path);

    if (exist) {
      print('database already creaed');
      return;
    } /*else {

    }*/
    print('database already creaedtttttttttttt');
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {

    }
    ByteData data =
    await rootBundle.load(join("assets/databases", "bestmummy.db"));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);

    print("db Copied");
    await openDatabase(path);

    /*  Database db = await openDatabase(path, readOnly: true);
    print(db.toString());

     var list = await db.rawQuery('SELECT * FROM IN_MOB_USER_MASTER');
    print(list.toList().toString());

    // Close the database
    await db.close();*/
  }
}
