import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class CategoryBloc {
  final _dataDb = new DbHelper();
  var _listCategories = PublishSubject<List<Categories>>();
  //var _category = PublishSubject<List<Categories>>();

  Observable<List<Categories>> get allCategories => _listCategories.stream;
  //Observable<List<Categories>> get categoryId => _category.stream;

  fetchAllCategories() async{
    _listCategories.sink.add(await _dataDb.getListCategories());
  }

  CategoryBloc(){
    fetchAllCategories();
  }

  addCategoryToList(Categories category){
    _dataDb.insert(category).then((result){
      fetchAllCategories();
    });
  }

  updateCategory(Categories category){
    _dataDb.update(category).then((result){
      //fetchAllCategories();
    });
    fetchAllCategories();
  }

  /*getcategoryId(int id) async{
    _category.sink.add(await _dataDb.getListCategoryId(id));
  }*/

  dispose(){
    _listCategories.close();
    //_category.close();
  }

  open(){
    _listCategories = PublishSubject<List<Categories>>();
    //_category = PublishSubject<List<Categories>>();
    fetchAllCategories();
  }
}

final categoryBloc = CategoryBloc();