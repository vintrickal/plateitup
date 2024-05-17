import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/email_verification_sent_component/email_verification_sent_component_widget.dart';
import '/pages/components/upload_image_modal/upload_image_modal_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_profile_screen_widget.dart' show EditProfileScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProfileScreenModel extends FlutterFlowModel<EditProfileScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for display-name-textfield widget.
  FocusNode? displayNameTextfieldFocusNode;
  TextEditingController? displayNameTextfieldTextController;
  String? Function(BuildContext, String?)?
      displayNameTextfieldTextControllerValidator;
  // State field(s) for email-textfield widget.
  FocusNode? emailTextfieldFocusNode;
  TextEditingController? emailTextfieldTextController;
  String? Function(BuildContext, String?)?
      emailTextfieldTextControllerValidator;
  // State field(s) for current-password-textfield widget.
  FocusNode? currentPasswordTextfieldFocusNode;
  TextEditingController? currentPasswordTextfieldTextController;
  late bool currentPasswordTextfieldVisibility;
  String? Function(BuildContext, String?)?
      currentPasswordTextfieldTextControllerValidator;
  // State field(s) for new-password-textfield widget.
  FocusNode? newPasswordTextfieldFocusNode;
  TextEditingController? newPasswordTextfieldTextController;
  late bool newPasswordTextfieldVisibility;
  String? Function(BuildContext, String?)?
      newPasswordTextfieldTextControllerValidator;
  // Stores action output result for [Custom Action - changePassword] action in change-password widget.
  String? changePasswordOutput;

  @override
  void initState(BuildContext context) {
    currentPasswordTextfieldVisibility = false;
    newPasswordTextfieldVisibility = false;
  }

  @override
  void dispose() {
    displayNameTextfieldFocusNode?.dispose();
    displayNameTextfieldTextController?.dispose();

    emailTextfieldFocusNode?.dispose();
    emailTextfieldTextController?.dispose();

    currentPasswordTextfieldFocusNode?.dispose();
    currentPasswordTextfieldTextController?.dispose();

    newPasswordTextfieldFocusNode?.dispose();
    newPasswordTextfieldTextController?.dispose();
  }
}
