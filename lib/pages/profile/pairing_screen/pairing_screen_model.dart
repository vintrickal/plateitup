import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'pairing_screen_widget.dart' show PairingScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PairingScreenModel extends FlutterFlowModel<PairingScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in pairing_screen widget.
  PairedUserRecord? partnerStatusQuery;
  // Stores action output result for [Firestore Query - Query a collection] action in IconButton widget.
  PairedUserRecord? establishedPartner;
  // State field(s) for partner-code-textfield widget.
  FocusNode? partnerCodeTextfieldFocusNode;
  TextEditingController? partnerCodeTextfieldTextController;
  String? Function(BuildContext, String?)?
      partnerCodeTextfieldTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  UsersRecord? partnerDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PairedUserRecord? partnerHasExistingPaired;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PairedUserRecord? pairedUserDetails;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PairedUserRecord? pairedUserDetailsPartnerside;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    partnerCodeTextfieldFocusNode?.dispose();
    partnerCodeTextfieldTextController?.dispose();
  }
}
