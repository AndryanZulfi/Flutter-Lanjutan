import 'package:flutter/material.dart';

class CounterModel extends ChangeNotifier{
  int _counter = 0;

  int get counter => _counter;

  void addCounter(){
    _counter++;
    notifyListeners();
  }

  void minCounter(){
    _counter--;
    notifyListeners();
  }
}