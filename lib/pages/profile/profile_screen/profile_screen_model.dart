import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/confirmation_remove_partner_component/confirmation_remove_partner_component_widget.dart';
import '/pages/components/resend_email_component/resend_email_component_widget.dart';
import 'dart:math';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import 'profile_screen_widget.dart' show ProfileScreenWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreenModel extends FlutterFlowModel<ProfileScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in profile_screen widget.
  PairedUserRecord? doesPairedDataExists;
  // State field(s) for owner-tabBar widget.
  TabController? ownerTabBarController;
  int get ownerTabBarCurrentIndex =>
      ownerTabBarController != null ? ownerTabBarController!.index : 0;

  // State field(s) for visitor-tabBar widget.
  TabController? visitorTabBarController;
  int get visitorTabBarCurrentIndex =>
      visitorTabBarController != null ? visitorTabBarController!.index : 0;

  /// Query cache managers for this widget.

  final _profileManager = StreamRequestManager<UsersRecord>();
  Stream<UsersRecord> profile({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<UsersRecord> Function() requestFn,
  }) =>
      _profileManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearProfileCache() => _profileManager.clear();
  void clearProfileCacheKey(String? uniqueKey) =>
      _profileManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    ownerTabBarController?.dispose();
    visitorTabBarController?.dispose();

    /// Dispose query cache managers for this widget.

    clearProfileCache();
  }
}
