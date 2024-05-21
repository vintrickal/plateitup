import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/edit_meal_rating_bottomsheet_component/edit_meal_rating_bottomsheet_component_widget.dart';
import '/pages/components/meal_rating_bottomsheet_component/meal_rating_bottomsheet_component_widget.dart';
import '/pages/components/option_author_component/option_author_component_widget.dart';
import '/pages/components/option_not_author_component/option_not_author_component_widget.dart';
import '/pages/components/reported_reason_container/reported_reason_container_widget.dart';
import 'dart:math';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import 'details_screen_widget.dart' show DetailsScreenWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetailsScreenModel extends FlutterFlowModel<DetailsScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in details_screen widget.
  PairedUserRecord? pairedUserCollectionDetails;
  // Stores action output result for [Firestore Query - Query a collection] action in details_screen widget.
  int? reviewCount;
  // Stores action output result for [Firestore Query - Query a collection] action in details_screen widget.
  List<ReviewRecord>? onloadReviewList;
  // Stores action output result for [Custom Action - addingStar] action in details_screen widget.
  int? returnedValueAddingStar;
  // Stores action output result for [Custom Action - averageRating] action in details_screen widget.
  double? starAverage;
  // Stores action output result for [Firestore Query - Query a collection] action in details_screen widget.
  ReviewRecord? isReviewExist;
  // Stores action output result for [Firestore Query - Query a collection] action in Row widget.
  PairedUserRecord? doesPairedDataExists;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores action output result for [Backend Call - Create Document] action in liked-icon widget.
  UserReviewLikesRecord? userReviewLiked;

  /// Query cache managers for this widget.

  final _userDisplayNameManager = StreamRequestManager<UsersRecord>();
  Stream<UsersRecord> userDisplayName({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<UsersRecord> Function() requestFn,
  }) =>
      _userDisplayNameManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserDisplayNameCache() => _userDisplayNameManager.clear();
  void clearUserDisplayNameCacheKey(String? uniqueKey) =>
      _userDisplayNameManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();

    /// Dispose query cache managers for this widget.

    clearUserDisplayNameCache();
  }
}
