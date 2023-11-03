import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/models/recipe.dart';

final _db = FirebaseFirestore.instance;

// Fetch specific Recipe by recipe name
Future<Recipe> getRecipe(String name) async {
  final snapshot = await _db.collection('recipes').where('name', isEqualTo: name).get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).single;
  return recipeData;
}

// Fetch All Recipes for a given user
Future<List<Recipe>> getUserRecipes(String userId) async {
  final snapshot = await _db.collection('recipes').where('userId', isEqualTo: userId).get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).toList();
  return recipeData;
}

// Fetch specific Recipe by recipe name
Future<List<Recipe>> getAllRecipes() async {
  final snapshot = await _db.collection('recipes').get();
  final recipeData = snapshot.docs.map((e) => Recipe.fromSnapshot(e)).toList();
  return recipeData;
}