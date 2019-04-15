import '../data/data_helper.dart';

class Brands extends TableElement {
  static final String TABLE_NAME = 'brands';
  String brand;

  Brands({this.brand, id}): super(id, TABLE_NAME);

  factory Brands.fromMap(Map<String, dynamic> map) {
    return Brands(brand: map['brand'], id: map['_id']);
  }

  @override
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{'brand': this.brand};
    if(this.id != null){
      map['id'] = id;
    }
    return map;
  }
}

class Categories extends TableElement{
  static final String tABLENAME = "categories";
  String category;

  Categories({this.category, id}): super(id, tABLENAME);

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(category: map['category'], id: map['_id']);
  }


  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'category': this.category};
    if(this.id != null){
      map['_id'] = id;
    }
    return map;
  }
}

class Presentations extends TableElement{
static final String TABLE_NAME = "presentations";
String presentation;
Presentations({this.presentation, id}): super(id, TABLE_NAME);
factory Presentations.fromMap(Map<String, dynamic> map) {
  return Presentations(presentation: map['presentation'], id: map['_id']);
}
@override
Map<String, dynamic> toMap(){
  var map = <String, dynamic>{'presentation': this.presentation};
  if(this.id != null){
    map['_id'] = id;
  }
  return map;
}
}

class Providers extends TableElement{
static final String TABLE_NAME = "providers";
String provider;
String address;
String phone;

Providers({this.provider, this.address, this.phone, id}): super(id, TABLE_NAME);
factory Providers.fromMap(Map<String, dynamic> map) {
  return Providers(provider: map['provider'], address: map['address'], phone: map['phone'], id: map['_id']);
}
@override
Map<String, dynamic> toMap(){
  var map = <String, dynamic>{'provider': this.provider, 'address': this.address, 'phone': this.phone};
  if(this.id != null){
    map['_id'] = id;
  }
  return map;
}
}

class Products extends TableElement{
static final String TABLE_NAME = "products";
String product;
String unit;
int category;
Products({this.product, this.category, this.unit, id}): super(id, TABLE_NAME);
factory Products.fromMap(Map<String, dynamic> map) {
  return Products(product: map['product'], unit: map['unit'], category: map['category'], id: map['_id']);
}
@override
Map<String, dynamic> toMap(){
  var map = <String, dynamic>{'product': this.product, 'unit': this.unit, 'category': this.category};
  if(this.id != null){
    map['_id'] = id;
  }
  return map;
}
}

class Prices extends TableElement{
static final String TABLE_NAME = "prices";
int product;
int brand;
int presentation;
int provider;
double priceUnit;
double promocion;
Prices({this.product, this.brand, this.presentation, this.provider, this.priceUnit, this.promocion, id}): super(id, TABLE_NAME);
factory Prices.fromMap(Map<String, dynamic> map) {
  return Prices(product: map['product'], brand: map['brand'], presentation: map['presentation'], provider: map['provider'], priceUnit: map['price_unit'], promocion: map['promocion'], id: map['_id']);
}
@override
Map<String, dynamic> toMap(){
  var map = <String, dynamic>{'product': this.product, 'brand': this.brand, 'presentation': this.presentation, 'provider': this.provider, 'price_unit': this.priceUnit, 'promocion': this.promocion};
  if(this.id != null){
    map['_id'] = id;
  }
  return map;
}
}

/*class Categories {
  String _category;
  int _id;

  Categories(this._category);

  String get category => _category;
}
*/
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
}
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
*/