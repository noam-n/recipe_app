// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/recipe_details.dart';

import '../components/bottom_navbar.dart';
import '../components/discover_recipe_Card.dart';
import '../components/recipe_card.dart';
import '../models/recipe.dart';
import '../models/recipe_repository.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

void signUserOut() {
  FirebaseAuth.instance.signOut();
}

final user = FirebaseAuth.instance.currentUser;

Widget showFavoriteRecipes(List<Recipe>? favoriteRecipes) {
  if (favoriteRecipes != null && favoriteRecipes.isNotEmpty) {
    return Expanded(
      child: ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailsPage(
                      recipe: recipe, isNeedSearchfeild: false),
                ),
              );
            },
            child: DiscoverRecipeCard(
              recipe: recipe,
              recipeList: favoriteRecipes,
              onDelete: (recipe) {
            // Call removeRecipeFromFavorites when onDelete is triggered
            removeRecipeFromFavorites(user!.uid, recipe.id);
          },
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

class _FavoritesPageState extends State<FavoritesPage> {
  final user = FirebaseAuth.instance.currentUser!;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Recipes You Love!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25),
          FutureBuilder<List<Recipe>>(
            future: getUserFavoriteRecipes(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return showFavoriteRecipes(snapshot.data);
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavbar(isRecipeDetailsPage: false),
    );
  }
}
