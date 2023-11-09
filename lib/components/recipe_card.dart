// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';

import '../pages/edit_recipe.dart';

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

  void deleteRecipeConfirmation(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Recipe'),
          content: Text(
              'Are you sure you want to delete ${widget.recipe.recipeName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteRecipe(recipeId); // Call the deleteRecipe method
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15, // Add elevation for a shadow effect
      margin: EdgeInsets.fromLTRB(
          60, 20, 60, 20), // Add margin for spacing between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Apply rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the recipe image if available
          //recipeImage()!,

          // First section: Left to Mid (Recipe Name, Making Time, Difficulty)
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe.recipeName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
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
              ],
            ),
          ),

          // Second section: Mid to Right (Image and Delete Button)
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              // Display the recipe image if available
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.recipe.imageURL),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Delete button
              IconButton(
                color: Colors.redAccent,
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Call the deleteRecipe method to remove the recipe from Firestore
                  deleteRecipeConfirmation(context, widget.recipe.id!);
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    navigateToEditPage(context, widget.recipe);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void navigateToEditPage(BuildContext context, Recipe recipe) {
  // Navigate to the EditRecipePage
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditRecipe(recipe: recipe),
    ),
  );
}
