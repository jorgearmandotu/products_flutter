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
  
  DbHelper _dataBase = new DbHelper();

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
                Tables brand = new Tables();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  //_dataBase.setBrand('nuevaBrand');
                  //_dataBase.setBrand(brandName.text);
                  brand.brand = brandName.text;
                  Navigator.pushNamed(context, '/');
                  _dataBase.insert(brand).then((value) {
                    //ListProductsState.updateList();
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