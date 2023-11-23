// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:recipe_app/pages/favorites_page.dart';

import '../pages/discover_page.dart';
import '../pages/home_page.dart';

class MyBottomNavbar extends StatelessWidget {
  final bool
      isRecipeDetailsPage; // Add a flag to indicate if it's the Recipe Details page

  const MyBottomNavbar({super.key, required this.isRecipeDetailsPage});

  void navigateToFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FavoritesPage();
        },
      ),
    );
  }

  void navigateToDiscover(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DiscoverPage();
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
    // Get the current route
    final route = ModalRoute.of(context);

    // Determine the selected index based on the route type
    int selectedIndex = 0; // Default to Home
    if (route is MaterialPageRoute) {
      if (route.builder(context) is FavoritesPage) {
        selectedIndex = 2;
      } else if (route.builder(context) is DiscoverPage) {
        selectedIndex = 1;
      }
    }

    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: (int index) {
          if (index == 0) {
            navigateToHome(context);
          }
          if (index == 1) {
            navigateToDiscover(context);
          }
          if (index == 2) {
            navigateToFavorites(context);
          }
        });
  }
}
