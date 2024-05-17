import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/no_meal_category_found/no_meal_category_found_widget.dart';
import '/pages/components/no_search_results_component/no_search_results_component_widget.dart';
import '/pages/components/resend_email_component/resend_email_component_widget.dart';
import 'dart:math';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:async';
import 'home_widget.dart' show HomeWidget;
import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  int? pairedUserChecker;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  PairedUserRecord? pairedUserCollectionReceiver;
  Completer<int>? firestoreRequestCompleter;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  int? cOUNTReceiver;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  int? cOUNTSender;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  SenderNotificationRecord? senderDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  int? cOUNTInsideSenderLoop;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  ReceiverNotificationRecord? receiverDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in home widget.
  int? cOUNTInsideReceiverLoop;
  // Stores action output result for [Firestore Query - Query a collection] action in avatar widget.
  PairedUserRecord? doesPairedDataExists;
  // State field(s) for search-recipe-text widget.
  FocusNode? searchRecipeTextFocusNode;
  TextEditingController? searchRecipeTextTextController;
  String? Function(BuildContext, String?)?
      searchRecipeTextTextControllerValidator;
  List<MealRecipeRecord> simpleSearchResults = [];
  // Stores action output result for [Firestore Query - Query a collection] action in refresh-icon widget.
  PairedUserRecord? rEFRESHPairedUserCollectionReceiver;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // Stores action output result for [Firestore Query - Query a collection] action in Container widget.
  List<MealRecipeRecord>? mealFilteredByCategory;
  // Stores action output result for [Backend Call - Create Document] action in FloatingActionButton widget.
  MealRecipeRecord? createdMealRecipeCollection;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    searchRecipeTextFocusNode?.dispose();
    searchRecipeTextTextController?.dispose();

    expandableExpandableController.dispose();
  }

  /// Additional helper methods.
  Future waitForFirestoreRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = firestoreRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
