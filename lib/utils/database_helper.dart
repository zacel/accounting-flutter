import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:six_jars/models/jar.dart';
import 'package:six_jars/models/contants.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String jarTable = 'jars_table';
  String colName = 'name';
  String colValue = 'value';
  String colPercent = 'percent';
  String colId = 'id';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/jars.db';
    //String file = File(path);
    //print(file);


    print(File(path));

    var jarsDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return jarsDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $jarTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colPercent TEXT, $colValue TEXT);');
    var v1 = await db.insert(jarTable, Jar(NECESITIES, "0", "0.55").toMap());
    print(v1);

    print("here is result of nec insert");
    //TODO pick a method to insert the init jars
    //TODO option (1) above just have one long series of sql statements // INSERT INTO $jarTable ($colName, $colPercent, $colValue) VALUES ($NECESITIES, "0", "0.55");
    //TODO option (2) above and below insert them into the db one by one as seperate statemnets
    //options
   await db.insert(jarTable, Jar(PLAY, "0", "0.10").toMap());
    await db.insert(jarTable, Jar(EDUCATION, "0", "0.10").toMap());
    await db.insert(jarTable, Jar(LONGTERMSAVINGS, "0", "0.10").toMap());
    await db.insert(jarTable, Jar(FINACIALFREEDOM, "0", "0.10").toMap());
    await db.insert(jarTable, Jar(GIVING, "0", "0.05").toMap());
  }

  Future<List<Map<String, dynamic>>> getJarsMapList() async {
    Database db = await this.database;
    var result = await db.query(jarTable);
    return result;
  }

  Future<int> _addJar(Jar jar) async {
    Database db = await this.database;
    var result = await db.insert(jarTable, jar.toMap());
    return result;
  }

  Future updateJar(Jar jar) async {
    Database db = await this.database;
    var result = await db.update(jarTable, jar.toMap(), where: '$colId = ?', whereArgs: [jar.id]);
    return result;
  }

  Future<List<Jar>> getJarList() async {
    var jarMapList = await getJarsMapList();
    int count = jarMapList.length;
    List<Jar> jarList = List<Jar>();
    for (int i = 0; i < count; i++) {
      jarList.add(Jar.fromMapObject(jarMapList[i]));
    }
    return jarList;
  }
}