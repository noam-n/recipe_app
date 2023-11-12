// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:recipe_app/components/my_appBar.dart';
import 'package:recipe_app/models/recipe.dart';
import '../components/bottom_navbar.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  final bool isNeedSearchfeild;
  const RecipeDetailsPage(
      {super.key, required this.recipe, required this.isNeedSearchfeild});
  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  String searchQuery = '';

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          onSearchChanged: updateSearchQuery,
          isNeedSearchfeild: false,
          isHomepage: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                widget.recipe.recipeName, //displaying recipe name as title
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.watch_later),
                Text(' ${widget.recipe.makingTime}'),
                SizedBox(width: 25),
                Icon(Icons.hardware),
                Text(' ${widget.recipe.difficulty}'),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              height: 300,
              width: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.recipe.imageURL),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Display Ingredients
            SizedBox(height: 25),

            Align(
              alignment: Alignment
                  .centerLeft, // Align the following widgets to the left
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width >= 600 ? 60.0 : 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    Text(
                      'Ingredients',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.recipe
                          .ingredients, // Display ingredients as multi-line text
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 35),

                    // Display instructions
                    Text(
                      'Making Instructions',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.recipe
                          .instructions, // Display ingredients as multi-line text
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavbar(isRecipeDetailsPage: true),
    );
  }
}
