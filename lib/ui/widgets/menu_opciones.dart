import 'package:flutter/material.dart';
import '../widgets/myappbar.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Opciones',
        context: context,
      ),
      body: menu(context),
    );
  }

  Widget menu(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    return GridView.count(
      crossAxisCount: 2,
      padding:
          EdgeInsets.symmetric(horizontal: sizeWidth * 0.2, vertical: 10.0),
      children: <Widget>[
        listData(Icons.add_shopping_cart, 'Agregar Productos', '/createProduct', context),
        listData(Icons.category, 'Agregar Categoria', '/createCategory', context),
        listData(Icons.loyalty, 'Agregar Marcas', '/createBrand', context),
        listData(Icons.store, 'Agregar Tiendas', '/createProvider', context),
      ],
    );
  }

  Widget listData(
      IconData icon, String message, String ruta, BuildContext context) {
    return Card(
      color: Colors.orange,
      child: InkWell(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            Icon(icon),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, ruta);
        },
      ),
    );
  }
}
