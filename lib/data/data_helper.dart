import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/brand_model.dart';

abstract class TableElement{
  int id;
  final String tableName;
  TableElement(this.id, this.tableName);
  void createTable(Database db);
  Map<String, dynamic> toMap();
}

class Tables extends TableElement{
  static final String TABLE_NAME = "brands";
  String brand;

  Tables({this.brand, id}): super(id, TABLE_NAME);

  factory Tables.fromMap(Map<String, dynamic> map) {
    return Tables(brand: map['brand'], id: map['_id']);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate("CREATE TABLE $TABLE_NAME (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand VARCHAR(100))");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'brand': this.brand};
    if(this.id != null){
      map['_id'] = id;
    }
    return map;
  }
}

final String DB_FILE_NAME = "crub.db";

class DbHelper {
  static final DbHelper _instance = new DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  Database _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await open();

    return _database;
  }

  Future<Database> open() async {
    try{
      String databasesPath = await getDatabasesPath();
      String path = "$databasesPath/$DB_FILE_NAME";

      var db = await openDatabase(path,
      version: 1,
      onCreate: (Database database, int version) {
        new Tables().createTable(database);
      });
      return db;
    }catch(e){
      print(e.toString());
    }
    return null;
  }

  Future<List<Tables>> getList() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query(Tables.TABLE_NAME,
    columns: ['_id', 'brand']);

    return maps.map((i)=>Tables.fromMap(i)).toList();
  }
  Future<TableElement> insert(TableElement element) async {
    var dbProducts = await db;

    element.id = await dbProducts.insert(element.tableName, element.toMap());
    print('new ID ${element.id}');
    return element;
  }

  /*Future<Categories> setCategory(String category) async {
    var dbProducts = await db;

    db.
  }*/

  Future<int> delete(TableElement element) async {
    var dbProducts = await db;
    return await dbProducts.delete(element.tableName, where: '_id = ?', whereArgs: [element.id]);
  }
  Future<int> update(TableElement element) async {
    var dbProducts = await db;

    return await dbProducts.update(element.tableName, element.toMap(), where: '_id = ?', whereArgs: [element.id]);
  }
}

class Brand extends TableElement{
  static final String TABLE_NAME = "brands";
  String brand;

  Brand({this.brand, id}): super(id, TABLE_NAME);
  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(brand: map['brand'], id: map['_id']);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate("CREATE TABLE $TABLE_NAME (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand VARCHAR(100))");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'brand': this.brand};
    if(this.id != null){
      map['_id'] = id;
    }
    return map;
  }
}