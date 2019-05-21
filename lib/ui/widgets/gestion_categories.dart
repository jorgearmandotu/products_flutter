import 'package:flutter/material.dart';
import 'package:products_flutter/ui/widgets/create_category.dart';
import '../widgets/myappbar.dart';
import '../../models/models.dart';
import '../../bloc/category_bloc.dart';

class GestionCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Gestion Categorias',
        context: context,
      ),
      body: CategoriesList(),
    );
  }
}

class  CategoriesList extends StatefulWidget {
    @override
    State<StatefulWidget> createState() {
      return CategoriesState();
    }
  }

  class CategoriesState extends State<CategoriesList> {
  @override
  void initState(){
    categoryBloc.open();
    super.initState();
  }

  @override
  void dispose(){
    categoryBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return StreamBuilder(
      stream: categoryBloc.allCategories,
      builder: (context, AsyncSnapshot<List<Categories>> snapshot){
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
  Widget buildList(AsyncSnapshot<List<Categories>> snapshot){
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index){
        Categories category = snapshot.data[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.category),
            title: Row(children: <Widget>[
              Text(category.category),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateCategory(categoryExist: category,)));
                },
            ),
            ],),
          )
        );
      });
  }
}