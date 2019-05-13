import 'package:flutter/material.dart';
import 'package:products_flutter/bloc/products_global_bloc.dart';
import '../widgets/myappbar.dart';
import '../../models/models.dart';
import '../../helpers/ColorsList.dart';
import '../widgets/create_prices.dart';
import 'package:intl/intl.dart';
import '../../bloc/listProductDetailBloc.dart';

class ProductDetail extends StatelessWidget {
  final Products _product;

  ProductDetail(this._product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: _product.product,
        context: context,
      ),
      body: DetailProductList(_product),
    );
  }
}

class DetailProductList extends StatefulWidget {
  final Products _product;
  DetailProductList(this._product);

  @override
  State<StatefulWidget> createState() {
    return DetailProductListState(_product);
  }
}

class DetailProductListState extends State<DetailProductList> {
  final Products _product;
  DetailProductListState(this._product);

  @override
  void initState() {
    super.initState();
    blocDetailProduct.open();
    blocDetailProduct = ListProductsDetailBloc(id: _product.id);
  }

  @override
  void dispose() {
    blocDetailProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getList();
  }

  Widget _getList() {
    return StreamBuilder(
      stream: blocDetailProduct.detailProducts,
      builder: (context, AsyncSnapshot<List<ProductsDetail>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? buildList(snapshot)
              : buildMessage();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildList(AsyncSnapshot<List<ProductsDetail>> snapshot) {
    CardColor color = new CardColor();
    var money = NumberFormat.simpleCurrency();
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index) {
        ProductsDetail product = snapshot.data[index];
        return Card(
          borderOnForeground: false,
          margin: EdgeInsets.all(10.0),
          color: color.getColorList(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'proveedor: ${product.provider}\nprecio: ${money.format(product.priceUnit)}\nMarca: ${product.brand}\nPresentacion: ${product.presentation}\nOferta: ${money.format(product.promocion)}',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
                textAlign: TextAlign.justify,
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreatePrices(
                                idPrice: product.idPrices,
                              )));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      blocDetailProduct.deleteProductDetail(product.idPrices);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildMessage() {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        color: Colors.teal,
        child: Container(
          padding: EdgeInsets.all(20.0),
          height: 240.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info,
                size: 52.0,
                color: Colors.white,
              ),
              Text(
                'No hay valores agregados\npara este producto',
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_circle_outline, size: 32.0, color: Colors.white,),
                        Text(
                          'Agregar\nvalores',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, '/createPrices', arguments: <String, Products>{'prod' : _product});
                      Navigator. push(context, MaterialPageRoute(builder: (context)=>CreatePrices(prod: _product)));
                    },
                  ),
                  Container(width: 20.0),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.delete_forever, size: 32.0, color: Colors.white),
                        Text(
                          'Eliminar\nProducto',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      blocDetailProduct.deleteProduct(_product);
                      Navigator.pop(context);
                      globalProductsBloc.fetchAllProducts();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
