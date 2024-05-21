import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'reported_reason_container_widget.dart'
    show ReportedReasonContainerWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReportedReasonContainerModel
    extends FlutterFlowModel<ReportedReasonContainerWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for reported-reason-textfield widget.
  FocusNode? reportedReasonTextfieldFocusNode;
  TextEditingController? reportedReasonTextfieldTextController;
  String? Function(BuildContext, String?)?
      reportedReasonTextfieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    reportedReasonTextfieldFocusNode?.dispose();
    reportedReasonTextfieldTextController?.dispose();
  }
}
