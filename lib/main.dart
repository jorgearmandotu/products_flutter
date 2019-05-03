import 'package:flutter/material.dart';
import './ui/widgets/myappbar.dart';
import './ui/widgets/create_brand.dart';
import './ui/widgets/create_category.dart';
import './models/models.dart';
import './ui/widgets/creates_providers.dart';
import './ui/widgets/create_products.dart';
import './ui/widgets/create_prices.dart';
import './ui/widgets/ProductDetail.dart';
import './bloc/ListDetailBloc.dart';

void main() => runApp(ProductsApp());

class ProductsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Productos',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProductsView(),
        '/menu': (context) => MenuView(),
        '/createBrand': (context) => CreateBrand(),
        '/createCategory': (context) => CreateCategory(),
        '/createProvider': (context) => Creates(),
        '/createProduct': (context) => CreateProducts(),
        '/createPrices': (context) => CreatePrices(),
      },
    );
  }
}

class ProductsView extends StatelessWidget {

  final productName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
                  controller: productName,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    bloc.fetchAllProducts(nameProduct: value);
                  },
                ),
          Expanded(
            child: Container(
              child: ListProducts(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.pushNamed(context, '/createPrices');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ListProducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListProductsState();
  }
}

class ListProductsState extends State<ListProducts> {

  @override
  Widget build(BuildContext context) {
    return _getList();
  }

  Widget _getList() {
    return StreamBuilder(
      stream: bloc.allProducts,
      builder: (context, AsyncSnapshot<List<Products>> snapshot){
        if(snapshot.hasData){
           return buildList(snapshot);
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget buildList(AsyncSnapshot<List<Products>> snapshot){
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index){
        Products product = snapshot.data[index];
        return InkWell(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return ProductDetail(product);
              }));
            },
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.deepPurple,),
              title: Text(product.product, style: TextStyle(fontSize: 18)),
              subtitle: Text(product.unit),
            )
          );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.fetchAllProducts();
  }

   @override
    void dispose(){
      bloc.dispose();
      super.dispose();
    }
}

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
          /*RaisedButton(
            child: Text('Add proveedor'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/createProvider');
            },
          ),*/
        ],
      ),
    );
  }
}
