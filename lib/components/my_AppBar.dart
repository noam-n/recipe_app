// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final void Function(String) onSearchChanged;
  final bool isNeedSearchfeild;
  final bool isHomepage;
  const MyAppBar(
      {required this.onSearchChanged,
      required this.isNeedSearchfeild,
      required this.isHomepage});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.0); // Set the desired height
}

class _MyAppBarState extends State<MyAppBar> {
  String searchQuery = '';
  var user = FirebaseAuth.instance.currentUser!;
  var displayName = "Guest";

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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

  @override
  void initState() {
    super.initState();
    getDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        // Search bar
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Center(
                child: Visibility(
                  visible: widget.isNeedSearchfeild,
                  child: Container(
                    margin: EdgeInsets.only(right: 20), // Add right margin
                    child: SizedBox(
                      width: 200, // Set a width to limit the search bar
                      child: TextField(
                        onChanged: widget.onSearchChanged, //updateSearchQuery,
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
              ),
              // "Hello displayName" text wrapped in Align widget
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Hey $displayName!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              if(widget.isHomepage)
              IconButton(
                onPressed: signUserOut,
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
