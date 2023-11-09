// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';

class MakingTimePicker extends StatefulWidget {
  final Function(String) onTimeSelected;
  final String initialValue;

  MakingTimePicker({required this.onTimeSelected, required this.initialValue});

  @override
  _MakingTimePickerState createState() => _MakingTimePickerState();
}

class _MakingTimePickerState extends State<MakingTimePicker> {
  String selectedTime = 'Not Specified'; // Default selected time

  final List<String> timeOptions = [
    'Not Specified',
    '5 minutes',
    '10 minutes',
    '15 minutes',
    '20 minutes',
    '30 minutes',
    '45 minutes',
    '1 hour',
    '1.5 hours',
    '2 hours+',
  ];

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTime,
      onChanged: (String? value) {
        setState(() {
          selectedTime = value!;
          widget.onTimeSelected(selectedTime);
        });
      },
      items: timeOptions.map((String time) {
        return DropdownMenuItem<String>(
          value: time,
          child: Text(time),
        );
      }).toList(),
    );
  }
}
