import 'package:flutter/material.dart';
import 'package:vegetable_app_major/model/Vegetable.dart';
//this is our local fridge wher we add vegetables and notify
class Fridge with ChangeNotifier {
  List<Vegetable> _vegetables = [];

  List<Vegetable> get vegetables => _vegetables.toList();
  //add vegetable to our fridge and change isAdded to True, and notify

  void addVegetable(Vegetable vegetable) {

    _vegetables.add(vegetable);
    notifyListeners();
  }
  //remove the vegetable name is sameand notify
  void removeVegetable(Vegetable vegetable) {
    _vegetables.removeWhere((v) => v.label == vegetable.label);
    notifyListeners();
  }
}