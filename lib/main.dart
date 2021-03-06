import 'package:flutter/material.dart';
import 'package:products_flutter/ui/widgets/gestion_brand.dart';
import 'package:products_flutter/ui/widgets/gestion_categories.dart';
import 'package:products_flutter/ui/widgets/myappbar.dart';
import './ui/widgets/create_brand.dart';
import './ui/widgets/create_category.dart';
import './models/models.dart';
import './ui/widgets/creates_providers.dart';
import './ui/widgets/create_products.dart';
import './ui/widgets/create_prices.dart';
import './ui/widgets/ProductDetail.dart';
import './ui/widgets/menu_opciones.dart';
import './ui/widgets/gestion_providers.dart';
import './bloc/products_global_bloc.dart';

void main() => runApp(ProductsApp());

class ProductsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Productos',
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.orange,
        
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProductsView(),
        '/menu': (context) => MenuView(),
        '/createBrand': (context) => CreateBrand(),
        '/createCategory': (context) => CreateCategory(),
        '/createProvider': (context) => CreateProvider(),
        '/createProduct': (context) => CreateProducts(),
        '/createPrices': (context) => CreatePrices(),
        '/gestionProvider': (context) => GestionProviders(),
        '/gestionBrands' : (context) => GestionBrands(),
        '/gestionCategories' : (context) => GestionCategories(),
      },
    );
  }
}

class ProductsView extends StatelessWidget {
  final productName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Productos',
        menu: true,
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: content(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createPrices');
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget content(){
    return Column(
        children: <Widget>[
          Text('buscar'),
          TextField(
                  controller: productName,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    //bloc.fetchAllProducts(nameProduct: value);
                    globalProductsBloc.fetchAllProducts(nameProduct: value);
                  },
                ),
          Expanded(
              child: ListProducts(),
          ),
        ],
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
  void initState() {
    globalProductsBloc.fetchAllProducts();
    super.initState();
  }

   @override
    void dispose(){
      globalProductsBloc.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return _getList();
  }

  Widget _getList() {
    return StreamBuilder(
      stream: globalProductsBloc.allProducts,
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
              globalProductsBloc.fetchAllProducts();
            },
            onLongPress: (){
              
            },
            child:
                ListTile(
                  leading: const Icon(Icons.shopping_cart, /*color: Colors.deepPurple*/),
                  title: Text(product.product, style: TextStyle(fontSize: 18)),
                  subtitle: Row(
                    children: <Widget>[
                      Text(product.unit),
                      IconButton(
                  icon: Icon(Icons.mode_edit),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProducts(productExist: product,)));
                  },
                )
                    ],
                  ) 
                ),
        );
      },
    );
  }
}

