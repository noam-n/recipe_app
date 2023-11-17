// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe.dart';

final _db = FirebaseFirestore.instance;

// Fetch specific Recipe by recipe name
Future<Recipe> getRecipe(String name) async {
  final snapshot =
      await _db.collection('recipes').where('name', isEqualTo: name).get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).single;
  return recipeData;
}

Future<List<Recipe>> getUserFavoriteRecipes(String userId) async {
  final userFavoritesDoc = _db.collection('favorites').doc(userId);
    final userFavoritesSnapshot = await userFavoritesDoc.get();

    if (userFavoritesSnapshot.exists) {
      final userFavoritesData =
          userFavoritesSnapshot.data() as Map<String, dynamic>;
      List<String> favoriteRecipeIds =
          List<String>.from(userFavoritesData['favoriteRecipes'] ?? []);

      // Use Future.wait to wait for all the futures to complete
      List<Recipe?> recipes =
          await Future.wait(favoriteRecipeIds.map((recipeId) => getRecipeById(recipeId)));

      // Remove null values (recipes that couldn't be found)
      List<Recipe> favoriteRecipes = recipes.whereType<Recipe>().toList();

      return favoriteRecipes;
    } else {
      return [];
    }
}

Future<Recipe?> getRecipeById(String recipeId) async {
  // Get a reference to the recipe document
  DocumentSnapshot<Map<String, dynamic>> recipeSnapshot =
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();

  // Check if the recipe exists
  if (recipeSnapshot.exists) {
    // Convert the recipe document to a Recipe object
    Recipe recipe = Recipe.fromSnapshot(recipeSnapshot);
    return recipe;
  } else {
    // Recipe does not exist
    return null;
  }
}

// Fetch All Recipes for a given user
Future<List<Recipe>> getUserRecipes(String userId) async {
  final snapshot =
      await _db.collection('recipes').where('userId', isEqualTo: userId).get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).toList();
  return recipeData;
}

// Fetch specific Recipe by recipe name
Future<List<Recipe>> getAllRecipes() async {
  final snapshot = await _db.collection('recipes').get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).toList();
  return recipeData;
}

// Fetch all recipes not uploaded by the current user
Future<List<Recipe>> getNonUserRecipes(String currentUserId) async {
  final snapshot = await _db.collection('recipes').get();
  final recipeData = snapshot.docs
      .where((doc) =>
          doc['userId'] != null &&
          doc['userId'] !=
              currentUserId) // filter out recipes with missing userId
      .map((e) => Recipe.fromSnapshot(e))
      .toList();
  return recipeData;
}

Future<void> addRecipeToFavorites(String userId, String? recipeId) async {
  // Get a reference to the user's favorites document
  final userFavoritesDoc = _db.collection('favorites').doc(userId);

  // Get the current list of favorite recipes
  final userFavoritesSnapshot = await userFavoritesDoc.get();
  if (!userFavoritesSnapshot.exists) {
    // If not, create a new favorites document
    await userFavoritesDoc.set({'favoriteRecipes': []});
  }
  final userFavoritesData =
      userFavoritesSnapshot.data() as Map<String, dynamic>;
  List<String> currentFavorites =
      List<String>.from(userFavoritesData['favoriteRecipes'] ?? []);

  // Add the new recipe ID to the list
  currentFavorites.add(recipeId!);

  print('userID:' + userId);
  print('recipeID:' + recipeId);

  // Update the favorites document with the new list
  await userFavoritesDoc.update({'favoriteRecipes': currentFavorites});
}

Future<void> removeRecipeFromFavorites(String userId, String? recipeId) async {
  // Get a reference to the user's favorites document
  final userFavoritesDoc = _db.collection('favorites').doc(userId);

  // Get the current list of favorite recipes
  final userFavoritesSnapshot = await userFavoritesDoc.get();
  if (!userFavoritesSnapshot.exists) {
    // Handle the case when the document doesn't exist (optional)
    print('User favorites document does not exist.');
    return;
  }

  final userFavoritesData =
      userFavoritesSnapshot.data() as Map<String, dynamic>;
  List<String> currentFavorites =
      List<String>.from(userFavoritesData['favoriteRecipes'] ?? []);

  // Remove the recipe ID from the list
  currentFavorites.remove(recipeId);

  print('userID:' + userId);
  print('recipeID:' + recipeId! + 'has been removed');

  // Update the favorites document with the new list
  await userFavoritesDoc.update({'favoriteRecipes': currentFavorites});
}

Future<List<String>> getUserFavorites(String userId) async {
  try {
    // Get a reference to the user's favorites document
    final userFavoritesDoc = _db.collection('favorites').doc(userId);

    // Get the user's favorites document
    final userFavoritesSnapshot = await userFavoritesDoc.get();

    if (userFavoritesSnapshot.exists) {
      // If the document exists, return the list of favorite recipes
      final userFavoritesData =
          userFavoritesSnapshot.data() as Map<String, dynamic>;
      List<String> favoriteRecipes =
          List<String>.from(userFavoritesData['favoriteRecipes'] ?? []);
      return favoriteRecipes;
    } else {
      // If the document doesn't exist, return an empty list
      return [];
    }
  } catch (error) {
    print('Error getting user favorites: $error');
    throw error;
  }
}
