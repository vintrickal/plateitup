import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/meal_recipe_deleted/meal_recipe_deleted_widget.dart';
import '/pages/components/no_request_order_screen/no_request_order_screen_widget.dart';
import '/pages/components/no_sent_activity/no_sent_activity_widget.dart';
import '/pages/components/partner_rating_bottomsheet_component/partner_rating_bottomsheet_component_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'meal_request_notification_screen_widget.dart'
    show MealRequestNotificationScreenWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MealRequestNotificationScreenModel
    extends FlutterFlowModel<MealRequestNotificationScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in meal_request_notification_screen widget.
  PairedUserRecord? sENTPairedUserDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in meal_request_notification_screen widget.
  int? sENTTabCountChecker;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ReceiverNotificationRecord? receiverNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in accept-btn widget.
  SenderNotificationRecord? senderNotificationItem;
  // Stores action output result for [Firestore Query - Query a collection] action in reject-btn widget.
  SenderNotificationRecord? senderNotificationRejectedItem;
  // Stores action output result for [Firestore Query - Query a collection] action in done-btn widget.
  SenderNotificationRecord? senderNotificationDoneItem;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }
}
