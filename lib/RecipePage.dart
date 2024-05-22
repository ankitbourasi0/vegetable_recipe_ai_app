import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/State/Fridge.dart';
import 'package:vegetable_app_major/Utils/LoadingExample.dart';
import 'package:vegetable_app_major/service/RecipeService.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late TextEditingController controller;
  late FocusNode focusNode;
  final List<String> inputTags = [];
  String response = '';
  double kSpacing = 20.00;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void showModalBottomSheetIngredients(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildIngredientSelectionSheet(),
    );
  }

  Widget _buildIngredientSelectionSheet() {
    late List<bool> switchValues;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Select Ingredients from Fridge',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Consumer<Fridge>(builder: (context, fridge, child) {
              if (fridge.vegetables.isNotEmpty) {
                switchValues = List.filled(fridge.vegetables.length, false);
              } else {
                switchValues = [];
              }
              return ListView.builder(
                itemCount: fridge.vegetables.length,
                itemBuilder: (context, index) {
                  final item = fridge.vegetables[index];
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return ListTile(
                        title: Text(item.label),
                        trailing: Switch(
                          value: switchValues[index],
                          onChanged: (value) {
                            setState(() {
                              switchValues[index] = value;
                            });
                            if (value) {
                              this.setState(() {
                                inputTags.add(item.label);
                              });
                            } else {
                              this.setState(() {
                                inputTags.remove(item.label);
                              });
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0), // Adjust padding as needed
        child: Column(
          children: [
            const Text(
              'Find the best recipe for cooking!',
              maxLines: 3,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    autofocus: true,
                    autocorrect: true,
                    focusNode: focusNode,
                    controller: controller,
                    onFieldSubmitted: (value) {
                      controller.clear();
                      setState(() {
                        inputTags.add(value);
                        focusNode.requestFocus();
                      });
                      print(inputTags);
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.5),
                          bottomLeft: Radius.circular(5.5),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          inputTags.add(controller.text);
                          controller.clear();
                          focusNode.requestFocus();
                        });
                        print(inputTags);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheetIngredients(context);
                },
                child: Text("Add from Fridge!")),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
                children: [
                  for (int i = 0; i < inputTags.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Chip(
                        backgroundColor:
                            Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        onDeleted: () {
                          setState(() {
                            inputTags.remove(inputTags[i]);
                            print(inputTags);
                          });
                        },
                        label: Text(inputTags[i]),
                        deleteIcon: const Icon(Icons.close, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            HeightSpacer(myHeight: kSpacing / 2),
            Expanded(
              child: SingleChildScrollView(
                // Wrap with SingleChildScrollView for scrolling
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    response,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            HeightSpacer(myHeight: kSpacing / 2),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome),
                      WidthSpacer(myWidth: kSpacing / 2),
                      const Text('Create Recipe')
                    ],
                  ),
                  onPressed: () async {
                    setState(() {
                      response = "Finding recipes";
                    });
                    var temp = await RecipeServiceImplementation()
                        .askAI(inputTags.toString());
                    setState(() {
                      response = temp;
                    });
                  }),
            )
          ],
        ),
      )),
    );
  }
}

class HeightSpacer extends StatelessWidget {
  final double myHeight;
  const HeightSpacer({Key? key, required this.myHeight}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: myHeight,
    );
  }
}

class WidthSpacer extends StatelessWidget {
  final double myWidth;
  const WidthSpacer({Key? key, required this.myWidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: myWidth,
    );
  }
}
