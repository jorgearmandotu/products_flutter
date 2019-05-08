import 'package:flutter/material.dart';
import '../widgets/myappbar.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Opciones',
        context: context,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.symmetric(horizontal: sizeWidth*0.2),
        children: <Widget>[
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add_shopping_cart),
                FlatButton(
                  child: Text('Agregar Productos'),
                  onPressed: () {Navigator.pushNamed(context, '/createProduct');}
                  ,
                )
              ],
            )
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.category),
                FlatButton(
                  child: Text('Agregar Categorias'),
                  onPressed: () {Navigator.pushNamed(context, '/createCategory');}
                  ,
                )
              ],
            )
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.loyalty),
                FlatButton(
                  child: Text('Agregar Marcas'),
                  onPressed: () {Navigator.pushNamed(context, '/createBrand');}
                  ,
                )
              ],
            )
          ),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.store),
                FlatButton(
                  child: Text('Agregar Tiendas'),
                  onPressed: () {Navigator.pushNamed(context, '/createProvider');}
                  ,
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}