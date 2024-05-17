// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:time_picker_spinner/time_picker_spinner.dart';

class CustomTimeSpinner extends StatefulWidget {
  const CustomTimeSpinner({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CustomTimeSpinner> createState() => _CustomTimeSpinnerState();
}

class _CustomTimeSpinnerState extends State<CustomTimeSpinner> {
  DateTime time = DateTime.now();

  @override
  void initState() {
    time = FFAppState().estimatedTimeSpinner!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: TimePickerSpinner(
        alignment: Alignment.center,
        time: time,
        is24HourMode: true,
        normalTextStyle: const TextStyle(fontSize: 25, color: Colors.grey),
        highlightedTextStyle: const TextStyle(
            fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
        spacing: 30,
        itemHeight: 45,
        isForce2Digits: true,
        onTimeChange: (time) {
          setState(() {});
          FFAppState().update(
            () {
              FFAppState().estimatedTimeSpinner = time;
            },
          );
        },
      ),
    );
  }
}
