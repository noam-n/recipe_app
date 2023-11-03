// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/components/textFeild.dart';
import 'package:recipe_app/components/button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../components/difficulty_dropdown.dart';
import '../components/makingTime_Picker.dart';
import 'home_page.dart';

class AddRecipePage extends StatefulWidget {
  final Function() onRecipeAdded; // Callback function to notify HomePage
  AddRecipePage({required this.onRecipeAdded});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  String selectedTime = 'Not Specified'; // Initialize with a default time
  String difficulty = 'Not Specified';

  // Initialize with a default difficulty
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

  final recipeNameController = TextEditingController();

  final ingredientsController = TextEditingController();

  final instructionsController = TextEditingController();

  final makingTimeController = TextEditingController();

  final difficultyController = TextEditingController();

  final _imagePicker = ImagePicker();
  XFile? _selectedImage; // Store the selected image file

  String _imageURL = '';
  bool _hasImage =
      false; // Class variable to check if an image has been selected

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

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

  void addRecipeToDB() async {
    //write the logic to add the recipe to the database
    final recipeName = recipeNameController.text;
    final ingredients = ingredientsController.text;
    final instructions = instructionsController.text;
    final makingTime = selectedTime;
    final difficulty = this.difficulty;
    String imageURL =
        _hasImage ? _selectedImage!.path : 'assets/images/DefaultImage.png';
    // Upload the image to Firebase Storage and get the URL

    if (_selectedImage != null) {
      final imageFile = File(_selectedImage!.path);
      imageURL = await uploadImageToStorage(imageFile);
      // Now we can use the 'imageFile' to work with the selected image.
    }

    // Create a map representing the recipe data
    final recipeData = {
      'name': recipeName,
      'ingredients': ingredients,
      'instructions': instructions,
      'makingTime': makingTime,
      'difficulty': difficulty,
      'imageURL': imageURL,
      'userId': FirebaseAuth.instance.currentUser?.uid, // Set the user's ID
    };

    // Add the recipe data to the "recipes" collection
    _firestore.collection('recipes').add(recipeData).then((docRef) {
      // Recipe has been added, you can use docRef.id if needed.
      print('Recipe added with ID: ${docRef.id}');
      print("User: ${FirebaseAuth.instance.currentUser?.uid}");
      print("Display Name: ${FirebaseAuth.instance.currentUser?.displayName}");
    }).catchError((error) {
      // Handle the error if the recipe couldn't be added.
      print('Error adding recipe: $error');
    });
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final Reference storageReference = storage
          .ref()
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() => null);
      final imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return 'null'; // Return null to handle errors
    }
  }

  void failedToAddRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Adding Recipe Failed, Check for missing feilds.',
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

  void addRecipe(String recipeName, String ingredients, String instructions,
      String makingTime, String difficulty) {
    // check the form feils to see if the form is validated
    if (isFormValidated(
            recipeName, ingredients, instructions, makingTime, difficulty) ==
        true) {
      addRecipeToDB();
      recipeAddedSuccesfully(context);
    } else {
      failedToAddRecipe(context);
    }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Add a Recipe!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyTextFeild(
                controller: recipeNameController,
                hintText: 'Recipe Name',
                obscureText: false,
              ),
              SizedBox(height: 20),

              MyTextFeild(
                controller: ingredientsController,
                hintText: 'Ingredients',
                obscureText: false,
              ),
              SizedBox(height: 20),

              MyTextFeild(
                controller: instructionsController,
                hintText: 'Making Instructions',
                obscureText: false,
              ),
              SizedBox(height: 20),

              Text('Making Time'),
              MakingTimePicker(
                onTimeSelected: (time) {
                  handleTimeSelection(time);
                },
              ),
              SizedBox(height: 20),

              Text('Difficulty'),
              DifficultyDropdown(
                onDifficultySelected: (difficulty) {
                  handleDifficultySelection(difficulty);
                },
              ),
              SizedBox(height: 20),

              // You can add the image selector input here
              Container(
                padding: EdgeInsets.all(25),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text('Select an Image'),
                ),
              ),
              // Display the selected image, if any
              if (_selectedImage != null)
                Image.file(
                  File(_selectedImage!.path),
                  height: 100, // Adjust the height as needed
                ),

              SizedBox(height: 20),
              MyButton(
                buttonText: 'Finish',
                onTap: () {
                  // Add your logic to save the recipe to Firestore
                  addRecipe(
                      recipeNameController.text,
                      ingredientsController.text,
                      instructionsController.text,
                      selectedTime,
                      difficulty);
                  widget.onRecipeAdded();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
