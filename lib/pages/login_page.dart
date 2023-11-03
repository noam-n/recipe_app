// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/components/button.dart';
import 'package:recipe_app/components/square_tile.dart';
import 'package:recipe_app/components/textFeild.dart';
import 'package:recipe_app/pages/home_page.dart';
import 'package:recipe_app/pages/register_page.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RegisterPage();
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

  void wrongCredentials() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incorrect Login Credentials'),
        );
      },
    );
  }

  void signUserIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // remove the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException {
      Navigator.pop(context);
      wrongCredentials();
    }
  }

  Future<bool> doesUserExist(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future addUserDetails(String displayName, String email) async {
    await FirebaseFirestore.instance.collection('users').add(
      {
        'displayName': displayName,
        'email': email,
      },
    );
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
              SizedBox(height: 50),

              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),

              SizedBox(height: 50),

              // welcome message
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(color: Colors.grey[700], fontSize: 18),
              ),

              SizedBox(height: 25),

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

              SizedBox(height: 40),

              // sign in button
              MyButton(
                buttonText: 'Sign In',
                onTap: signUserIn,
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
                        final user =
                            userCredential.user; // Firebase user object
                        final displayName = user.displayName;
                        final email = user.email;
                        // check if the user email is already in the database
                        final userExists = await doesUserExist(email);
                        if (userExists) {
                          // User already exists; navigate to the main page
                          navigateToHome(context);
                        } else {
                          // Create a new user
                          addUserDetails(displayName, email);
                          // Sign-in successful, navigate to the HomePage
                          navigateToHome(context);
                        }
                      } else {
                        // display an error message
                        wrongCredentials();
                      }
                    },
                  ),
                ],
              ),

              SizedBox(height: 15),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?'),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      navigateToRegister(context);
                    },
                    child: Text(
                      'Register now',
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
