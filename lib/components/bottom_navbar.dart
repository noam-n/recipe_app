// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../pages/explore_page.dart';
import '../pages/home_page.dart';

class MyBottomNavbar extends StatelessWidget {
  const MyBottomNavbar({super.key});

  void navigateToExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ExplorePage();
        },
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: (int index) {
          if (index == 0) {
            navigateToHome(context);
          }
          if (index == 1) {
            navigateToExplore(context);
          }
        });
  }
}
