import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/category_bloc.dart';
import '../../bloc/products_global_bloc.dart';

int _idCategory;
//String _nameCategory;
class CreateProducts extends StatelessWidget {
  final Products productExist;
  CreateProducts({this.productExist});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: productExist != null ? 'Add Productos' : 'Actualizar Productos',
        context: context,
        menu: false,
      ),
      body: ProductsForm(productExist: productExist,),
    );
  }
}

class ProductsForm extends StatefulWidget {
  final Products productExist;
  ProductsForm({this.productExist});
  @override
  ProductsFormState createState() {
    return ProductsFormState(productExist: productExist);
  }
}

Categories _category;

class ProductsFormState extends State<ProductsForm> {
  final _formKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final productUnit = TextEditingController();

  Products productExist;
  ProductsFormState({this.productExist});
  @override
  Widget build(BuildContext context) {
    if(productExist != null){
      productName.text = productExist.product;
      productUnit.text = productExist.unit;
      _idCategory = productExist.category;
    }else{
      _idCategory = null;
    }
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
              color: Colors.orange,
              shape: CircleBorder(),
              child: Icon(Icons.add,),
              onPressed: () {//agregar async si se usa el await
                //final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCategory()));
                Navigator.pushNamed(context, '/createCategory');
                //print(result.category);
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
      color: Colors.orange,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          if (_category != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('procesando'),
            ));
            Products productInsert;
            productExist != null ? productInsert = productExist : productInsert = new Products();
            productInsert.product = productName.text;
            productInsert.unit = productUnit.text;
            productInsert.category = _category.id;
            _category = null;
            //bloc.addProductToList(productInsert);
            //productBloc.fetchAllProducts();
            productExist != null ? globalProductsBloc.updateProduct(productInsert) : globalProductsBloc.addProductToList(productInsert);
            _idCategory = null;
            //_nameCategory = null;
            Navigator.pop(context);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Seleccione categoria'),
            ));
          }
        }
      },
      child: productExist != null ? Text('Actualizar') : Text('Agregar'),
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
    getCategorie();
    super.initState();
  }
  
  @override
  void dispose() {
    categoryBloc.dispose();
    super.dispose();
  }

  Future getCategorie() async{
    if(_idCategory != null){
      Observable<List<Categories>> subscription = categoryBloc.allCategories;
      subscription.listen((result){
        for(Categories c in result){
          if(c.id == _idCategory){
            dropdownValue = c;
            break;
          }
        }
      });
    }/*else if(_nameCategory != null){
      Observable<List<Categories>> subscription = categoryBloc.allCategories;
      subscription.listen((result){
        for(Categories c in result){
          if(c.category == _nameCategory){
            dropdownValue = c;
            break;
          }
        }
      });
    }*/
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
      hint: Text('Seleccione Categoria'),
      onChanged: (Categories newValue) {
        setState(() {
         dropdownValue = newValue;
         _category = newValue;
         _idCategory = null;
         //_nameCategory = null;
        });
      },
      items: snapshot.data.map<DropdownMenuItem<Categories>>((Categories value) {
        return DropdownMenuItem<Categories>(
          value: value,
          child: Text(value.category),
          );
      }).toList(),
      value: dropdownValue,
    );
  }
}
