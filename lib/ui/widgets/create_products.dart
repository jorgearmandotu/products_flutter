import 'package:flutter/material.dart';
import '../../data/data_helper.dart';
import './myappbar.dart';
import '../../models/brand_model.dart';

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

class ProductsFormState extends State<ProductsForm> {
  final _formKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final productUnit = TextEditingController();
  final productCategory = TextEditingController();
  DbHelper _database;
  Categories dropdownValue;

  List<Categories> listCategories;
  //listCategories = _dataBase.getListCategories();

  @override
  void initState() {
    super.initState();
    _database = new DbHelper();
    updateList();
  }

  void updateList() {
    _database.getListCategories().then((list) {
      setState(() {
        listCategories = list;
        //dropdownValue = listCategories[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: productName,
            decoration: InputDecoration(
              labelText: 'Producto',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'ingrese un nombre';
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
          Row(
            children: <Widget>[
              Text('Categoria:   '),
              Expanded(
                child: DropdownButton<Categories>(
                  value: dropdownValue,
                  onChanged: (Categories newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: listCategories
                      .map<DropdownMenuItem<Categories>>((Categories value) {
                    return DropdownMenuItem<Categories>(
                        child: Text(value.category), value: value);
                  }).toList(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 100.0),
            child: RaisedButton(
              onPressed: (){
                Products product = new Products();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  product.product = productName.text;
                  product.unit = productUnit.text;
                  product.category = dropdownValue.id;
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  _database.insert(product).then((value) {
                    //actuaizar lista
                    //dropdownValue = null;
                  });
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
