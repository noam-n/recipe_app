// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

class DifficultyDropdown extends StatefulWidget {
  final Function(String) onDifficultySelected;
    final String initialValue;

  DifficultyDropdown({required this.onDifficultySelected, required this.initialValue});

  @override
  _DifficultyDropdownState createState() => _DifficultyDropdownState();
}

class _DifficultyDropdownState extends State<DifficultyDropdown> {
  String selectedDifficulty = 'Not Specified'; // Default selected difficulty

  final List<String> difficultyOptions = ['Not Specified','Beginner', 'Intermediate', 'Expert'];

  @override
  void initState() {
    super.initState();
    selectedDifficulty = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedDifficulty,
      onChanged: (String? value) {
        setState(() {
          selectedDifficulty = value!;
          widget.onDifficultySelected(selectedDifficulty);
        });
      },
      items: difficultyOptions.map((String difficulty) {
        return DropdownMenuItem<String>(
          value: difficulty,
          child: Text(difficulty),
        );
      }).toList(),
    );
  }
}