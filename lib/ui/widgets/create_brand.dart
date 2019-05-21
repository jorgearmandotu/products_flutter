import 'package:flutter/material.dart';
import './myappbar.dart';
import '../../models/models.dart';
import '../../bloc/brand_bloc.dart';

class CreateBrand extends StatelessWidget {
  final Brands brandExist;
  CreateBrand({this.brandExist});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: MyAppBar(
        title: brandExist == null ? 'Add Marca' : 'Actualizar Marca',
        context: context,
      ),
      body: BrandForm(brandExist),
    );
  }
}

class BrandForm extends StatefulWidget {
  final Brands brandExist;
  BrandForm(this.brandExist);
  @override
  MyBrandFormState createState() {
    return MyBrandFormState(brandExist);
  }
}

class MyBrandFormState extends State<BrandForm> {
  Brands brandExist;
  MyBrandFormState(this.brandExist);
  final _formKey = GlobalKey<FormState>();
  final brandName = TextEditingController();

  @override
  void initState() {
    brandBloc.open();
    super.initState();
  }

  @override
  void dispose(){
    brandBloc.dispose();
    super.dispose();
  }
  
  //DbHelper _dataBase = new DbHelper();

  @override
  Widget build(BuildContext context) {
    if(brandExist != null) {
      brandName.text = brandExist.brand;
    }
    return Form(
      key: _formKey,
      child:ListView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Marca:'
            ),
            controller: brandName,
            validator: (value){
              if(value.isEmpty){
                return 'Debe ingresar un nombre de marca valido';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0),
            child: RaisedButton(
              color: Colors.orange,
              onPressed: (){
                Brands brand;
                brandExist != null ? brand = brandExist : brand = new Brands();
                if(_formKey.currentState.validate()) {
                  Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('procesando'),));
                  brand.brand = brandName.text;
                  brandExist != null ? brandBloc.updateBrand(brand) : brandBloc.addBrandsToList(brand);
                  Navigator.pop(context);
                }
              },
              child: brandExist == null ? Text('Agregar',) : Text('Actualizar'),
            ),
          ),
        ],
      )
    );
  }
}