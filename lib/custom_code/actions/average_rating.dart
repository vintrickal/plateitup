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

Future<double> averageRating(
  int totalStar,
  int reviewQuantity,
) async {
  // Add your function code here!
  double result = totalStar / reviewQuantity;
  String inString = result.toStringAsFixed(1);
  double average = double.parse(inString);

  return average;
}
