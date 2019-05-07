import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class ListDetailBloc {

  final _dataDb = new DbHelper();
  var _listProducts = PublishSubject<List<Products>>();

  Observable<List<Products>> get allProducts => _listProducts.stream;
  
  //List<Products> _productResult;

  fetchAllProducts({String nameProduct}) async {
    if(nameProduct == null){
      //_productResult = await _dataDb.getListProducts();
      _listProducts.sink.add(await _dataDb.getListProducts());
    }
    else
    {
      //_productResult = await _dataDb.getListProductName(nameProduct);
      _listProducts.sink.add(await _dataDb.getListProductName(nameProduct));
    }
  }

  ListDetailBloc(){
    fetchAllProducts();
  }

  void addProductToList(Products product){
    _dataDb.insert(product).then((result){
      fetchAllProducts();
    });
    //_productResult.add(product);
    //_listProducts.sink.add(_productResult);
  }


  void dispose(){
    _listProducts.close();
  }

  void open(){
    _listProducts = PublishSubject<List<Products>>();
    fetchAllProducts();
  }
}
final productBloc = ListDetailBloc();
