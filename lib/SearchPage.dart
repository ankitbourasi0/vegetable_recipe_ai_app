import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/State/Fridge.dart';
import 'package:vegetable_app_major/service/VegetableService.dart';

import 'model/Vegetable.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  VegetableService service = VegetableService();
  List<Vegetable> vegetables = [];
  @override
  void initState() {
    super.initState();
    gettingData(); // Call gettingData on widget initialization
  }

// Usage:
  Future<void> gettingData() async {
    final vegetableData = await service.generateVegetableData();
    // Now you can use the vegetableData map for your dummy data

    vegetables = vegetableData.entries.map((entry) {
      return Vegetable(
        label: entry.key,
        image: entry.value,
      );
    }).toList();

    // Use the vegetables list for your search functionality
  }

  // Sample data for searching

  List<Vegetable> filteredData = [];

  // Function to filter data based on search query
  void filterData(String query) {
    filteredData = vegetables
        .where((vegetable) =>
            vegetable.label.toLowerCase().contains(query.toLowerCase()))
        .map((vegetable) => Vegetable(
            label: vegetable.label,
            image: vegetable.image)) // Extract vegetable names and image path
        .toList();
    setState(() {}); // Update UI with filtered data
  }

  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            child: Align(
                alignment: const AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'What you bring\n \t today?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 6, 18, 4),
                        child: Container(
                          height: 50, // Adjust height as needed
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Light gray background
                            borderRadius: BorderRadius.circular(12),
                            // Rounded corners
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  decoration: const InputDecoration(
                                      hintText: "Search",
                                      prefixIcon: Icon(Icons.search),
                                      border: InputBorder.none),
                                  onChanged: (value) => filterData(value),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                          child: ListView.builder(
                              itemCount: _textController.text.isEmpty
                                  ? vegetables.length
                                  : filteredData.length,
                              itemBuilder: (context, index) {
                                final item = _textController.text.isEmpty
                                    ? vegetables[index]
                                    : filteredData[index];

                                return ListBody(
                                    mainAxis: Axis.vertical,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 6, 10, 6),
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image(
                                              image: AssetImage(item.image),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                            item.label,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 22),
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                // Get the CartProvider instance
                                                final fridgeItem = Provider.of<Fridge>(context, listen: false);
                                                final vegetableItem = Vegetable(label: item.label,image: item.image);
                                                fridgeItem.addVegetable(vegetableItem);
                                                print("Added ${item.label}");
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                              ),
                                              color: Colors.amberAccent,
                                              iconSize: 30,
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState
                                                            .hovered)) {
                                                      return Colors
                                                          .lightGreenAccent
                                                          .withOpacity(0.12);
                                                    }
                                                    if (states.contains(
                                                            MaterialState
                                                                .focused) ||
                                                        states.contains(
                                                            MaterialState
                                                                .pressed)) {
                                                      return Colors
                                                          .lightGreenAccent
                                                          .withOpacity(1.0);
                                                    }
                                                    return Colors
                                                        .lightGreenAccent
                                                        .withOpacity(
                                                            0.80); // Defer to the widget's default.
                                                  },
                                                ),
                                              )),
                                          // focusColor,
                                          // hoverColor,

                                          // splashColor,
                                          // disabledColor
                                        ),
                                      ),
                                    ]);
                                // If the search field has text, item is a Map
                              }),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

Widget vegCard(String imagePath, String title) {
  print("$imagePath + $title");
  return Container(
    width: double.maxFinite,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(20),
      shape: BoxShape.rectangle,
    ),
    child: Stack(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: AssetImage(imagePath),
              width: 375,
              height: 518,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
