import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_app_major/FridgePage.dart';
import 'package:vegetable_app_major/Homepage.dart';
import 'package:vegetable_app_major/Screens/LoginPage.dart';
import 'package:vegetable_app_major/Screens/PasswordValidation.dart';
import 'package:vegetable_app_major/Screens/RegisterWithPhoneNumber.dart';
import 'package:vegetable_app_major/SearchPage.dart';
import 'package:vegetable_app_major/SettingsPage.dart';
import 'package:vegetable_app_major/State/FrigeProvider.dart';

import 'State/Fridge.dart';

void main() {
  runApp( ChangeNotifierProvider<Fridge>(
    create: (_) => Fridge(),
    child: MainPage(), // MyApp becomes a stateless widget
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

  List<Widget> pagesList = [LoginPage(),PasswordValidation(),RegisterWithPhoneNumber()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pagesList[bottomNavigationIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              bottomNavigationIndex = index;
            });
          },
          currentIndex: bottomNavigationIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_sharp), label: 'Search'),
         //   BottomNavigationBarItem(
           //     icon: Icon(Icons.settings), label: 'Settings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory), label: 'Fridge'),
          ],
        ),
      ),
    );
  }
}
