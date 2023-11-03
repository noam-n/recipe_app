// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/components/button.dart';
import 'package:recipe_app/components/square_tile.dart';
import 'package:recipe_app/components/textFeild.dart';
import 'package:recipe_app/pages/home_page.dart';
import 'package:recipe_app/pages/login_page.dart';
//import 'package:recipe_app/pages/register_page.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();

  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ),
    );
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }

  void wrongCredentials(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
        );
      },
    );
  }

  void signUserUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign up
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Add the display name
          User? user = FirebaseAuth.instance.currentUser;
          try {
            await user?.updateDisplayName(firstNameController.text);
            user = FirebaseAuth.instance.currentUser; // Refresh the user object
            // The user's display name has been updated
          } catch (e) {
            print("Error updating display name: $e");
          }

        String? displayN = user?.displayName ?? "Guest";
        // add user details
        addUserDetails(
            displayN, emailController.text.trim());
        // Dismiss the loading dialog
        Navigator.pop(context);

        //move to home page
        navigateToHomePage(context);
      } else {
        // Dismiss the loading dialog
        Navigator.pop(context);

        // show error message
        wrongCredentials('Passwords Dont Match');
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss the loading dialog
      Navigator.pop(context);

      wrongCredentials(e.code.toString());
    }
  }

  Future addUserDetails(String displayName, String email) async {
    await FirebaseFirestore.instance.collection('users').add(
      {
        'displayName': displayName,
        'email': email,
        'userId': FirebaseAuth.instance.currentUser?.uid,
      },
    );
  }

  Future<bool> doesUserExist(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(height: 30),

              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),

              SizedBox(height: 35),

              // welcome message
              Text(
                'Create an Account',
                style: TextStyle(color: Colors.grey[700], fontSize: 18),
              ),

              SizedBox(height: 25),

              //First Name textfeild
              MyTextFeild(
                controller: firstNameController,
                hintText: 'First Name',
                obscureText: false,
              ),

              SizedBox(height: 15),

              //email textfeild
              MyTextFeild(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              SizedBox(height: 15),

              //password textfeild
              MyTextFeild(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              SizedBox(height: 15),

              // Confirm password textfeild
              MyTextFeild(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              SizedBox(height: 40),

              // sign in button
              MyButton(
                buttonText: 'Sign Up',
                onTap: signUserUp,
              ),

              SizedBox(height: 25),

              //or continute with
              Divider(
                thickness: 1.5,
              ),
              Center(child: Text('Or Continue With')),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: 'assets/images/goog.png',
                    onTap: () async {
                      final userCredential =
                          await AuthService().signInWithGoogle();
                      if (userCredential != null) {
                        // Extract user data
                        final user =
                            userCredential.user; // Firebase user object
                        final displayName = user.displayName;
                        final email = user.email;
                        // check if the user email is already in the database
                        final userExists = await doesUserExist(email);
                        if (userExists) {
                          // User already exists; navigate to the main page
                          navigateToHomePage(context);
                        } else {
                          // Create a new user
                          addUserDetails(displayName, email);
                          // Sign-in successful, navigate to the HomePage
                          navigateToHomePage(context);
                        }
                      } else {
                        // Handle sign-in failure
                        wrongCredentials('Google Registration Failed');
                      }
                    },
                  ),
                  SizedBox(width: 20),
                ],
              ),

              SizedBox(height: 15),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      navigateToLogin(context);
                    },
                    child: Text(
                      'Login now',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
