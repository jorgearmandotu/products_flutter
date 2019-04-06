import '../data/data_helper.dart';

class Brand{
  String _brand;
  int _id;

  Brand(
    this._brand,
    //this._id,
  );
  String get brand => _brand;
  int get id => _id;
}

class Categories {
  String _category;
  int _id;

  Categories(this._category);

  String get category => _category;
}

/*class Brand extends TableElement{
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

class Products extends TableElement{
  //static String TABLE_NAME = 'products';
  String product;
  String unit;
  int category;

  Products({this.product, this.unit, this.category, id, tableName}): super(id, tableName);
  factory Products.fromMap(Map<String, dynamic> map) {
    return Products(product: map['product'], unit: map['unit'], id: map['_id'], category: map['category']);
  }

  @override
  void createTable(Database db) {
    db.rawUpdate("CREATE TABLE $TABLE_NAME (_id INTEGER PRIMARY KEY AUTOINCREMENT, brand VARCHAR(100))");
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'product': this.product};
    if(this.id != null){
      map['_id'] = id;
    }
    return map;
  }
}*/