import 'package:flutter/material.dart';
import '../../data/data_helper.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/ListDetailBloc.dart';

class CreateProducts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(
        title: 'Productos',
        context: context,
      ),
      body: ProductsForm(),
    );
  }
}

class ProductsForm extends StatefulWidget {
  @override
  ProductsFormState createState() {
    return ProductsFormState();
  }
}

Categories _category;

class ProductsFormState extends State<ProductsForm> {
  final _formKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final productUnit = TextEditingController();
  //final productCategory = TextEditingController();
  DbHelper _dataBase;
  //ListDetailBloc bloc = new ListDetailBloc();

  @override
  Widget build(BuildContext context) {
    var _sizeWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: _sizeWidth*0.1),
        children: <Widget>[
          TextFormField(
            controller: productName,
            decoration: InputDecoration(
              labelText: 'Producto',
              hintText: 'Nombre Producto',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese un nombre';
              }
            },
          ),
          TextFormField(
            controller: productUnit,
            decoration: InputDecoration(
              labelText: 'Unidades',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese una unidad valida';
              }
            },
          ),
          DropDownCategories(),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 100.0),
            child: RaisedButton(
              onPressed: () {
                _dataBase = new DbHelper();
                if (_formKey.currentState.validate()) { 
                  if(_category != null){
                    Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('procesando'),
                    ));
                     Products productInsert = new Products();
                    productInsert.product = productName.text;
                    productInsert.unit = productUnit.text;
                    productInsert.category = _category.id;
                    _category = null;
                    _dataBase.insert(productInsert).then((value) {
                    Navigator.of(context).pop();
                    bloc.fetchAllProducts();
                    });
                  }else{
                    Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Seleccione categoria'),
                    ));
                  }
                }
              },
              child: Text('Añadir'),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownCategories extends StatefulWidget {
  DropDownCategories({Key key}) : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<DropDownCategories> {
  List<Categories> listCategories;
  Categories dropdownValue;
  DbHelper _dataBase;

  @override
  void initState() {
    super.initState();
    _dataBase = new DbHelper();
    updateList();
  }

  void updateList() {
    _dataBase.getListCategories().then((list) {
      setState(() {
        listCategories = list;
      });
    });
  }

  Widget build(BuildContext context) {
    if (listCategories != null) {
      return DropdownButton<Categories>(
        value: dropdownValue,
        hint: Text('Seleccione categoria'),
        onChanged: (Categories newValue) {
          setState(() {
            dropdownValue = newValue;
            _category = newValue;
          });
        },
        items: listCategories.map<DropdownMenuItem<Categories>>((Categories value) {
          return DropdownMenuItem<Categories>(
            value: value,
            child: Text(value.category),
          );
        }).toList(),
      );
    }
    else{
      return Text('No hay categorias agregadas');
    }
  }
}