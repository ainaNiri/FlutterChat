import 'package:flutter/material.dart';

class ListModel extends ChangeNotifier{
  List <String> _lists = [];

  String at(int index){
    return _lists[index];
  }

  void add(String data){
    _lists.add(data);
  }
  void setData(int index, String data){
    _lists[index] = data;
    notifyListeners();
  }
  void clear(){
    _lists.clear();
  }
}
