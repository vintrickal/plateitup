import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'modal_video_link_template_widget.dart'
    show ModalVideoLinkTemplateWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ModalVideoLinkTemplateModel
    extends FlutterFlowModel<ModalVideoLinkTemplateWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for videolink widget.
  FocusNode? videolinkFocusNode;
  TextEditingController? videolinkTextController;
  String? Function(BuildContext, String?)? videolinkTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    videolinkFocusNode?.dispose();
    videolinkTextController?.dispose();
  }
}
