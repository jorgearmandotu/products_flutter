import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class BrandBloc {
  DbHelper _dataDB = new DbHelper();
  var _listBrands = PublishSubject<List<Brands>>();

  List<Brands> _listBrandsItems;

  Observable<List<Brands>> get allBrands => _listBrands.stream;

  fetcAllBrands() async{
    _listBrandsItems = await _dataDB.getListBrands();
    _listBrands.sink.add(_listBrandsItems);
  }

  BrandBloc(){
    fetcAllBrands();
  }

  void addBrandsToList(Brands brand) {
    _dataDB.insert(brand).then((result){
      fetcAllBrands();
    });
  }

  void dispose(){
    _listBrands.close();
  }

  void open(){
    _listBrands = PublishSubject<List<Brands>>();
    fetcAllBrands();
  }
}
final brandBloc = BrandBloc();