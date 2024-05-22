import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:developer' as devtools;
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/State/Fridge.dart';
import 'package:vegetable_app_major/model/Vegetable.dart';
import 'package:vegetable_app_major/Utils/SaveImageToLocalStorage.dart';
// https://pub.dev/packages/flutter_tflite

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _picker = ImagePicker();
  XFile? _image;
  File? filePath;
  String label = '';
  double confidence = 0.0;
  final _textController = TextEditingController();
  String? imagePath;

  Future<void> loadModel() async {

    
    String? res = await Tflite.loadModel(
        model: "saved/model_unquant.tflite",
        labels: "saved/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose vegetable image'),
          actions: <Widget>[
            TextButton(
              child: const Text('Camera'),
              onPressed: () {
                getImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () {
                getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: _image == null
                  ? const Text('No image selected.')
                  : Image.file(File(_image!.path)),
            ),
            TextField(
              controller: _textController,
              onChanged: (value) => setState(() {
                _textController.text = value;
              }),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Accuracy is ${confidence.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 12,
            ),
            _image == null
                ? Text("")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (_image != null) {
                           imagePath =  await saveImageToLocalStorage(_image!);

                            final fridgeItem =
                                Provider.of<Fridge>(context, listen: false);
                            final vegetableItem =
                                Vegetable(label: label, image: imagePath!);
                            fridgeItem.addVegetable(vegetableItem, context);
                            print("Added $label");

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${label} Added "),
                            ));
                            _image = null;
                          } else {
                            devtools.log(
                                '${_image.toString()} ${label.toString()}');
                          }
                        },
                        icon: const Icon(Icons.check),
                        color: Colors.green,
                        iconSize: 30,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                            label = '';
                            confidence = 0.0;
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        color: Colors.red,
                        iconSize: 30,
                      ),
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        tooltip: 'Capture Image',
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    var ImageMap = File(image.path);
    setState(() {
      _image = image;
      filePath = ImageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 1, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }

    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = (recognitions[0]['label'].toString().split(" ")[0]);
      _textController.text = label;
    });
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    var ImageMap = File(image.path);
    setState(() {
      _image = image;
      filePath = ImageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 1, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }

    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = (recognitions[0]['label'].toString().split(" ")[0]);
      _textController.text = label;
    });
  }
}
