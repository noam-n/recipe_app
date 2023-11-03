import 'package:flutter/material.dart';

class DifficultyDropdown extends StatefulWidget {
  final Function(String) onDifficultySelected;

  DifficultyDropdown({required this.onDifficultySelected});

  @override
  _DifficultyDropdownState createState() => _DifficultyDropdownState();
}

class _DifficultyDropdownState extends State<DifficultyDropdown> {
  String selectedDifficulty = 'Not Specified'; // Default selected difficulty

  final List<String> difficultyOptions = ['Not Specified','Beginner', 'Intermediate', 'Expert'];

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