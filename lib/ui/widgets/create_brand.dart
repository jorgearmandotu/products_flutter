import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/brand_bloc.dart';

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
  void initState() {
    brandBloc.open();
    super.initState();
  }

  @override
  void dispose(){
    brandBloc.dispose();
    super.dispose();
  }
  
  //DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Marca:'
            ),
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
              color: Colors.blueAccent,
              onPressed: (){
                Brands brand = new Brands();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  brand.brand = brandName.text;
                  brandBloc.addBrandsToList(brand);
                  Navigator.pop(context);
                  /*_dataBase.insert(brand).then((value) {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  });*/
                }
              },
              child: Text('Agregar', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      )
    );
  }
}