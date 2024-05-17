import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

int incrementSteps(int value) {
  return ++value;
}

bool? httpChecker(String? http) {
  bool val;
  val = http!.contains('https://');
  return val;
}

String? generateRandomString() {
  var r = math.Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(5, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String? notificationTime(DateTime? dateContent) {
  String timeElapsed = 'No data';

  if (dateContent == null) {
    timeElapsed = '0 seconds ago';
  } else {
    int differenceTime = DateTime.now().difference(dateContent!).inSeconds;

    if (differenceTime < 60) {
      timeElapsed = differenceTime.toString();
      timeElapsed = timeElapsed + ' seconds ago';
    } else if (differenceTime >= 60 && differenceTime < 120) {
      int minutes = (differenceTime / 60).floor();
      timeElapsed = minutes.toString();
      timeElapsed = timeElapsed + ' minute ago';
    } else if (differenceTime >= 60 && differenceTime < 3600) {
      int minutes = (differenceTime / 60).floor();
      timeElapsed = minutes.toString();
      timeElapsed = timeElapsed + ' minutes ago';
    } else if (differenceTime >= 3600 && differenceTime < 7200) {
      int hour = (differenceTime / 3600).floor();
      timeElapsed = hour.toString();
      timeElapsed = timeElapsed + ' hour ago';
    } else if (differenceTime >= 7200 && differenceTime < 86400) {
      int hours = (differenceTime / 7200).floor();
      timeElapsed = hours.toString();
      timeElapsed = timeElapsed + ' hours ago';
    } else if (differenceTime >= 86400 && differenceTime < 172800) {
      int day = (differenceTime / 86400).floor();
      timeElapsed = day.toString();
      timeElapsed = timeElapsed + ' day ago';
    } else if (differenceTime >= 172800 && differenceTime < 604800) {
      int days = (differenceTime / 172800).floor();
      timeElapsed = days.toString();
      timeElapsed = timeElapsed + ' days ago';
    } else if (differenceTime >= 604800 && differenceTime < 1209600) {
      int week = (differenceTime / 604800).floor();
      timeElapsed = week.toString();
      timeElapsed = timeElapsed + ' week ago';
    } else if (differenceTime >= 1209600) {
      int weeks = (differenceTime / 1209600).floor();
      timeElapsed = weeks.toString();
      timeElapsed = timeElapsed + ' weeks ago';
    }
  }

  // timeElapsed = differenceTime.toString();

  return timeElapsed;
}

bool? validatePassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

String? limitCharacterFunc(String input) {
  if (input.length > 20) {
    return input.substring(0, 20);
  } else {
    return input;
  }
}
