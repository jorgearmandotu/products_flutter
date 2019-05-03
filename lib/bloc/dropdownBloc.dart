import '../models/models.dart';
import 'package:rxdart/rxdart.dart';
import '../data/data_helper.dart';

class DropdownBloc {
  final _dataDB = new DbHelper();
  var _listProvider = PublishSubject<List<Providers>>();

  //var providerSelect = PublishSubject<Providers>();

  int providerSelect = 0;

  List<Providers> _listProviderItems;

  Observable<List<Providers>> get allProviders => _listProvider.stream;
  //Observable<Providers> get selectProvider => providerSelect.stream;

  fetcAllProviders() async{
    _listProviderItems = await _dataDB.getListProviders();
    _listProvider.sink.add(_listProviderItems);
  }

  DropdownBloc(){
    fetcAllProviders();
  }

  void addProviderToList(Providers provider){
    _dataDB.insert(provider).then((result){
      fetcAllProviders();
    });
  }

  void dispose(){
    _listProvider.close();
  }

  void open(){
    _listProvider = PublishSubject<List<Providers>>();
    fetcAllProviders();
  }
}
final providerBloc = DropdownBloc();
//DropdownBloc providerBloc;