import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/models.dart';

abstract class TableElement{
  int id;
  final String tableName;
  TableElement(this.id, this.tableName);
  Map<String, dynamic> toMap();
}

class Tables {
  void createTable(Database db) {
    //db.rawUpdate("CREATE TABLE $TABLE_NAME (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand VARCHAR(100))");
    db.rawUpdate("CREATE TABLE products (_id INTEGER PRIMARY KEY AUTOINCREMENT, product TEXT NOT NULL, unit TEXT NOT NULL, category INTEGER NOT NULL);");
    db.rawUpdate("CREATE TABLE categories (_id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE presentations (_id INTEGER PRIMARY KEY AUTOINCREMENT,presentation TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE prices (product INTEGER NOT NULL,brand INTEGER NOT NULL,presentation INTEGER DEFAULT NULL,provider INTEGER NOT NULL,price_unit REAL NOT NULL,promocion REAL DEFAULT '0',_id INTEGER PRIMARY KEY AUTOINCREMENT);");
    db.rawUpdate("CREATE TABLE providers (_id INTEGER PRIMARY KEY AUTOINCREMENT,provider TEXT NOT NULL,address TEXT NOT NULL,phone TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE brands (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand TEXT NOT NULL);");
  }
}

final String dBFILENAME = "products.db";

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
      //String path = "$databasesPath/$DB_FILE_NAME";
      String path = join(databasesPath, dBFILENAME);

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

  Future<List<Brands>> getListBrands() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('brands',
    columns: ['_id', 'brand'], orderBy: 'brand ASC');

    return maps.map((i)=>Brands.fromMap(i)).toList();
  }

  Future<List<Categories>> getListCategories() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('categories',
    columns: ['_id', 'category'], orderBy: 'category ASC');

    return maps.map((i)=>Categories.fromMap(i)).toList();
  }

  Future<List<Products>> getListProducts() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('products',
    columns: ['_id', 'product', 'unit', 'category'], orderBy: 'product ASC');

    return maps.map((i)=>Products.fromMap(i)).toList();
  }

  Future<List<Products>> getListProductName(String nameProduct) async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('products',
    columns: ['_id', 'product', 'unit', 'category'], where: 'product LIKE "%$nameProduct%"', orderBy: 'product ASC');

    return maps.map((i)=>Products.fromMap(i)).toList();
  }

  Future<List<Presentations>> getListPresentations() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('presentations',
    columns: ['_id', 'presentation'], orderBy: 'presentation ASC');

    return maps.map((i)=>Presentations.fromMap(i)).toList();
  }

  Future<List<Providers>> getListProviders() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('providers',
    columns: ['_id', 'provider', 'address', 'phone'], orderBy: 'provider ASC');

    return maps.map((i)=>Providers.fromMap(i)).toList();
  }

  Future<List<Categories>> getListCategoryId(int id) async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('categories', columns: ['_id', 'category'], where: '_id = $id');

    return maps.map((i)=>Categories.fromMap(i)).toList();
  }

   Future<List<Prices>> getListPrices() async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('prices',
    columns: ['_id', 'provider', 'product', 'brand', 'presentation', 'price_unit', 'promocion'], orderBy: 'provider ASC');

    return maps.map((i)=>Prices.fromMap(i)).toList();
  }

  Future <List<Prices>> getListPricesId(int id) async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.query('prices',
    columns: ['_id', 'provider', 'product', 'brand', 'presentation', 'price_unit', 'promocion'], where: '_id = $id',orderBy: 'provider ASC');
    return maps.map((i)=>Prices.fromMap(i)).toList();
    //return maps.map((i) => Prices.)
  }

  Future<List<ProductsDetail>> getListDetails(int id) async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.rawQuery('''SELECT products.product, products.unit, price_unit, promocion, providers.provider, brands.brand, presentations.presentation, prices._id, products._id as idProduct FROM (((products JOIN prices on prices.product = products._id)JOIN providers on providers._id = prices.provider)JOIN brands on brands._id = prices.brand)JOIN presentations on prices.presentation = presentations._id WHERE products._id = $id ORDER BY price_unit ASC''');

    return maps.map((i)=>ProductsDetail.fromMap(i)).toList();
    //List<Map> maps = await dbProducts.query(table)
  }

  Future<TableElement> insert(TableElement element) async {
    var dbProducts = await db;

    element.id = await dbProducts.insert(element.tableName, element.toMap());
    return element;
  }

  Future<int> delete(TableElement element) async {
    var dbProducts = await db;
    return await dbProducts.delete(element.tableName, where: '_id = ?', whereArgs: [element.id]);
  }
  Future<int> update(TableElement element) async {
    var dbProducts = await db;

    return await dbProducts.update(element.tableName, element.toMap(), where: '_id = ?', whereArgs: [element.id]);
  }
}
