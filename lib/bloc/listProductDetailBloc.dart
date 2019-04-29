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

  void dispose() {
    _listProductsDetail.close();
  }

  void open() {
    _listProductsDetail = PublishSubject<List<ProductsDetail>>();
  }
}
var blocDetailProduct = ListProductsDetailBloc();