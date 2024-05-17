// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future limitCharacter() async {
  // Generate a function for removing the characters after 20
  String Function(String) removeAfter20 = (String input) {
    if (input.length > 20) {
      return input.substring(0, 20);
    } else {
      return input;
    }
  };
  return removeAfter20;
}
