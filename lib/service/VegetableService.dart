import 'package:flutter/services.dart';
import 'dart:convert';

class VegetableService {
  List<String> imagePaths = [];
  Future<List<String>> loadAllImagePaths() async {
    final manifestString = await rootBundle.loadString('AssetManifest.json');
    final manifest = json.decode(manifestString) as Map<String, dynamic>;

    final imageKeys = manifest.keys
        .where((key) => key.startsWith('images/images-without-names/'))
        .toList();
    return imageKeys;
  }

  //dummy Data
  Future<Map<String, String>> generateVegetableData() async {
    final imagePaths = await loadAllImagePaths();
    final vegetableData = {
      for (var path in imagePaths) path.split('/').last.split('.').first: path
    };
    return vegetableData;
  }
}
