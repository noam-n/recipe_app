// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../pages/explore_page.dart';
import '../pages/home_page.dart';

class MyBottomNavbar extends StatelessWidget {
  final bool isRecipeDetailsPage; // Add a flag to indicate if it's the Recipe Details page

  const MyBottomNavbar({super.key, required this.isRecipeDetailsPage});

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
        selectedItemColor: isRecipeDetailsPage? Colors.grey : Colors.white,
        unselectedItemColor: Colors.grey, // Set color based on the current page,
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
