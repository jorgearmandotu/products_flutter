import 'package:flutter/material.dart';
import './ui/widgets/myappbar.dart';
import './ui/widgets/create_brand.dart';

void main() => runApp(ProductsApp());

class ProductsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Productos',
      initialRoute: '/',
      routes: {
        '/': (context) => ProductsView(),
        '/menu': (context) => MenuView(),
        '/createBrand': (context) => CreateBrand(),
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
            child: _listProduct(),
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

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: 'Opciones',
          context: context,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Add precios'),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {},
              ),
              RaisedButton(
                child: Text('Add producto'),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {},
              ),
              RaisedButton(
                child: Text('Add categoria'),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {},
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
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
