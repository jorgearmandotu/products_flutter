//create prices and presentation
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './myappbar.dart';
import '../../data/data_helper.dart';
import '../../models/brand_model.dart';

var _sizeWidth;
class CreatePrices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Precios',
        context: context,
      ),
      body: ProductsForm(),
    );
  }
}

Products _product;
Presentations _presentation;
Brands _brand;
Providers _provider;

class ProductsForm extends StatefulWidget {
  @override
  ProductsFormState createState() {
    return ProductsFormState();
  }
}

class ProductsFormState extends State<ProductsForm> {
  final _formKey = GlobalKey<FormState>();
  final productVlrUnit = TextEditingController();
  final productPromocion = TextEditingController();

  DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: _sizeWidth*0.1),
        children: <Widget>[
          DropDownProducts(),
          DropDownPresentations(),
          DropDownBrands(),
          DropDownProviders(),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
            controller: productVlrUnit,
            decoration: InputDecoration(labelText: 'Valor unitario: '),
            validator: (value) {
              if (value.isEmpty) {
                return 'Debe ingresar el valor de la unidad';
              }
              final n = num.tryParse(value);
              if(n == null) {
                return '"$value" no es un numero valido';
              }
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
            validator: (value) {
              final n = num.tryParse(value);
              if(n == null && value.isNotEmpty) {
                return '"$value" no es un valor valido';
              }
            },
            decoration: InputDecoration(
              labelText: 'valor en oferta: ',
            ),
            controller: productPromocion,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: _sizeWidth*0.2),
            child: RaisedButton(
              color: Colors.blueAccent,
              child: Text('Agregar'),
              textColor: Colors.white,
              onPressed: () {
                if(_formKey.currentState.validate()){
                  if(_brand != null && _product != null && _presentation != null && _provider != null){
                    Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Procesando')));
                    Prices price = new Prices();
                    price.product =_product.id;
                    price.presentation = _presentation.id;
                    price.provider = _provider.id;
                    price.brand = _brand.id;
                    price.priceUnit =  num.tryParse(productVlrUnit.text);
                    if(productPromocion.text.isEmpty){
                      price.promocion = 0;
                    }else{
                      price.promocion = num.tryParse(productPromocion.text);
                    }
                    _dataBase.insert(price);
                    _brand = null;
                    _product = null;
                    _presentation = null;
                    _provider = null;
                    Navigator.of(context).pop();
                  }
                  else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Ingrese todos los datos')));
                  }
                }
              }
            ),
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
  List<Products> listProducts;
  //List<Presentations> listPresentations;
  //List<Brands> listBrands;
  //List<Providers> listProvider;
  DbHelper _dataBase;

  Products dropdownProductsValue;
  //Presentations dropdownPresentationsValue;
  //Brands dropdownBrandsValue;
  //Providers dropdownProvidersValue;

  @override
  void initState() {
    super.initState();
    _dataBase = new DbHelper();
    updateList();
  }

  void updateList() {
    _dataBase.getListProducts().then((list) {
      setState(() {
        listProducts = list;
      });
    });
  }

  Widget build(BuildContext context) {
    if (listProducts != null) {
      return DropdownButton<Products>(
            value: dropdownProductsValue,
            hint: Text('Selecione Producto'),
            onChanged: (Products newValue) {
              setState(() {
                dropdownProductsValue = newValue;
                _product = newValue;
              });
            },
            items:
                listProducts.map<DropdownMenuItem<Products>>((Products value) {
              return DropdownMenuItem<Products>(
                value: value,
                child: Text(value.product),
              );
            }).toList(),
          );
    } else {
      return Text('No hay products');
    }
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
    _dataBase = new DbHelper();
    _dataBase.getListPresentations().then((list) {
      setState(() {
        if(list != null){
          listPresentations = list;
        }
        else {
          listPresentations = null;
        }
      });
    });
  }

  void updateList() {
    _dataBase.getListPresentations().then((list){
      setState(() {
       listPresentations = list; 
      });
    });
  }

  Widget build(BuildContext context) {
    if (listPresentations != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButton<Presentations>(
            value: dropdownValue,
            hint: Text('seleccione presentation'),
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
          Spacer(
          ),
          Ink(
            decoration: ShapeDecoration(
              color: Colors.blueAccent,
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: (){
                insertPresentations(context);
              },
            ),
          ),
        ],
      );
    }else {
      return Text('No hay Presentaciones disponibles');
    }
  }

  void insertPresentations(BuildContext context){
    final presentationValue = TextEditingController();
    final presentationkey = GlobalKey<FormState>();
    final _heightSize = MediaQuery.of(context).size.height;

    Presentations presentation = new Presentations();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return 
            AlertDialog(
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
                      validator: (value){
                        if(value.isEmpty){
                          return 'ingrese nombre de presentación';
                        }
                      },
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () {
                        if(presentationkey.currentState.validate()){
                          _dataBase = new DbHelper();
                          presentation.presentation = presentationValue.text;
                          _dataBase.insert(presentation).then((value){
                            updateList();
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Añadir'),
                    ),
                  ],
                ),
              ),
                ],
              ),
            );
      }
    );
  }

}

class DropDownBrands extends StatefulWidget {
  DropDownBrands({Key key}) : super(key: key);

  @override
  _DropDownBrandsState createState() => _DropDownBrandsState();
}

class _DropDownBrandsState extends State<DropDownBrands> {
  List<Brands> listBrands;
  DbHelper _dataBase;
  Brands dropdownValue;

  @override
  void initState() {
    super.initState();
    _dataBase = new DbHelper();
    _dataBase.getListBrands().then((list) {
      setState(() {
        listBrands = list;
      });
    });
  }

  Widget build(BuildContext context) {
    if (listBrands != null) {
      return DropdownButton<Brands>(
        value: dropdownValue,
        hint: Text('seleccione Marca'),
        onChanged: (Brands newValue) {
          setState(() {
            dropdownValue = newValue;
            _brand = newValue;
          });
        },
        items: listBrands.map<DropdownMenuItem<Brands>>((Brands value) {
          return DropdownMenuItem<Brands>(
            value: value,
            child: Text(value.brand),
          );
        }).toList(),
      );
    }else {
      return Text('No hay Marcas disponibles');
    }
  }
}

class DropDownProviders extends StatefulWidget {
  DropDownProviders({Key key}) : super(key: key);

  @override
  _DropDownProvidersState createState() => _DropDownProvidersState();
}

class _DropDownProvidersState extends State<DropDownProviders> {
  List<Providers> listProviders;
  DbHelper _dataBase;
  Providers dropdownValue;

  @override
  void initState() {
    super.initState();
    _dataBase = new DbHelper();
    _dataBase.getListProviders().then((list) {
      setState(() {
        listProviders = list;
      });
    });
  }

  Widget build(BuildContext context) {
    if (listProviders != null) {
      return DropdownButton<Providers>(
        value: dropdownValue,
        hint: Text('Seleccione Proveedor'),
        onChanged: (Providers newValue) {
          setState(() {
            dropdownValue = newValue;
            _provider = newValue;
          });
        },
        items: listProviders.map<DropdownMenuItem<Providers>>((Providers value) {
          return DropdownMenuItem<Providers>(
            value: value,
            child: Text(value.provider),
          );
        }).toList(),
      );
    }else {
      return Text('No hay Proveedores disponibles');
    }
  }
}