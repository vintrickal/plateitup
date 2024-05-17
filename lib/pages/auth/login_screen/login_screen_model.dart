import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/flutter_flow/custom_functions.dart' as functions;
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for emailAddress-sign widget.
  FocusNode? emailAddressSignFocusNode;
  TextEditingController? emailAddressSignTextController;
  String? Function(BuildContext, String?)?
      emailAddressSignTextControllerValidator;
  // State field(s) for password-signin widget.
  FocusNode? passwordSigninFocusNode;
  TextEditingController? passwordSigninTextController;
  late bool passwordSigninVisibility;
  String? Function(BuildContext, String?)?
      passwordSigninTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in sign-in-btn widget.
  PairedUserRecord? pairedUserCollectionLogin;
  // Stores action output result for [Backend Call - Create Document] action in continue-with-google-btn widget.
  SavedRecipeRecord? savedRecipeList;

  @override
  void initState(BuildContext context) {
    passwordSigninVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressSignFocusNode?.dispose();
    emailAddressSignTextController?.dispose();

    passwordSigninFocusNode?.dispose();
    passwordSigninTextController?.dispose();
  }
}
