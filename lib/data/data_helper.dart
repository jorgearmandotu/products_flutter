import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/brand_model.dart';

 class DbHelper {

  int iddatos;
  static final DbHelper _instance = new DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() => _instance;
  
  Database _database;//static?

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'products.db');
      var db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database database, int version){
          _createTables(database, version);
        },
      );
      print('[DbHelper] initDB: succes');
      return db;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void _createTables(Database db, int version) async {
    await db.rawUpdate(
        'CREATE TABLE brands (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand TEXT NOT NULL);');
    print('[DbHelper]_createTables Success');
  }

  void setBrand(String brand) async {
    print('esto es set brand');
    try{
      Database data = await db;
      data.transaction((trans) async {
      return await trans.rawInsert(
        'INSERT INTO brands (brand) VALUES (\'$brand\')',
      );
    });
    }catch(e){
      print(e.toString());
    }
    //var dbproducts = await db;
    
  }

  Future<List<Brand>> getBrand() async {
    Database dbproducts = await db;
    List<Brand> listBrand = List();
    List<Map> queryList = await dbproducts.query('brands', columns: ['brand']);
    print('[DbHelper] getBrands: ${queryList.length} brands');
    if (queryList != null && queryList.length > 0) {
      listBrand = queryList.cast<Brand>().toList();
      print('[DbHelper] getBrand: ${listBrand[0].brand}');
      return listBrand;
    } else {
      print('[DbHelper] getBrands: Brand is null');
      return null;
    }
  }
}
