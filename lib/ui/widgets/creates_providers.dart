import 'package:flutter/material.dart';
import '../../models/models.dart';
import './myappbar.dart';
import '../../bloc/dropdownBloc.dart';

class Creates extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MyAppBar(
        title: 'Add Proveedor',
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
            child: RaisedButton(
              color: Colors.orange,
              onPressed: (){
                Providers provider = new Providers();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  provider.provider = providerName.text;
                  provider.address = providerAddress.text;
                  provider.phone = providerPhone.text;
                  Navigator.pop(context);
                  providerBloc.addProviderToList(provider);
                }
              },
              child: Text('Agregar', style: TextStyle(/*color: Colors.white*/)),
            ),
          ),
        ],
      )
    );
  }
}