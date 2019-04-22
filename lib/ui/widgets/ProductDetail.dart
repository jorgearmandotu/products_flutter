import 'package:flutter/material.dart';
import '../widgets/myappbar.dart';
import '../../models/brand_model.dart';
import '../../data/data_helper.dart';

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

List<ProductsDetail> _list;
class DetailProductList extends StatelessWidget{
  final Products _product;
  DetailProductList(this._product);

  @override
  void init() {
    listDetail();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text(_product.product),
        if(_list != null){
          
        }
      ],
    );
  }

  void listDetail(){
    //realizar consulta de datos
    DbHelper _dataBase = new DbHelper();
    _dataBase.getListDetails(_product.id).then((result){
      _list = result;
    });
  }

}