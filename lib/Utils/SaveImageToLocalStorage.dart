import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<String> saveImageToLocalStorage(XFile imageFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final fileName = '${imageFile.name}';
  final localPath = '$path/$fileName';

  try {
    final file = File(localPath);
    await file.writeAsBytes(await imageFile.readAsBytes());
    final imagePath = localPath;
    print('Image saved to: $localPath');

    return imagePath;
  } catch (e) {
    print('Error saving image: $e');
    return "Something Wrong!!";
  }
}
