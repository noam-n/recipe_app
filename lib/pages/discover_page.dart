// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/recipe_details.dart';
import '../components/bottom_navbar.dart';
import '../components/discover_recipe_card.dart';
import '../components/my_AppBar.dart';
import '../models/recipe.dart';
import '../models/recipe_repository.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<Recipe> recipes = [];
  String searchQuery = '';
  var user = FirebaseAuth.instance.currentUser!;

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Recipe> getFilteredRecipes() {
    return recipes.where((recipe) {
      return recipe.recipeName
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  Widget showAllRecipes() {
    if (recipes.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(
                      recipe: recipe,
                      isNeedSearchfeild: true,
                    ),
                  ),
                );
              },
              child: DiscoverRecipeCard(
                recipe: recipe,
                recipeList: recipes,
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text('No recipes available.'),
      );
    }
  }

  Widget showFilteredRecipes(List<Recipe> filteredRecipes) {
    if (filteredRecipes.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(
                        recipe: recipe, isNeedSearchfeild: true),
                  ),
                );
              },
              child: DiscoverRecipeCard(
                recipe: recipe,
                recipeList: filteredRecipes,
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text('No recipes available.'),
      );
    }
  }

  // Method to fetch user recipes and update the 'recipes' list
  Future<void> _fetchUserRecipes(String userId) async {
    final nonUserRecipes = await getNonUserRecipes(userId);
    setState(() {
      recipes = nonUserRecipes;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserRecipes(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes =
        searchQuery.isEmpty ? recipes : getFilteredRecipes();

    return Scaffold(
      appBar: MyAppBar(
        isNeedSearchfeild: true,
        onSearchChanged: updateSearchQuery,
        isHomepage: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Discover new tastes..",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25),
          if (searchQuery.isEmpty)
            showAllRecipes()
          else
            showFilteredRecipes(filteredRecipes),
        ],
      ),
      bottomNavigationBar: MyBottomNavbar(isRecipeDetailsPage: false),
    );
  }
}
