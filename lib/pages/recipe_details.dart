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

  Widget displayInstructions() {
    final instructionsList = widget.recipe.instructions.split('\n');

    // Create a list of widgets for the instructions
    List<Widget> instructionWidgets = [];

    instructionWidgets.add(SizedBox(height: 25));
    instructionWidgets.add(Text(
      'Instructions',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ));
    instructionWidgets.add(SizedBox(height: 10));

    for (int i = 0; i < instructionsList.length; i++) {
      final step = instructionsList[i];
      instructionWidgets.add(ListTile(
        leading: CircleAvatar(
          child: Text((i + 1).toString()), // Display step number
        ),
        title: Text(step),
      ));
    }

    // Return a Column containing the list of instruction widgets
    return Column(children: instructionWidgets);
  }

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsList = widget.recipe.ingredients.split(' ');
    //final instructionsList = widget.recipe.instructions.split('\n');

    return Scaffold(
      appBar: MyAppBar(
          onSearchChanged: updateSearchQuery, isNeedSearchfeild: false),
      body: Column(
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
          Text(
            'Ingredients',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          for (final ingredient in ingredientsList)
            ListTile(
              leading: Icon(Icons.add),
              title: Text(ingredient),
            ),
          displayInstructions(),
        ],
      ),
      bottomNavigationBar: MyBottomNavbar(isRecipeDetailsPage: true),
    );
  }
}
