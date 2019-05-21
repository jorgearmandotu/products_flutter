import 'package:flutter/material.dart';
import 'package:products_flutter/ui/widgets/create_brand.dart';
import '../widgets/myappbar.dart';
import '../../bloc/brand_bloc.dart';
import '../../models/models.dart';

class GestionBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Gestion Marcas',
        context: context,
      ),
      body: BrandsList(),
    );
  }
}

class  BrandsList extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return BrandState();
    }
  }

class BrandState extends State<BrandsList> {
  @override
  void initState(){
    brandBloc.open();
    super.initState();
  }

  @override
  void dispose(){
    brandBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return StreamBuilder(
      stream: brandBloc.allBrands,
      builder: (context, AsyncSnapshot<List<Brands>> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length>0){
            return buildList(snapshot);
          }
          return Center(child: Text('No se encontraron datos'));
        }else if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()),);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  Widget buildList(AsyncSnapshot<List<Brands>> snapshot){
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index){
        Brands brand = snapshot.data[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.loyalty),
            title: Row(children: <Widget>[
              Text(brand.brand),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBrand(brandExist: brand,)));
                },
            ),
            ],),
          )
        );
      });
  }
}