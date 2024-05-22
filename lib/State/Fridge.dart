import 'package:flutter/material.dart';
import 'package:vegetable_app_major/model/Vegetable.dart';

//this is our local fridge wher we add vegetables and notify
class Fridge with ChangeNotifier {
  final List<Vegetable> _vegetables = [];

  List<Vegetable> get vegetables => _vegetables.toList();
  //add vegetable to our fridge and change isAdded to True, and notify

  void addVegetable(Vegetable vegetable, BuildContext context) {
    if (_vegetables.indexWhere((element) =>
            element.label.toLowerCase() == vegetable.label.toLowerCase()) !=
        -1) {
      const snackBar = SnackBar(
        content: Text('Vegitable already exists'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    _vegetables.add(vegetable);
    notifyListeners();
  }

  //remove the vegetable name is sameand notify
  void removeVegetable(Vegetable vegetable) {
    _vegetables.removeWhere((v) => v.label == vegetable.label);
    notifyListeners();
  }

  void clearCart() {
    _vegetables.clear();
    notifyListeners();
  }
}
