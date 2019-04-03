import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../data/data_helper.dart';

class CreateBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Marca',
        context: context,
      ),
      body: BrandForm(),
    );
  }
}

class BrandForm extends StatefulWidget {
  @override
  MyBrandFormState createState() {
    return MyBrandFormState();
  }
}

class MyBrandFormState extends State<BrandForm> {
  final _formKey = GlobalKey<FormState>();
  final brandName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: brandName,
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
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  DbHelper db = DbHelper();
                  db.setBrand(brandName.text);
                  Navigator.pushNamed(context, '/');
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