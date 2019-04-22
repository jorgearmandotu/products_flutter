import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/brand_model.dart';

abstract class TableElement{
  int id;
  final String tableName;
  TableElement(this.id, this.tableName);
  Map<String, dynamic> toMap();
}

class Tables {
  //static final String TABLE_NAME = "brands";
  //String brand;

  //Tables({this.brand, id}): super(id, TABLE_NAME);

  /*factory Tables.fromMap(Map<String, dynamic> map) {
    return Tables(brand: map['brand'], id: map['_id']);
  }*/

  void createTable(Database db) {
    //db.rawUpdate("CREATE TABLE $TABLE_NAME (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand VARCHAR(100))");
    db.rawUpdate("CREATE TABLE products (_id INTEGER PRIMARY KEY AUTOINCREMENT, product TEXT NOT NULL, unit TEXT NOT NULL, category INTEGER NOT NULL);");
    db.rawUpdate("CREATE TABLE categories (_id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE presentations (_id INTEGER PRIMARY KEY AUTOINCREMENT,presentation TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE prices (product INTEGER NOT NULL,brand INTEGER NOT NULL,presentation INTEGER DEFAULT NULL,provider INTEGER NOT NULL,price_unit REAL NOT NULL,promocion REAL DEFAULT '0',_id INTEGER PRIMARY KEY AUTOINCREMENT);");
    db.rawUpdate("CREATE TABLE providers (_id INTEGER PRIMARY KEY AUTOINCREMENT,provider TEXT NOT NULL,address TEXT NOT NULL,phone TEXT NOT NULL);");
    db.rawUpdate("CREATE TABLE brands (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand TEXT NOT NULL);");
  }

  /*@override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'brand': this.brand};
    if(this.id != null){
      map['_id'] = id;
    }
    return map;
  }*/
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

  Future<List<ProductsDetail>> getListDetails(int id) async {
    Database dbProducts = await db;

    List<Map> maps = await dbProducts.rawQuery('''SELECT products.product, products.unit, price_unit, promocion, providers.provider, brands.brand, presentations.presentation, prices.id, products.id as idProduct FROM (((products JOIN prices on prices.product = products.id)JOIN providers on providers.id = prices.provider)JOIN brands on brands.id = prices.brand)JOIN presentations on prices.presentation = presentations.id WHERE products.id = $id ORDER BY price_unit ASC''');

    return maps.map((i)=>ProductsDetail.fromMap(i)).toList();
    //List<Map> maps = await dbProducts.query(table)
  }

  Future<TableElement> insert(TableElement element) async {
    print('inserrcion de data');
    var dbProducts = await db;

    element.id = await dbProducts.insert(element.tableName, element.toMap());
    print('new ID ${element.id}');
    return element;
  }

  Future<TableElement> insertCategory(TableElement element) async {
    var dbProducts = await db;

    element.id = await dbProducts.insert(element.tableName, element.toMap());
    print('new ID ${element.id}');
    return element;
  }

  Future<TableElement> insertPresentations(TableElement element) async {
    var dbProducts = await db;

    element.id = await dbProducts.insert(element.tableName, element.toMap());
    print('new ID ${element.id}');
    return element;
  }

  Future<TableElement> insertProducts(TableElement element) async {
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
