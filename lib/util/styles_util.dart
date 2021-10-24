
import 'package:flutter/material.dart';

class StylesUtil {
  BuildContext context;
  double fontSize;
  FontWeight fontWeight;
  Color color;

  StylesUtil({this.context});

  //homepage styles
  TextStyle carName() {
    return TextStyle(fontWeight: FontWeight.bold);
  }

  TextStyle carType() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  }

  TextStyle what() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0);
  }
}
