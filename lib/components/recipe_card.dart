// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final List<Recipe> recipeList; // This is the list of recipes
  final Function(Recipe) onDelete; // Define the callback

  RecipeCard(
      {required this.recipe, required this.recipeList, required this.onDelete});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void deleteRecipe(String recipeId) {
    final collectionRef = FirebaseFirestore.instance.collection('recipes');

    // Delete the recipe document from the collection

    collectionRef.doc(recipeId).delete().then((value) {
      // Remove the deleted recipe from the list
      widget.onDelete(widget.recipe); // Call the callback to update the list in HomePage
    }).catchError((error) {
      // Handle any potential error during deletion
      print('Error deleting recipe: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add elevation for a shadow effect
      margin: EdgeInsets.all(10), // Add margin for spacing between cards
      child: Column(
        children: [
          // Display the recipe image if available
          if (widget.recipe.imageURL.isNotEmpty &&
              widget.recipe.imageURL !=
                  'null') // Check if imageURL is not empty
            Image.network(
              widget.recipe.imageURL,
              height: 150, // set height and width as needed
              width: double.infinity,
              fit: BoxFit.contain,
            )
          else // Handle the case when imageURL is empty or null
            Container(
              height: 150, // set height and width as needed
              color: Colors
                  .grey, // You can use a different color or placeholder image
              alignment: Alignment.center,
              child: Text('No Image Available'),
            ),
          ListTile(
            title: Text(widget.recipe.recipeName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Making Time: ${widget.recipe.makingTime}'),
                Text('Difficulty: ${widget.recipe.difficulty}'),
                Text('Ingredients: ${widget.recipe.ingredients}'),
                Text('Instructions: ${widget.recipe.instructions}'),

                // Add a trash icon button
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Call the deleteRecipe method to remove the recipe from Firestore
                    deleteRecipe(widget.recipe.id!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
