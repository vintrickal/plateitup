import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'confirmation_remove_partner_component_widget.dart'
    show ConfirmationRemovePartnerComponentWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfirmationRemovePartnerComponentModel
    extends FlutterFlowModel<ConfirmationRemovePartnerComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PairedUserRecord? userPairedDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? uSERMealNotificationCount;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  MealRequestedNotificationRecord? mealNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PartnerReviewRecord? userPartnerReviewId;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PairedUserRecord? partnerPairedDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? pARTNERMealNotificationCount;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  MealRequestedNotificationRecord? partnerMealNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  PartnerReviewRecord? partnerPartnerReviewId;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? uSERReceiverNotificationCOUNT;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ReceiverNotificationRecord? uSERReceiverNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? uSERSenderNotificationCOUNT;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  SenderNotificationRecord? uSERSenderNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? pARTNERReceiverNotificationCOUNT;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ReceiverNotificationRecord? pARTNERReceiverNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  int? pARTNERSenderNotificationCOUNT;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  SenderNotificationRecord? pARTNERSenderNotificationItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
