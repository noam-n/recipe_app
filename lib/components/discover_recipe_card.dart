// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';

import '../models/recipe_repository.dart';
import '../pages/edit_recipe.dart';

class DiscoverRecipeCard extends StatefulWidget {
  final Recipe recipe;
  final List<Recipe> recipeList; // This is the list of recipes
    final Function(Recipe)? onDelete; // Define the callback

  final User? user = FirebaseAuth.instance.currentUser;

  DiscoverRecipeCard({required this.recipe, required this.recipeList, this.onDelete = null});

  @override
  State<DiscoverRecipeCard> createState() => _DiscoverRecipeCardState();
}

class _DiscoverRecipeCardState extends State<DiscoverRecipeCard> {
  bool isLiked = false;

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
  void initState() {
    super.initState();
    // Call a method to check if the recipe is liked and update isLiked
    checkIfRecipeIsLiked();
  }

  Future<void> checkIfRecipeIsLiked() async {
    if (widget.user != null && widget.recipe.id != null) {
      // Fetch the user's favorites
      final userFavorites = await getUserFavorites(widget.user!.uid);

      // Check if the recipe is in favorites
      setState(() {
        isLiked = userFavorites.contains(widget.recipe.id);
      });
    }
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
                    Flexible(child: Text(' ${widget.recipe.makingTime}')),
                    SizedBox(width: 25),
                    Icon(Icons.hardware),
                    Flexible(child: Text(' ${widget.recipe.difficulty}')),
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
                color: isLiked ? Colors.red : Colors.grey,
                icon: Icon(Icons.favorite),
                onPressed: () async {
                  // Fetch the user's favorites
                  final userFavorites =
                      await getUserFavorites(widget.user!.uid);

                  // Check if the recipe is in favorites
                  bool isRecipeLiked = userFavorites.contains(widget.recipe.id);

                  // If liked, remove from favorites. If not liked, add to favorites.
                  if (widget.recipe.id != null) {
                    // Check if the recipe is already liked
                    if (isRecipeLiked) {
                      // If liked, remove from favorites
                      removeRecipeFromFavorites(
                          widget.user!.uid, widget.recipe.id);
                      // Update isLiked state after successfully removing from favorites
                      setState(() {
                        isLiked = false;
                      });
                    } else {
                      // If not liked, add to favorites
                      addRecipeToFavorites(widget.user!.uid, widget.recipe.id);
                      // Update isLiked state after successfully adding to favorites
                      setState(() {
                        isLiked = true;
                      });
                    }
                  }
                },
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
