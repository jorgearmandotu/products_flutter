import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/category_bloc.dart';

class CreateCategory extends StatelessWidget {
  final Categories categoryExist;
  CreateCategory({this.categoryExist});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: MyAppBar(
        title: categoryExist != null ? 'Actualizar Categoria' : 'Add Categoria',
        context: context,
      ),
      body: CategoryForm(categoryExist: categoryExist,),
    );
  }
}

class CategoryForm extends StatefulWidget {
  final Categories categoryExist;
  CategoryForm({this.categoryExist});
  @override
  MyCategoryFormState createState() {
    return MyCategoryFormState(categoryExist: categoryExist);
  }
}

class MyCategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final categoryName = TextEditingController();
  final Categories categoryExist;

  MyCategoryFormState({this.categoryExist});

  @override
  Widget build(BuildContext context) {
    if(categoryExist != null){ categoryName.text = categoryExist.category; }
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
            child: RaisedButton(
              color: Colors.orange,
              onPressed: (){
                Categories category = categoryExist!= null ? categoryExist : new Categories();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  category.category = categoryName.text;
                  categoryExist != null ? categoryBloc.updateCategory(category) : categoryBloc.addCategoryToList(category);
                  Navigator.pop(context);
                }
              },
              child: Text( categoryExist != null ? 'Actualizar' : 'Agregar'),
            ),
          ),
        ],
      )
    );
  }
}