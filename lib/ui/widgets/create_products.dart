import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../models/models.dart';
//import '../../bloc/ListDetailBloc.dart';
import '../../bloc/category_bloc.dart';
//import '../../bloc/product_bloc.dart';
import '../../bloc/products_global_bloc.dart';

class CreateProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Productos',
        context: context,
        menu: false,
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
  
  @override
  Widget build(BuildContext context) {
    var _sizeWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: _sizeWidth * 0.1),
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
          Row(children: <Widget>[
            DropDownCategories(),
            RaisedButton(
              color: Colors.blueAccent,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                Navigator.pushNamed(context, '/createCategory');
              },
              ),
          ],),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
            child: _button(),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return RaisedButton(
      color: Colors.blueAccent,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          if (_category != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('procesando'),
            ));
            Products productInsert = new Products();
            productInsert.product = productName.text;
            productInsert.unit = productUnit.text;
            productInsert.category = _category.id;
            _category = null;
            //bloc.addProductToList(productInsert);
            //productBloc.fetchAllProducts();
            globalProductsBloc.addProductToList(productInsert);
            Navigator.pop(context);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Seleccione categoria'),
            ));
          }
        }
      },
      child: Text('Agregar', style: TextStyle(color: Colors.white),),
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
  //DbHelper _dataBase;

  @override
  void initState() {
    categoryBloc.open();
    super.initState();
  }
  
  @override
  void dispose() {
    categoryBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryBloc.allCategories,
      builder: (context, AsyncSnapshot<List<Categories>> snapshot){
        if(snapshot.hasData){
          return getCategories(snapshot);
        }else if(snapshot.hasError){
          return Text(snapshot.hasError.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
  Widget getCategories(AsyncSnapshot<List<Categories>> snapshot){
    return DropdownButton<Categories>(
      value: dropdownValue,
      hint: Text('Seleccione Categoria'),
      onChanged: (Categories newValue) {
        setState(() {
         dropdownValue = newValue;
         _category = newValue;
        });
      },
      items: snapshot.data.map<DropdownMenuItem<Categories>>((Categories value) {
        return DropdownMenuItem<Categories>(
          value: value,
          child: Text(value.category),
          );
      }).toList(),
    );
  }
}
