import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/deletion_reminder/deletion_reminder_widget.dart';
import '/pages/components/no_meal_category_found/no_meal_category_found_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'admin_home_widget.dart' show AdminHomeWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminHomeModel extends FlutterFlowModel<AdminHomeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  MealRecipeRecord? mealRecipeItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  SavedRecipeRecord? savedRecipeItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  DeleteAccountRequestRecord? deleteAccountRequestItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}
