//import 'dart:async';
import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class ListDetailBloc {

  final _dataDb = new DbHelper();
  final _listProducts = PublishSubject<List<Products>>();

  Observable<List<Products>> get allProducts => _listProducts.stream;
  
  List<Products> _productResult;

  fetchAllProducts({String nameProduct}) async {
    if(nameProduct == null){
      _productResult = await _dataDb.getListProducts();
      _listProducts.sink.add(_productResult);
    }
    else
    {
      _productResult = await _dataDb.getListProductName(nameProduct);
      _listProducts.sink.add(_productResult);
    }
    
  }

  ListDetailBloc(){
    fetchAllProducts();
  }

  void addProductToList(Products product){
    _productResult.add(product);
    _listProducts.sink.add(_productResult);
  }


  void dispose(){
    _listProducts.close();
  }
}
final bloc  = ListDetailBloc();
