import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class ProductsGlobalBloc {
  final _dataDb = new DbHelper();
  BehaviorSubject<List<Products>> _listProducts = BehaviorSubject<List<Products>>();

  Observable<List<Products>> get allProducts => _listProducts.stream;

  fetchAllProducts({String nameProduct}) async {
    if(nameProduct == null){
      _listProducts.sink.add(await _dataDb.getListProducts());
    }
    else
    {
      _listProducts.sink.add(await _dataDb.getListProductName(nameProduct));
    }
  }

  void addProductToList(Products product){
    _dataDb.insert(product).then((result){
      fetchAllProducts();
    });
  }

  void dispose(){
    _listProducts?.close();
  }

  static ProductsGlobalBloc _bloc = new ProductsGlobalBloc._internal();
  factory ProductsGlobalBloc(){
    return _bloc;
  }

  ProductsGlobalBloc._internal();
}

ProductsGlobalBloc globalProductsBloc = ProductsGlobalBloc();