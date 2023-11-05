// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/models/recipe_repository.dart';
import 'package:recipe_app/pages/explore_page.dart';
import '../components/bottom_navbar.dart';
import '../components/recipe_card.dart';
import 'add_recipe.dart';
import 'recipe_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = FirebaseAuth.instance.currentUser!;
  var displayName = "Guest";
  List<Recipe> recipes = [];
  String searchQuery = '';

  void navigateToExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ExplorePage();
        },
      ),
    );
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

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Recipe> getFilteredRecipes() {
    return recipes.where((recipe) {
      return recipe.recipeName
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getDisplayName();
    _fetchUserRecipes(user.uid);
  }

  // Method to fetch user recipes and update the 'recipes' list
  Future<void> _fetchUserRecipes(String userId) async {
    final userRecipes = await getUserRecipes(userId);
    setState(() {
      recipes = userRecipes;
    });
  }

  String getDisplayName() {
    if (user.displayName != null) {
      setState(() {
        displayName = user.displayName ??
            "Guest"; // Update displayName and trigger a rebuild
      });
    }
    return displayName;
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void navigateToAddRecipePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddRecipePage(onRecipeAdded: () {
            //callback function to fetch user recipes after new recipe was added
            _fetchUserRecipes(user.uid);
          });
        },
      ),
    );
  }

  void deleteRecipeFromList(Recipe recipe) {
    setState(() {
      recipes.remove(recipe);
    });
  }

  Widget showAllRecipes() {
    if (recipes.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe),
                  ),
                );
              },
              child: RecipeCard(
                recipe: recipe,
                recipeList: recipes,
                onDelete: deleteRecipeFromList, // Pass the callback function
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text('No recipes available.'),
      );
    }
  }

  Widget showFilteredRecipes(List<Recipe> filteredRecipes) {
    if (filteredRecipes.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe),
                  ),
                );
              },
              child: RecipeCard(
                recipe: recipe,
                recipeList: filteredRecipes,
                onDelete: deleteRecipeFromList,
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text('No recipes available.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes =
        searchQuery.isEmpty ? recipes : getFilteredRecipes();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          // Search bar
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 20), // Add right margin
                    child: SizedBox(
                      width: 200, // Set a width to limit the search bar
                      child: TextField(
                        onChanged: updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search recipes...',
                          filled: true,
                          fillColor: Colors.grey,
                          contentPadding: EdgeInsets.all(10), // Adjust padding
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Add rounded corners
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // "Hello displayName" text wrapped in Align widget
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "Hey ${displayName}!",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: signUserOut,
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          Align(
            alignment: Alignment.center,
            child: Text(
              "My Recipes",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 25),
          if (searchQuery.isEmpty)
            showAllRecipes()
          else
            showFilteredRecipes(filteredRecipes),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => navigateToAddRecipePage(context),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: MyBottomNavbar(),
    );
  }
}
