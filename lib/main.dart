import 'package:flutter/material.dart';
import './ui/widgets/myappbar.dart';
import './ui/widgets/create_brand.dart';
import './ui/widgets/create_category.dart';
import './models/brand_model.dart';
import './data/data_helper.dart';
import './ui/widgets/creates.dart';
import './ui/widgets/create_products.dart';
import './ui/widgets/create_prices.dart';
import './ui/widgets/ProductDetail.dart';

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
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                onPressed: () {},
                child: const Text('Search'),
                color: Colors.blueAccent,
                textColor: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: ListProducts(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.pushNamed(context, '/menu');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          color: Colors.blueAccent,
          child: Row(children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: IconButton(
                  icon: Icon(
                    Icons.filter_none,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )),
                Text('marca'),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  ListView _listProduct() => ListView(
        children: <Widget>[
          _tile('papa sin lavar', 'papa', Icons.restaurant),
        ],
      );

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}

class ListProducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListProductsState();
  }
}

class ListProductsState extends State<ListProducts> {
  //List<Brands> _list;
  List<Products> _listProducts;
  //List<Categories> _listCategories;
  DbHelper _dbHelper;

  @override
  Widget build(BuildContext context) {
    return _getList();
  }

  Widget _getList() {
    if (_listProducts == null) {
      return Container(
        height: 10.0,
        width: 10.0,
        child: CircularProgressIndicator(),
      );
    } else if (_listProducts.length == 0) {
      return Text('No hay datos');
    } else {
      return ListView.builder(
        itemCount: _listProducts.length,
        itemBuilder: (BuildContext context, index) {
          Products product = _listProducts[index];
          //return Text(product.product);
          return InkWell(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return ProductDetail(product);
              }));
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.restaurant_menu, color: Colors.blue[300],),
                Text(product.product+'.   ', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),),
                Text(product.unit, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _dbHelper = new DbHelper();
    updateList();
  }

  void updateList() {
    //_dbHelper.getList().then((resultList) {
    _dbHelper.getListProducts().then((resultList) {
      setState(() {
        _listProducts = resultList;
      });
    });
    /*_dbHelper.getListCategories().then((result) {
      setState(() {
        _listCategories = result;
        if (_listCategories.length > 0) {
          print(_listCategories[0].category);
        }
      });
    });*/
  }
}

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: 'Opciones',
        context: context,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: sizeWidth*0.2),
        children: <Widget>[
          RaisedButton(
            child: Text('Add precios'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/createPrices');
            },
          ),
          RaisedButton(
            child: Text('Add producto'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/createProduct');
              },
          ),
          RaisedButton(
            child: Text('Add categoria'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/createCategory');
            },
          ),
          RaisedButton(
            child: Text('Add marca'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBrand()));
              Navigator.pushNamed(context, '/createBrand');
            },
          ),
          RaisedButton(
            child: Text('Add presentacion'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {},
          ),
          RaisedButton(
            child: Text('Add proveedor'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/createProvider');
            },
          ),
        ],
      ),
    );
  }
}
