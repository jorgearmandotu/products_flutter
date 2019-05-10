import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({String title, BuildContext context, bool menu}): super(
    title: Text(title),
      centerTitle: true,
      //backgroundColor: Colors.blueGrey,
      actions: menu == true ? <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: (){
            Navigator.pushNamed(context, '/menu');
          },
        )
      ]
      : null,
  );

}
