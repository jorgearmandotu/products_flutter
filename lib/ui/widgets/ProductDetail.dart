import 'package:flutter/material.dart';
import '../widgets/myappbar.dart';
import '../../models/models.dart';
import '../../helpers/ColorsList.dart';
import '../widgets/create_prices.dart';
import 'package:intl/intl.dart';
import '../../bloc/listProductDetailBloc.dart';

//Products _productDetail;
class ProductDetail extends StatelessWidget{
  final Products _product;

  ProductDetail(this._product);
  //ProductDetail(Products product){_productDetail = product;}
  
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
  State<StatefulWidget> createState(){
    return DetailProductListState(_product);
  }  
}

class DetailProductListState extends State<DetailProductList>{

  final Products _product;
  DetailProductListState(this._product);

  @override
  void initState() {
    super.initState();
    blocDetailProduct.open();
    blocDetailProduct = ListProductsDetailBloc(id: _product.id);
    //blocDetailProduct.fetchAllproductsDetail(_product.id);
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
      builder: (context, AsyncSnapshot<List<ProductsDetail>> snapshot){
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

  Widget buildList(AsyncSnapshot<List<ProductsDetail>> snapshot){
    CardColor color = new CardColor();
    var money = NumberFormat.simpleCurrency();
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, index){
        ProductsDetail product = snapshot.data[index];
        return Card(
          borderOnForeground: false,
          margin: EdgeInsets.all(10.0),
          color: color.getColorList(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('proveedor: ${product.provider}\nprecio: ${money.format(product.priceUnit)}\nMarca: ${product.brand}\nPresentacion: ${product.presentation}\nOferta: ${money.format(product.promocion)}', style: TextStyle(fontSize: 20.0, color: Colors.white70), textAlign: TextAlign.justify,),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.edit, color: Colors.white), onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePrices(idPrice: product.idPrices,)));
                  },),
                  IconButton(icon: Icon(Icons.delete, color: Colors.white), onPressed: (){},),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}