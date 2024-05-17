import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/flutter_flow/custom_functions.dart' as functions;
import 'sign_up_screen_widget.dart' show SignUpScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreenModel extends FlutterFlowModel<SignUpScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for display-name-signup widget.
  FocusNode? displayNameSignupFocusNode;
  TextEditingController? displayNameSignupTextController;
  String? Function(BuildContext, String?)?
      displayNameSignupTextControllerValidator;
  // State field(s) for emailAddress-signup widget.
  FocusNode? emailAddressSignupFocusNode;
  TextEditingController? emailAddressSignupTextController;
  String? Function(BuildContext, String?)?
      emailAddressSignupTextControllerValidator;
  // State field(s) for password-signup widget.
  FocusNode? passwordSignupFocusNode;
  TextEditingController? passwordSignupTextController;
  late bool passwordSignupVisibility;
  String? Function(BuildContext, String?)?
      passwordSignupTextControllerValidator;
  // State field(s) for confirm-password-signup widget.
  FocusNode? confirmPasswordSignupFocusNode;
  TextEditingController? confirmPasswordSignupTextController;
  late bool confirmPasswordSignupVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordSignupTextControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  SavedRecipeRecord? savedRecipeList;

  @override
  void initState(BuildContext context) {
    passwordSignupVisibility = false;
    confirmPasswordSignupVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    displayNameSignupFocusNode?.dispose();
    displayNameSignupTextController?.dispose();

    emailAddressSignupFocusNode?.dispose();
    emailAddressSignupTextController?.dispose();

    passwordSignupFocusNode?.dispose();
    passwordSignupTextController?.dispose();

    confirmPasswordSignupFocusNode?.dispose();
    confirmPasswordSignupTextController?.dispose();
  }
}
