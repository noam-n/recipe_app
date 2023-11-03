// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.buttonText});
  final String buttonText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: Colors.black,
        borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16),
            ),
        ),
      ),
    );
  }
}
