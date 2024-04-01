import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'State/Fridge.dart';



class FridgePage extends StatelessWidget {
  const FridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Fridge')),
        body: Consumer<Fridge>(
            builder: (context, fridge, child) {
              return ListView.builder(
                  itemCount: fridge.vegetables.length,
                  itemBuilder: (context, index) {
                    final vegetable = fridge.vegetables[index];
                    return Card(
                        child: ListTile(
                            title: Text(vegetable.label),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        fridge.removeVegetable(vegetable),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () async {
                                      // Call prediction logic using your specific implementation
                                      // ...
                                    },)

                                ]
                            ))
                    );
                  }
              );
            }
        )
    );
  }
}