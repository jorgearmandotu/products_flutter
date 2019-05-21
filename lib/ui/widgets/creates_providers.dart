import 'package:flutter/material.dart';
import '../../models/models.dart';
import './myappbar.dart';
import '../../bloc/provider_bloc.dart';

class CreateProvider extends StatelessWidget {
  final Providers providerExist;
  CreateProvider({this.providerExist});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: MyAppBar(
        title: 'Proveedores',
        context: context,
      ),
      body: ProviderForm(providerExist: providerExist,),
    );
  }
}

class ProviderForm extends StatefulWidget {
  final Providers providerExist;
  ProviderForm({this.providerExist});
  @override
  ProviderFormState createState() {
    return ProviderFormState(providerExist: providerExist);
  }
}

class ProviderFormState extends State<ProviderForm> {
  Providers providerExist;
  ProviderFormState({this.providerExist});

  final _formKey = GlobalKey<FormState>();
  final providerName = TextEditingController();
  final providerAddress = TextEditingController();
  final providerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(providerExist != null){
      providerName.text = providerExist.provider;
      providerAddress.text = providerExist.address;
      providerPhone.text = providerExist.phone;
    }
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
                Providers provider;
                providerExist != null ? provider = providerExist : provider = new Providers();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  provider.provider = providerName.text;
                  provider.address = providerAddress.text;
                  provider.phone = providerPhone.text;
                  Navigator.pop(context);
                  providerExist != null ? providerBloc.updateProvider(provider) : providerBloc.addProviderToList(provider);
                }
              },
              child: providerExist != null ? Text('Actualizar',) : Text('Agregar',),
            ),
          ),
        ],
      )
    );
  }
}