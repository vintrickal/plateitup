import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/components/request_account_deletion_component/request_account_deletion_component_widget.dart';
import 'profile_deletion_survey_screen_widget.dart'
    show ProfileDeletionSurveyScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileDeletionSurveyScreenModel
    extends FlutterFlowModel<ProfileDeletionSurveyScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for rd-btn-options widget.
  FormFieldController<String>? rdBtnOptionsValueController;
  // State field(s) for other-txtfield widget.
  FocusNode? otherTxtfieldFocusNode;
  TextEditingController? otherTxtfieldTextController;
  String? Function(BuildContext, String?)? otherTxtfieldTextControllerValidator;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // Stores action output result for [Firestore Query - Query a collection] action in proceed-btn widget.
  DeleteAccountRequestRecord? deleteRequestItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    otherTxtfieldFocusNode?.dispose();
    otherTxtfieldTextController?.dispose();

    expandableExpandableController.dispose();
  }

  /// Additional helper methods.
  String? get rdBtnOptionsValue => rdBtnOptionsValueController?.value;
}
