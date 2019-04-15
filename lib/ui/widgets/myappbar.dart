import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({String title, BuildContext context}): super(
    title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
          },
        ),
      ],
  );

}
