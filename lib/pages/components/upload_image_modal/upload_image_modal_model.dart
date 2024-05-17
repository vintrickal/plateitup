import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'upload_image_modal_widget.dart' show UploadImageModalWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadImageModalModel extends FlutterFlowModel<UploadImageModalWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for modalUrlTextField widget.
  FocusNode? modalUrlTextFieldFocusNode;
  TextEditingController? modalUrlTextFieldTextController;
  String? Function(BuildContext, String?)?
      modalUrlTextFieldTextControllerValidator;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    modalUrlTextFieldFocusNode?.dispose();
    modalUrlTextFieldTextController?.dispose();
  }
}
