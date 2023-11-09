import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? id;
  final String userId;
   String recipeName;
   String makingTime;
   String difficulty;
   String ingredients;
   String instructions;
   String imageURL;

  Recipe({
    this.id,
    required this.recipeName,
    required this.makingTime,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.userId,
    String? imageURL, // Make imageURL nullable
  }) : imageURL = imageURL ?? ''; // Use the null-aware operator to provide a default value


  //map a recipe fetched from Firebase to a Recipe object
  factory Recipe.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Recipe(
      id:           document.id,
      userId:       data['userId'],
      recipeName:   data['name'] ?? 'Unknown Recipe Name', // Provide a default value
      makingTime:   data['makingTime'] ?? 'Unknown Time', // Provide a default value
      difficulty:   data['difficulty'] ?? 'Unknown Difficulty', // Provide a default value
      ingredients:  data['ingredients'] ?? 'Unknown ingredients', // Provide an empty list as default
      instructions: data['instructions'] ?? 'Unknown instructions', // Provide an empty list as default
      imageURL:     data['imageURL'] ?? 'Unknown image', // Provide a default value
    );
  }
}