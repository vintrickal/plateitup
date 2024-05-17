import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/duplicate_request_message/duplicate_request_message_widget.dart';
import '/pages/components/successfully_sent_component/successfully_sent_component_widget.dart';
import 'confirmation_assign_meal_to_partner_screen_widget.dart'
    show ConfirmationAssignMealToPartnerScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfirmationAssignMealToPartnerScreenModel
    extends FlutterFlowModel<ConfirmationAssignMealToPartnerScreenWidget> {
  ///  Local state fields for this component.

  DocumentReference? pairedUserRef;

  DocumentReference? mealRecipeRef;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in receiver-btn widget.
  int? mealRequestNotificationCOUNT;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  MealRequestedNotificationRecord? createdRequest;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  ReceiverNotificationRecord? receiverNotificationCreation;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  SenderNotificationRecord? senderNotificationCreation;
  // Stores action output result for [Firestore Query - Query a collection] action in receiver-btn widget.
  MealRequestedNotificationRecord? mealRequestedNotificationPENDING;
  // Stores action output result for [Firestore Query - Query a collection] action in receiver-btn widget.
  MealRequestedNotificationRecord? mealRequestedNotificationAPPROVED;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  MealRequestedNotificationRecord? createdRequestChecker;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  ReceiverNotificationRecord? receiverNotificationCreationITEM;
  // Stores action output result for [Backend Call - Create Document] action in receiver-btn widget.
  SenderNotificationRecord? senderNotificationCreationITEM;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
