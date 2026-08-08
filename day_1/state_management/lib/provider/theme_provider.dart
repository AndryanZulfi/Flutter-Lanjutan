import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier{
  Color textColor = Colors.red;

  void changeTextColor(int number){
    textColor = number.isEven ? Colors.red : Colors.blue;
    
  }
}