import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class ListProductsDetailBloc {
  final _dataDb = new DbHelper();
  var _listProductsDetail = PublishSubject<List<ProductsDetail>>();

  Observable<List<ProductsDetail>> get detailProducts => _listProductsDetail.stream;

  List<ProductsDetail> _listResult;

  fetchAllproductsDetail(int id) async {
    _listResult = await _dataDb.getListDetails(id);
    _listProductsDetail.sink.add(_listResult);
  }

  ListProductsDetailBloc({int id}){
      fetchAllproductsDetail(id);
  }

  updateProductsDetail(Prices priceUpdate){
    _dataDb.update(priceUpdate).then((result){
      fetchAllproductsDetail(priceUpdate.product);
    });
  }

  deleteProductDetail(int idPrice) {
    Prices priceDelete;
    _dataDb.getListPricesId(idPrice).then((result){
      for(Prices p in result) {
        priceDelete = p;
      }
      if(priceDelete != null){
        _dataDb.delete(priceDelete).then((result){
          fetchAllproductsDetail(priceDelete.product);
        });
      }
    });
  }

  deleteProduct( Products producto){
    _dataDb.delete(producto);
  }

  void dispose() {
    _listProductsDetail.close();
  }

  void open() {
    _listProductsDetail = PublishSubject<List<ProductsDetail>>();
  }
}
var blocDetailProduct = ListProductsDetailBloc();