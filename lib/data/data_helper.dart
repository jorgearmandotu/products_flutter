import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/brand_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  DbHelper.internal();
  factory DbHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if(_db != null) return _db;
    print('data base is null');
    _db = await _initDB();
    return _db;
  }

  Future<Database> _initDB() async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    String path = join(databasesPath, 'products.db');
    print(path);
    Database db = await openDatabase(path, version:1, 
    onCreate: _createTables,);
    print('[DbHelper] initDB: succes');
    return db;
  }

  void _createTables(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE  products (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         product TEXT NOT NULL,
         unit TEXT NOT NULL,
         category INTEGER NOT NULL
         );
         CREATE TABLE brands (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           brand TEXT NOT NULL
           );
         CREATE TABLE categories (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           category TEXT NOT NULL
           );
         CREATE TABLE presentations (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           presentation TEXT NOT NULL
           );
         CREATE TABLE prices (
           product INTEGER NOT NULL,
           brand INTEGER NOT NULL,
           presentation INTEGER DEFAULT NULL,
           provider INTEGER NOT NULL,
           price_unit REAL NOT NULL,
           promocion REAL DEFAULT '0',
           id INTEGER PRIMARY KEY AUTOINCREMENT
           );
           CREATE TABLE providers (
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             provider TEXT NOT NULL,
             address TEXT NOT NULL,
             phone TEXT NOT NULL
            ); 
          '''
    );
    print('[DbHelper]_createTables Success');
  }

  void setBrand(String brand) async{
    print(brand;
    var dbproducts = await db;
    await dbproducts.transaction((trans) async{
      return await trans.rawInsert(
        'INSERT INTO brands (brand) VALUES ("$brand")',
      );
    });
    print('[DbHelper] save brand: Sucess | $brand');
  }

  Future<List<Brand>> getBrand() async {
    var dbproducts = await db;
    List<Brand> listBrand = List();
    List<Map> queryList = await dbproducts.query('brands', columns: ['brand']);
    print('[DbHelper] getBrands: ${queryList.length} brands');
    if(queryList != null && queryList.length>0){
      listBrand = queryList.cast<Brand>().toList();
      print('[DbHelper] getBrand: ${listBrand[0].brand}');
      return listBrand;
    }
    else
    {
      print('[DbHelper] getBrands: Brand is null');
      return null;
    }
  }
}