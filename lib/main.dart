import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/Homepage.dart';
import 'package:vegetable_app_major/RecipePage.dart';
import 'package:vegetable_app_major/ScanPage.dart';
import 'package:vegetable_app_major/SearchPage.dart';

import 'State/Fridge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    ChangeNotifierProvider<Fridge>(
      create: (_) => Fridge(),
      child: const MainPage(), // MyApp becomes a stateless widget
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomNavigationIndex = 0;

  //List<Widget> pagesList = [const LoginPage(),const PasswordValidation(),const RegisterWithPhoneNumber()];
  List<Widget> pagesList = [
    const Homepage(),
    const SearchPage(),
    const ScanPage(),
    const RecipePage(),
    // const FridgePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: pagesList[bottomNavigationIndex],
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) {
              setState(() {
                bottomNavigationIndex = value;
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.search_sharp), label: 'Search'),
              NavigationDestination(icon: Icon(Icons.camera), label: "Scan"),
              NavigationDestination(
                  icon: Icon(Icons.food_bank), label: 'Recipes')
              // NavigationDestination(
              //     icon: Icon(Icons.inventory), label: 'Fridge'),
            ],
          )),
    );
  }
}
