import '../data/data_helper.dart';

class Brands extends TableElement {
  static final String nameTable = 'brands';
  String brand;

  Brands({this.brand, id}): super(id, nameTable);

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
  static final String nameTable = "categories";
  String category;

  Categories({this.category, id}): super(id, nameTable);

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
static final String nameTable = "presentations";
String presentation;
Presentations({this.presentation, id}): super(id, nameTable);
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
static final String nameTable = "providers";
String provider;
String address;
String phone;

Providers({this.provider, this.address, this.phone, id}): super(id, nameTable);
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
static final String nameTable = "products";
String product;
String unit;
int category;
Products({this.product, this.category, this.unit, id}): super(id, nameTable);
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
static final String nameTable = "prices";
int product;
int brand;
int presentation;
int provider;
num priceUnit;
num promocion;
Prices({this.product, this.brand, this.presentation, this.provider, this.priceUnit, this.promocion, id}): super(id, nameTable);
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

class ProductsDetail {
  //SELECT products.product, products.unit, price_unit, promocion, providers.provider, brands.brand, presentations.presentation, prices.id, products.id as idProduct
  String product;
  String unit;
  num priceUnit;
  num promocion;
  String provider;
  String brand;
  String presentation;
  int idProduct;
  int idPrices;
  ProductsDetail({this.product, this.unit, this.priceUnit, this.promocion, this.provider, this.brand, this.presentation, this.idPrices, this.idProduct});
  factory ProductsDetail.fromMap(Map<String, dynamic> map) {
    return ProductsDetail(product: map['product'], unit: map['unit'], priceUnit: map['price_unit'], promocion: map['promocion'], provider: map['provider'], brand: map['brand'], presentation: map['presentation'], idProduct: map['idProduct'], idPrices: map['_id']);
  }
}