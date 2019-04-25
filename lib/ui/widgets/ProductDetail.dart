import 'package:flutter/material.dart';
import '../widgets/myappbar.dart';
import '../../models/models.dart';
import '../../data/data_helper.dart';
import '../../helpers/ColorsList.dart';

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

  List<ProductsDetail> _list;

  @override
  void initState() {
    super.initState();
    listDetail();
  }
  
  @override
  Widget build(BuildContext context) {
    CardColor color = new CardColor();
    if(_list != null) {
      return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, index){
          ProductsDetail product = _list[index];
          return  Card( 
              borderOnForeground: false,
              margin: EdgeInsets.all(10.0),
              color: color.getColorList(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('proveedor: ${product.provider}\nprecio: \$${product.priceUnit}\nMarca: ${product.brand}\nPresentacion: ${product.presentation}\nOferta: \$${product.promocion}', style: TextStyle(fontSize: 20.0, color: Colors.white70), textAlign: TextAlign.justify,),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.edit, color: Colors.white), onPressed: (){},),
                    IconButton(icon: Icon(Icons.delete, color: Colors.white), onPressed: (){},),
                  ],
                )
              ],
            ));
        }
      );
    }
    else
    {
      return ListView(
        children: <Widget>[
          Text(_product.product),
        ],
      );
    }
  }

  void listDetail(){
    //realizar consulta de datos
    DbHelper _dataBase = new DbHelper();
    _dataBase.getListDetails(_product.id).then((result){
      setState(() {
       _list = result;
      });
    });
  }

}