import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/service/VegetableService.dart';

import 'State/Fridge.dart';
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

  List<String> filteredData = [];

  // Function to filter data based on search query
  void filterData(String query) {
    filteredData = vegetables
        .where((vegetable) =>
            vegetable.label.toLowerCase().contains(query.toLowerCase()))
        .map((vegetable) => vegetable.label) // Extract only vegetable names
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
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'What to eat\n \t today?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ),
                      SizedBox(
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
                                  decoration: InputDecoration(
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
                            itemCount: _textController.text.isEmpty ? vegetables.length : filteredData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:  Text(_textController.text.isEmpty
                                    ? vegetables[index].label
                                    : filteredData[index]), // Use vegetables or filteredData accordingly,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
