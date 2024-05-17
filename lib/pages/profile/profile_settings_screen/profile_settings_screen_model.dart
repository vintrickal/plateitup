import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/existing_paired_active_alert/existing_paired_active_alert_widget.dart';
import 'profile_settings_screen_widget.dart' show ProfileSettingsScreenWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileSettingsScreenModel
    extends FlutterFlowModel<ProfileSettingsScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in delete-user-container widget.
  PairedUserRecord? receiverPairedDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in delete-user-container widget.
  PairedUserRecord? senderPairedDetails;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
