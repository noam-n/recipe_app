// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/bottom_navbar.dart';
import '../components/button.dart';
import '../components/difficulty_dropdown.dart';
import '../components/makingTime_Picker.dart';
import '../models/recipe.dart';
import 'home_page.dart';

class EditRecipe extends StatefulWidget {
  final Recipe recipe;
  const EditRecipe({super.key, required this.recipe});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late TextEditingController recipeNameController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;

  final _imagePicker = ImagePicker();
  XFile? _selectedImage; // Store the selected image file
  bool _hasImage =
      false; // Class variable to check if an image has been selected
  String selectedTime = 'Not Specified'; // Initialize with a default time
  String difficulty = 'Not Specified';

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void handleTimeSelection(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  void handleDifficultySelection(String _difficulty) {
    setState(() {
      difficulty = _difficulty;
    });
  }

  void _pickImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
        _hasImage = true;
      });
    }
  }

  bool isFormValidated(String recipeName, String ingredients,
      String instructions, String makingTime, String difficulty) {
    // check if the filled form is valid, correct values etc.
    if (recipeName.isEmpty ||
        ingredients.isEmpty ||
        instructions.isEmpty ||
        makingTime.isEmpty ||
        difficulty.isEmpty) {
      return false;
    }
    return true;
  }

  void recipeAddedSuccesfully(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.green,
            title: Text(
              'Recipe Added Successfully',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  navigateToHome(context);
                },
                child: Text(
                  'My Recipes',
                  style: TextStyle(
                      color: Colors.white), // Set button text color to white
                ),
              ),
            ],
          );
        });
  }

  void failedToAddRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Editing Recipe Failed, Check for missing feilds.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                    color: Colors.white), // Set button text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  void finishEditRecipe(String updatedRecipeName, String updatedIngredients,
      String updatedInstructions, String selectedTime, String difficulty) {
    // check the form feils to see if the form is validated
    if (isFormValidated(updatedRecipeName, updatedIngredients,
            updatedInstructions, selectedTime, difficulty) ==
        true) {
      editRecipe(
          updatedRecipeName,
          updatedIngredients,
          updatedInstructions,
          selectedTime,
          difficulty); // implement this method, should be around firestore and stuff
      recipeAddedSuccesfully(context); // implement this method
    } else {
      failedToAddRecipe(context); // implement this method
    }
  }

  void editRecipe(updatedRecipeName, updatedIngredients, updatedInstructions,
      selectedTime, difficulty) {
    // Now you have the updated values, you can update the recipe object
    widget.recipe.recipeName = updatedRecipeName;
    widget.recipe.ingredients = updatedIngredients;
    widget.recipe.instructions = updatedInstructions;
    widget.recipe.makingTime = selectedTime;
    widget.recipe.difficulty = difficulty;

    // Perform any additional logic you may need, such as updating the image
    if (_selectedImage != null) {
      // Update the recipe's image URL
      // Note: You may need to implement a method to upload the new image
      //widget.recipe.imageURL = 'new_image_url_here';
    }

    // Now, you can save the updated recipe back to Firestore or wherever you store your recipes
    // Example: Firestore update code
    FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipe.id!)
        .update({
      'difficulty': difficulty,
      'imageURL': widget.recipe.imageURL, // Update with the new image URL
      'ingredients': updatedIngredients,
      'instructions': updatedInstructions,
      'makingTime': selectedTime,
      'name': updatedRecipeName,
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers here in initState
    recipeNameController =
        TextEditingController(text: widget.recipe.recipeName);
    ingredientsController =
        TextEditingController(text: widget.recipe.ingredients);
    instructionsController =
        TextEditingController(text: widget.recipe.instructions);
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Edit a Recipe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 25),

                TextField(
                  controller: recipeNameController,
                  maxLines: 2,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Recipe name..',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 35),

                TextField(
                  controller: ingredientsController,
                  maxLines: null,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Ingredients..',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 35),

                TextField(
                  controller: instructionsController,
                  maxLines: null,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText:
                        'Making instructions - try being clear and consice!',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 35),

                Text('Making Time'),
                MakingTimePicker(
                  initialValue: widget.recipe.makingTime,
                  onTimeSelected: (time) {
                    handleTimeSelection(time);
                  },
                ),
                SizedBox(height: 35),

                Text('Difficulty'),
                DifficultyDropdown(
                  initialValue: widget.recipe.difficulty,
                  onDifficultySelected: (difficulty) {
                    handleDifficultySelection(difficulty);
                  },
                ),
                SizedBox(height: 35),

                Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Select an Image',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),

                // Display the selected image, if any
                if (_selectedImage != null)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Image.file(
                      File(_selectedImage!.path),
                      height: 100,
                    ),
                  ),

                SizedBox(height: 35),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: MyButton(
                    buttonText: 'Save Changes',
                    onTap: () {
                      finishEditRecipe(
                        recipeNameController.text,
                        ingredientsController.text,
                        instructionsController.text,
                        selectedTime,
                        difficulty,
                      );
                      //widget.onRecipeEdited();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavbar(isRecipeDetailsPage: false),
    );
  }
}
