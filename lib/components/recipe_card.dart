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
      widget.onDelete(
          widget.recipe); // Call the callback to update the list in HomePage
    }).catchError((error) {
      // Handle any potential error during deletion
      print('Error deleting recipe: $error');
    });
  }

  Widget? recipeImage() {
    if (widget.recipe.imageURL.isNotEmpty && widget.recipe.imageURL != 'null') {
      return Image.network(
        widget.recipe.imageURL,
        height: 150, // set height and width as needed
        width: double.infinity,
        fit: BoxFit.contain,
      );
    } // Check if imageURL is not empty
    else {
      return Container(
        height: 150, // set height and width as needed
        color:
            Colors.grey, // You can use a different color or placeholder image
        alignment: Alignment.center,
        child: Text('No Image Available'),
      );
    } // Handle the case when imageURL is empty or null
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Add elevation for a shadow effect
      margin: EdgeInsets.fromLTRB(50,15,50,15), // Add margin for spacing between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Apply rounded corners
      ),
      child: Column(
        children: [
          // Display the recipe image if available
           recipeImage()!,
          ListTile(
            title: Text(
              widget.recipe.recipeName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.watch_later),
                  Text(' ${widget.recipe.makingTime}'),
                ]),
                Row(children: [
                  Icon(Icons.hardware),
                  Text(' ${widget.recipe.difficulty}'),
                  Spacer(),
                  // Add a trash icon button
                  IconButton(
                    color: Colors.redAccent,
                    alignment: Alignment.bottomRight,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Call the deleteRecipe method to remove the recipe from Firestore
                      deleteRecipe(widget.recipe.id!);
                    },
                  ),
                ]),
                //Text('Ingredients: ${widget.recipe.ingredients}'),
                //Text('Instructions: ${widget.recipe.instructions}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
