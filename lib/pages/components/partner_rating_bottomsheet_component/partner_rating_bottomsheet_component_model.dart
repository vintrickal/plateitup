import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/go_to_history_component/go_to_history_component_widget.dart';
import 'partner_rating_bottomsheet_component_widget.dart'
    show PartnerRatingBottomsheetComponentWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PartnerRatingBottomsheetComponentModel
    extends FlutterFlowModel<PartnerRatingBottomsheetComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for meal-rating-star widget.
  double? mealRatingStarValue;
  // State field(s) for feedback-form widget.
  FocusNode? feedbackFormFocusNode;
  TextEditingController? feedbackFormTextController;
  String? Function(BuildContext, String?)? feedbackFormTextControllerValidator;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  PartnerReviewRecord? partnerReviewItemCreated;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    feedbackFormFocusNode?.dispose();
    feedbackFormTextController?.dispose();
  }
}
