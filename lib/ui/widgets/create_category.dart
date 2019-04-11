import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../data/data_helper.dart';
import '../../models/brand_model.dart';

class CreateCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Categoria',
        context: context,
      ),
      body: CategoryForm(),
    );
  }
}

class CategoryForm extends StatefulWidget {
  @override
  MyCategoryFormState createState() {
    return MyCategoryFormState();
  }
}

class MyCategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final categoryName = TextEditingController();
  
  DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: categoryName,
            decoration: InputDecoration(
              labelText: 'Categoria:',
            ),
            validator: (value){
              if(value.isEmpty){
                return 'Debe ingresar un nombre de marca valido';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 100.0),
            child: RaisedButton(
              onPressed: (){
                Categories category = new Categories();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  category.category = categoryName.text;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  //Navigator.pop(context);
                  _dataBase.insert(category).then((value) {
                  });
                }
              },
              child: Text('Añadir'),
            ),
          ),
        ],
      )
    );
  }
}