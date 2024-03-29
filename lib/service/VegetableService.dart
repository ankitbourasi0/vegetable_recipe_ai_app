import '../model/Vegetable.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
class VegetableService{
  List<String> imagePaths = [];
  Future<List<String>> loadAllImagePaths() async {
    final manifestString = await rootBundle.loadString('AssetManifest.json');
    final manifest = json.decode(manifestString) as Map<String, dynamic>;

    final imageKeys = manifest.keys.where((key) =>
        key.startsWith('images/image-with-names/')).toList();
    return imageKeys;
  }

  //dummy Data
  Future<Map<String, String>> generateVegetableData() async {
    final imagePaths = await loadAllImagePaths();
    final vegetableData = Map<String, String>.fromIterable(
      imagePaths,
      key: (path) => path.split('/').last.split('.').first, // Extract label from path
      value: (path) => path,
    );
    return vegetableData;
  }

}