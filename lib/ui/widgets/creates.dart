import 'package:flutter/material.dart';
import '../../data/data_helper.dart';
import '../../models/brand_model.dart';
import './myappbar.dart';

class Creates extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    //return AlertDialog(
    //  title: Text('Agregar'),
    //  content: ProviderForm(),
    //);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Provider',
        context: context,
      ),
      body: ProviderForm(),
    );
  }
}

class ProviderForm extends StatefulWidget {
  @override
  ProviderFormState createState() {
    return ProviderFormState();
  }
}

class ProviderFormState extends State<ProviderForm> {
  final _formKey = GlobalKey<FormState>();
  final providerName = TextEditingController();
  final providerAddress = TextEditingController();
  final providerPhone = TextEditingController();
  
  DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: providerName,
            decoration: InputDecoration(
              labelText: 'Proveedor',
            ),
            validator: (value){
              if(value.isEmpty){
                return 'Debe ingresar un nombre de proveedor valido';
              }
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Direccion:'
            ),
            controller: providerAddress,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Telefono:'
            ),
            controller: providerPhone,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 100.0),
            child: RaisedButton(
              onPressed: (){
                Providers provider = new Providers();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  provider.provider = providerName.text;
                  provider.address = providerAddress.text;
                  provider.phone = providerPhone.text;
                  Navigator.pop(context);
                  //Navigator.pop(context);
                  _dataBase.insert(provider).then((value) {
                    //actuaizar lista
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