import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/category_bloc.dart';

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
              color: Colors.blueAccent,
              onPressed: (){
                Categories category = new Categories();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  category.category = categoryName.text;
                  //Navigator.popUntil(context, ModalRoute.withName('/'));
                  categoryBloc.addCategoryToList(category);
                  Navigator.pop(context);
                }
              },
              child: Text('Agregar', style: TextStyle(color: Colors.white,)),
            ),
          ),
        ],
      )
    );
  }
}