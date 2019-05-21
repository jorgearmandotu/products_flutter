import 'package:flutter/material.dart';
//import 'package:products_flutter/data/data_helper.dart';
//import 'package:flutter/rendering.dart';
import 'package:products_flutter/models/models.dart';
import '../widgets/myappbar.dart';
import '../../bloc/provider_bloc.dart';
import '../widgets/creates_providers.dart';

class GestionProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Gestion Proveedores',
        context: context,
      ),
      body: ProviderList(),
    );
  } 
}

class ProviderList extends StatefulWidget{
    @override
    State<StatefulWidget> createState(){
      return ProvidersState();
    }
  }

class ProvidersState extends State<ProviderList> {

  @override
  void initState(){
    providerBloc.open();
    super.initState();
  }

  @override
  void dispose() {
    providerBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return StreamBuilder(
      stream: providerBloc.allProviders,
      builder: (context, AsyncSnapshot<List<Providers>> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length > 0){
            return buildList(snapshot);
          }else{
            return Center(child: Text('no hay datos'));
          }
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(AsyncSnapshot<List<Providers>> snapshot){
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index){
        Providers provider = snapshot.data[index];
        return Card(child: ListTile(
          leading: const Icon(Icons.store),
          title: Text(provider.provider),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Direccion: ${provider.address}\nTelefono: ${provider.phone}'),
              IconButton(icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProvider(providerExist: provider)));
                },
                ),
              /*IconButton(icon: Icon(Icons.delete),
              onPressed: (){
                DbHelper dataDb = new DbHelper();
                dataDb.delete(provider);
                },
              ),*/
            ],
          ),
        ),);
      },
    );
  }
}