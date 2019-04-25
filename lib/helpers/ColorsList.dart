import 'package:flutter/material.dart';
import 'dart:math';

class CardColor {
  static const baseColors = <Color>[
    Color.fromRGBO(61, 132, 223, 1.0), //lightBlue
    Color.fromRGBO(114, 71, 200, 1.0), //purple
    Color.fromRGBO(106, 188, 121, 1.0), //green
    Color.fromRGBO(229, 92, 131, 1.0), //pink
    Color.fromRGBO(96, 200, 227, 1.0), //cyan
    Color.fromRGBO(210, 157, 80, 1.0), //orange
    Color.fromRGBO(60, 61, 63, 1.0), //black
    Color.fromRGBO(222, 80, 116, 1.0), //salmon
    Color.fromRGBO(128, 182, 234, 1.0), //lightCyan
  ];

  getColorList(){
    Color color;
    int index = Random().nextInt(baseColors.length);//el maximo es exclusico el minimo es inclusivo
    color = baseColors[index];
    return color;
  }
}