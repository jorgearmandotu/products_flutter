import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './myappbar.dart';
import '../../data/data_helper.dart';
import '../../models/models.dart';
import '../../bloc/listProductDetailBloc.dart';
import '../../bloc/dropdownBloc.dart';
import '../../helpers/fancy_fab.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/brand_bloc.dart';

var _sizeWidth;

class CreatePrices extends StatelessWidget {
  final int idPrice;
  CreatePrices({this.idPrice});
  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return idPrice == null ?
      Scaffold(
        appBar: MyAppBar(
          title: 'Add Precios',
          context: context,
          menu: true,
        ),
        body: ProductsForm(),
        floatingActionButton: FancyFab(),
      )
      : Scaffold(
        appBar: MyAppBar(
          title: 'editar Precios',
          context: context,
        ),
        body: EditPrices(
          idPrice: idPrice,
        ),
      );
  }
}

Products _product;
Presentations _presentation;
Brands _brand;
Providers _provider;

class ProductsForm extends StatefulWidget {
  ProductsForm();
  @override
  ProductsFormState createState() {
    return ProductsFormState();
  }
}

class ProductsFormState extends State<ProductsForm> {
  ProductsFormState();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productVlrUnit = TextEditingController();
  final TextEditingController productPromocion = TextEditingController();

  DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: _sizeWidth * 0.1),
        children: <Widget>[
          DropDownProducts(),
          DropDownProviders(),
          DropDownBrands(),
          DropDownPresentations(),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
            ],
            controller: productVlrUnit,
            decoration: InputDecoration(labelText: '\$ Valor Unitario: '),
            validator: (value) {
              if (value.isEmpty) {
                return 'Debe ingresar el valor de la unidad';
              }
              final n = num.tryParse(value);
              if (n == null) {
                return '"$value" no es un numero valido';
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
            ],
            //initialValue: _priceEdit.promocion.toString(),
            validator: (value) {
              final n = num.tryParse(value);
              if (n == null && value.isNotEmpty) {
                return '"$value" no es un valor valido';
              }
            },
            decoration: InputDecoration(
              labelText: '\$ Valor en Oferta: ',
            ),
            controller: productPromocion,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 18.0, horizontal: _sizeWidth * 0.2),
            child: RaisedButton(
                color: Colors.blueAccent,
                child: Text('Agregar'),
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (_brand != null &&
                        _product != null &&
                        _presentation != null &&
                        _provider != null) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Procesando')));
                      Prices price = new Prices();
                      price.product = _product.id;
                      price.presentation = _presentation.id;
                      price.provider = _provider.id;
                      price.brand = _brand.id;
                      price.priceUnit = num.tryParse(productVlrUnit.text);
                      if (productPromocion.text.isEmpty) {
                        price.promocion = 0;
                      } else {
                        price.promocion = num.tryParse(productPromocion.text);
                      }
                      _dataBase.insert(price);
                      _brand = null;
                      _product = null;
                      _presentation = null;
                      _provider = null;
                      Navigator.of(context).pop();
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Ingrese todos los datos')));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }
}

class DropDownProducts extends StatefulWidget {
  DropDownProducts({Key key}) : super(key: key);

  @override
  _DropDownProductsState createState() => _DropDownProductsState();
}

class _DropDownProductsState extends State<DropDownProducts> {

  Products dropdownProductsValue;

  @override
  void initState() {
    productBloc.open();
    super.initState();
  }

  @override
  void dispose() {
    productBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return StreamBuilder(
      stream: productBloc.allProducts,
      builder: (context, AsyncSnapshot<List<Products>> snapshot){
        if(snapshot.hasData){
          return getProducts(snapshot);
        }
        else if(snapshot.hasError){
          return Text(snapshot.hasError.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget getProducts(AsyncSnapshot<List<Products>> snapshot){
    return DropdownButton<Products>(
      value: dropdownProductsValue,
      hint: Text('Seleccione Producto'),
      onChanged: (Products newValue){
        setState(() {
         dropdownProductsValue = newValue;
         _product = newValue;
        });
      },
      items: snapshot.data.map<DropdownMenuItem<Products>>((Products value) {
        return DropdownMenuItem<Products>(
          value: value,
          child: Text(value.product),
          );
      }).toList(),
    );
  }
}

class DropDownPresentations extends StatefulWidget {
  DropDownPresentations({Key key}) : super(key: key);

  @override
  _DropDownPresentationsState createState() => _DropDownPresentationsState();
}

class _DropDownPresentationsState extends State<DropDownPresentations> {
  List<Presentations> listPresentations;
  DbHelper _dataBase;
  Presentations dropdownValue;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  void updateList({Presentations presentation}) {
    _dataBase.getListPresentations().then((list) {
      setState(() {
        listPresentations = list;
        for(Presentations p in listPresentations){
          if(p.presentation == presentation.presentation){
            dropdownValue = p;
            _presentation = p;
          }
        }
      });
    });
  }

  void loadList(){
    _dataBase = new DbHelper();
    _dataBase.getListPresentations().then((list) {
      setState(() {
        if (list != null) {
          listPresentations = list;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return listPresentations != null ?
       Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButton<Presentations>(
            value: dropdownValue,
            hint: Text('Presentation'),
            onChanged: (Presentations newValue) {
              setState(() {
                dropdownValue = newValue;
                _presentation = newValue;
              });
            },
            items: listPresentations
                .map<DropdownMenuItem<Presentations>>((Presentations value) {
              return DropdownMenuItem<Presentations>(
                value: value,
                child: Text(value.presentation),
              );
            }).toList(),
          ),
          
          /*Ink(
            decoration: ShapeDecoration(
              color: Colors.blueAccent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                insertPresentations(context);
              },
            ),
          ),*/
          RaisedButton(
            shape: CircleBorder(),
            color: Colors.blueAccent,
            child: Icon(Icons.add, color: Colors.white,),
            onPressed: (){
              insertPresentations(context);
            },
          )
        ],
      )
      :  Text('No hay Presentaciones disponibles');
    
  }

  void insertPresentations(BuildContext context) {
    final presentationValue = TextEditingController();
    final presentationkey = GlobalKey<FormState>();

    Presentations presentation = new Presentations();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nueva presentacion'),
            content: ListView(
              children: <Widget>[
                Form(
                  key: presentationkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: presentationValue,
                        decoration: InputDecoration(
                          labelText: 'Presentation:',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ingrese nombre de presentación';
                          }
                        },
                      ),
                      RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (presentationkey.currentState.validate()) {
                            _dataBase = new DbHelper();
                            presentation.presentation = presentationValue.text;
                            _dataBase.insert(presentation).then((value) {
                              updateList(presentation: presentation);
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Agregar', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class DropDownBrands extends StatefulWidget {
  DropDownBrands({Key key}) : super(key: key);

  @override
  _DropDownBrandsState createState() => _DropDownBrandsState();
}

class _DropDownBrandsState extends State<DropDownBrands> {
  Brands dropdownValue;

  @override
  void initState() {
    super.initState();
    brandBloc.open();
  }
  @override
  void dispose(){
    brandBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: brandBloc.allBrands,
      builder: (context, AsyncSnapshot<List<Brands>> snapshot){
        if(snapshot.hasData){
          return getBrands(snapshot);
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget getBrands(AsyncSnapshot<List<Brands>> snapshot){
    return DropdownButton<Brands>(
        value: dropdownValue,
        hint: Text('seleccione Marca'),
        onChanged: (Brands newValue) {
          setState(() {
            dropdownValue = newValue;
            _brand = newValue;
          });
        },
        items: snapshot.data.map<DropdownMenuItem<Brands>>((Brands value) {
          return DropdownMenuItem<Brands>(
            value: value,
            child: Text(value.brand),
          );
        }).toList(),
      );
  }
}

class DropDownProviders extends StatefulWidget {
  DropDownProviders({Key key}) : super(key: key);

  @override
  _DropDownProvidersState createState() => _DropDownProvidersState();
}

class _DropDownProvidersState extends State<DropDownProviders> {
  List<Providers> listProviders;
  Providers dropdownValue;

  @override
  void initState() {
    super.initState();
      providerBloc.open();
  }

  @override
  void dispose(){
    providerBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return getList();
  }

  Widget getList(){
    return StreamBuilder(
      stream: providerBloc.allProviders,
      builder: (context, AsyncSnapshot<List<Providers>> snapshot){
        if(snapshot.hasData){
          return buildListDropdown(snapshot);
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildListDropdown(AsyncSnapshot<List<Providers>> snapshot){
    return DropdownButton<Providers>(
      value: dropdownValue,
      hint: Text('Seleccione proveedor'),
      onChanged: (Providers newValue){
        setState(() {
         dropdownValue = newValue;
         _provider = newValue;
        });
      },
      items: snapshot.data.map<DropdownMenuItem<Providers>>((Providers value){
        return DropdownMenuItem<Providers>(
          value: value,
          child: Text(value.provider),
          );
      }).toList(),
    );
  }
}

class EditPrices extends StatefulWidget {
  final int idPrice;
  EditPrices({this.idPrice});
  @override
  _EditPricesState createState() => _EditPricesState(idPrice);
}

class _EditPricesState extends State<EditPrices> {
  int idPrice;
  _EditPricesState(this.idPrice);
  final _keyForm = GlobalKey<FormState>();

  Prices _price;
  ProductsDetail _product;

  @override
  void initState() {
    super.initState();
    updatePrice();
  }

  void updatePrice() {
    DbHelper data = new DbHelper();
    data.getListPricesId(idPrice).then((result) {
      setState(() {
        for (Prices p in result) {
          _price = p;
        }
        updateProduct();
      });
    });
  }

  void updateProduct() {
    DbHelper data = new DbHelper();
    data.getListDetails(_price.product).then((result) {
      setState(() {
        for (ProductsDetail prod in result) {
          _product = prod;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_price != null && _product != null) {
      TextEditingController priceUnit;
      TextEditingController priceOfert;
      priceUnit = TextEditingController();
      priceOfert = TextEditingController();
      priceUnit.text = _price.priceUnit.toString();
      priceOfert.text = _price.promocion.toString();
      return Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            Text(
                'Producto: ${_product.product} \n marca: ${_product.brand} \n Proveedor: ${_product.provider} \nPresentación: ${_product.presentation}'),
            TextFormField(
              //initialValue: _price.priceUnit.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
              ],
              controller: priceUnit,
              decoration: InputDecoration(labelText: 'Valor unitario'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Deve ingresar un valor valido';
                }
              },
            ),
            TextFormField(
              //initialValue: _price.promocion.toString(),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [
                BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
              ],
              controller: priceOfert,
              decoration: InputDecoration(labelText: 'Valor Oferta'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Deve ingresar un valor valido';
                }
              },
            ),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text('Modificar',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                if (_keyForm.currentState.validate()) {
                  num unit = num.tryParse(priceUnit.text);
                  num ofert = num.tryParse(priceOfert.text);
                  if (unit != null && ofert != null) {
                    Prices priceUpdate;
                  priceUpdate = _price;
                  priceUpdate.priceUnit = unit;
                  priceUpdate.promocion = ofert;
                  blocDetailProduct.updateProductsDetail(priceUpdate);
                  Navigator.of(context).pop();
                  return Center(child: CircularProgressIndicator(),);
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Error en datos'),
                    ));
                  }
                }
              },
            ),
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
