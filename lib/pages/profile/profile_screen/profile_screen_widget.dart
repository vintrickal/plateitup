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
import 'profile_screen_model.dart';
export 'profile_screen_model.dart';

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({
    super.key,
    required this.userDocRef,
    this.partnerRef,
    int? tabIndex,
  }) : this.tabIndex = tabIndex ?? 0;

  final DocumentReference? userDocRef;
  final DocumentReference? partnerRef;
  final int tabIndex;

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget>
    with TickerProviderStateMixin {
  late ProfileScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.doesPairedDataExists = await queryPairedUserRecordOnce(
        queryBuilder: (pairedUserRecord) => pairedUserRecord.where(
          'recipient',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if ((_model.doesPairedDataExists != null) == true) {
        setState(() {
          FFAppState().hasPartner = true;
        });
      } else {
        setState(() {
          FFAppState().hasPartner = false;
        });
      }

      setState(() {
        _model.ownerTabBarController!.animateTo(
          widget.tabIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    });

    _model.ownerTabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.visitorTabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<UsersRecord>(
      stream: _model.profile(
        requestFn: () => UsersRecord.getDocument(widget.userDocRef!),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).success,
                  ),
                ),
              ),
            ),
          );
        }
        final profileScreenUsersRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              iconTheme: IconThemeData(
                  color: FlutterFlowTheme.of(context).primaryText),
              automaticallyImplyLeading: false,
              leading: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed('home');
                },
                child: Icon(
                  Icons.arrow_back,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
              actions: [
                Visibility(
                  visible: widget.userDocRef == currentUserReference,
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            'profile_settings_screen',
                            queryParameters: {
                              'userRef': serializeParam(
                                currentUserReference,
                                ParamType.DocumentReference,
                              ),
                            }.withoutNulls,
                          );
                        },
                        child: Icon(
                          Icons.settings_sharp,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 310.0,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 500),
                              fadeOutDuration: Duration(milliseconds: 500),
                              imageUrl: profileScreenUsersRecord.coverPhotoUrl,
                              width: double.infinity,
                              height: 200.0,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/error_image.png',
                                width: double.infinity,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              if (widget.userDocRef == currentUserReference)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 1.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 180.0,
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Material(
                                                    color: Colors.transparent,
                                                    elevation: 0.0,
                                                    shape: const CircleBorder(),
                                                    child: Container(
                                                      width: 120.0,
                                                      height: 120.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            imageUrl:
                                                                profileScreenUsersRecord
                                                                    .photoUrl,
                                                            width: 200.0,
                                                            height: 200.0,
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/error_image.png',
                                                              width: 200.0,
                                                              height: 200.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: AutoSizeText(
                                                        profileScreenUsersRecord
                                                            .displayName,
                                                        maxLines: 1,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .headlineSmall
                                                            .override(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                        minFontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              '&',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 24.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  if ((FFAppState()
                                                              .hasPartner ==
                                                          true) &&
                                                      (widget.userDocRef !=
                                                          widget.partnerRef))
                                                    Builder(
                                                      builder: (context) =>
                                                          StreamBuilder<
                                                              UsersRecord>(
                                                        stream: UsersRecord
                                                            .getDocument(widget
                                                                .partnerRef!),
                                                        builder: (context,
                                                            snapshot) {
                                                          // Customize what your widget looks like when it's loading.
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                              child: SizedBox(
                                                                width: 24.0,
                                                                height: 24.0,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<
                                                                          Color>(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .success,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          final partnerDetailsContainerUsersRecord =
                                                              snapshot.data!;
                                                          return InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (dialogContext) {
                                                                  return Dialog(
                                                                    elevation:
                                                                        0,
                                                                    insetPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0)
                                                                        .resolve(
                                                                            Directionality.of(context)),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap: () => _model
                                                                              .unfocusNode
                                                                              .canRequestFocus
                                                                          ? FocusScope.of(context).requestFocus(_model
                                                                              .unfocusNode)
                                                                          : FocusScope.of(context)
                                                                              .unfocus(),
                                                                      child:
                                                                          ConfirmationRemovePartnerComponentWidget(
                                                                        displayName: _model
                                                                            .doesPairedDataExists!
                                                                            .senderName,
                                                                        pairedUserRef: _model
                                                                            .doesPairedDataExists!
                                                                            .reference,
                                                                        partnerUserRef:
                                                                            widget.partnerRef!,
                                                                        userDocRef:
                                                                            widget.userDocRef!,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).then((value) =>
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        140.0,
                                                                    height:
                                                                        156.0,
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              1.0,
                                                                              1.0),
                                                                      children: [
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                0.0,
                                                                            shape:
                                                                                const CircleBorder(),
                                                                            child:
                                                                                Container(
                                                                              width: 120.0,
                                                                              height: 120.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                shape: BoxShape.circle,
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  width: 2.0,
                                                                                ),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.all(4.0),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(50.0),
                                                                                  child: CachedNetworkImage(
                                                                                    fadeInDuration: Duration(milliseconds: 500),
                                                                                    fadeOutDuration: Duration(milliseconds: 500),
                                                                                    imageUrl: partnerDetailsContainerUsersRecord.photoUrl,
                                                                                    width: 200.0,
                                                                                    height: 200.0,
                                                                                    fit: BoxFit.cover,
                                                                                    errorWidget: (context, error, stackTrace) => Image.asset(
                                                                                      'assets/images/error_image.png',
                                                                                      width: 200.0,
                                                                                      height: 200.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (FFAppState().hasPartner ==
                                                                            true)
                                                                          Align(
                                                                            alignment:
                                                                                AlignmentDirectional(1.0, 0.0),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 42.0, 0.0, 0.0),
                                                                              child: Container(
                                                                                width: 28.0,
                                                                                height: 28.0,
                                                                                decoration: BoxDecoration(
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                                child: Icon(
                                                                                  Icons.person_remove,
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  size: 20.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              1.0),
                                                                          child:
                                                                              AutoSizeText(
                                                                            partnerDetailsContainerUsersRecord.displayName,
                                                                            maxLines:
                                                                                2,
                                                                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 16.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                            minFontSize:
                                                                                14.0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  if ((FFAppState()
                                                              .hasPartner ==
                                                          false) &&
                                                      (widget.userDocRef ==
                                                          widget.partnerRef))
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Builder(
                                                            builder:
                                                                (context) =>
                                                                    InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await authManager
                                                                    .refreshUser();
                                                                if (currentUserEmailVerified ==
                                                                    true) {
                                                                  context
                                                                      .pushNamed(
                                                                    'pairing_screen',
                                                                    queryParameters:
                                                                        {
                                                                      'uniqueCode':
                                                                          serializeParam(
                                                                        profileScreenUsersRecord
                                                                            .uniqueCode,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );
                                                                } else {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (dialogContext) {
                                                                      return Dialog(
                                                                        elevation:
                                                                            0,
                                                                        insetPadding:
                                                                            EdgeInsets.zero,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        alignment:
                                                                            AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap: () => _model.unfocusNode.canRequestFocus
                                                                              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                                                                              : FocusScope.of(context).unfocus(),
                                                                          child:
                                                                              ResendEmailComponentWidget(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      setState(
                                                                          () {}));
                                                                }
                                                              },
                                                              child: Material(
                                                                color: Colors
                                                                    .transparent,
                                                                elevation: 0.0,
                                                                shape:
                                                                    const CircleBorder(),
                                                                child:
                                                                    Container(
                                                                  width: 120.0,
                                                                  height: 120.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 10.0,
                                                                    height:
                                                                        10.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .person_add_alt_1_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          55.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              context.pushNamed(
                                                                'pairing_screen',
                                                                queryParameters:
                                                                    {
                                                                  'uniqueCode':
                                                                      serializeParam(
                                                                    profileScreenUsersRecord
                                                                        .uniqueCode,
                                                                    ParamType
                                                                        .String,
                                                                  ),
                                                                }.withoutNulls,
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 155.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            16.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'Add Partner',
                                                                  maxLines: 2,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineSmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize:
                                                                            16.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 32.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.userDocRef != currentUserReference)
                                Align(
                                  alignment: AlignmentDirectional(0.0, 1.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 180.0,
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 0.0, 8.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Material(
                                                    color: Colors.transparent,
                                                    elevation: 0.0,
                                                    shape: const CircleBorder(),
                                                    child: Container(
                                                      width: 120.0,
                                                      height: 120.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(4.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            fadeOutDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                            imageUrl:
                                                                profileScreenUsersRecord
                                                                    .photoUrl,
                                                            width: 200.0,
                                                            height: 200.0,
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                              'assets/images/error_image.png',
                                                              width: 200.0,
                                                              height: 200.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  16.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: AutoSizeText(
                                                        profileScreenUsersRecord
                                                            .displayName,
                                                        maxLines: 2,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .headlineSmall
                                                            .override(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                        minFontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.userDocRef == currentUserReference)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: StreamBuilder<List<SavedRecipeRecord>>(
                            stream: querySavedRecipeRecord(
                              queryBuilder: (savedRecipeRecord) =>
                                  savedRecipeRecord.where(
                                'user_id',
                                isEqualTo: currentUserReference,
                              ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).success,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<SavedRecipeRecord>
                                  ownerContainerSavedRecipeRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final ownerContainerSavedRecipeRecord =
                                  ownerContainerSavedRecipeRecordList.isNotEmpty
                                      ? ownerContainerSavedRecipeRecordList
                                          .first
                                      : null;
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment(0.0, 0),
                                      child: TabBar(
                                        isScrollable: true,
                                        labelColor: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        unselectedLabelColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        unselectedLabelStyle: TextStyle(),
                                        indicatorColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                        padding: EdgeInsets.all(4.0),
                                        tabs: [
                                          Tab(
                                            text: 'My Recipes',
                                          ),
                                          Tab(
                                            text: 'Saved Recipes',
                                          ),
                                          Tab(
                                            text: 'History',
                                          ),
                                        ],
                                        controller:
                                            _model.ownerTabBarController,
                                        onTap: (i) async {
                                          [
                                            () async {},
                                            () async {},
                                            () async {}
                                          ][i]();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller:
                                            _model.ownerTabBarController,
                                        children: [
                                          KeepAliveWidgetWrapper(
                                            builder: (context) => Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 16.0, 16.0, 0.0),
                                              child: StreamBuilder<
                                                  List<MealRecipeRecord>>(
                                                stream: queryMealRecipeRecord(
                                                  queryBuilder:
                                                      (mealRecipeRecord) =>
                                                          mealRecipeRecord
                                                              .where(
                                                                'author',
                                                                isEqualTo: widget
                                                                    .userDocRef,
                                                              )
                                                              .orderBy(
                                                                  'dateCreated'),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 24.0,
                                                        height: 24.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .success,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<MealRecipeRecord>
                                                      columnMealRecipeRecordList =
                                                      snapshot.data!;
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: List.generate(
                                                              columnMealRecipeRecordList
                                                                  .length,
                                                              (columnIndex) {
                                                        final columnMealRecipeRecord =
                                                            columnMealRecipeRecordList[
                                                                columnIndex];
                                                        return InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            if (Navigator.of(
                                                                    context)
                                                                .canPop()) {
                                                              context.pop();
                                                            }
                                                            context.pushNamed(
                                                              'details_screen',
                                                              queryParameters: {
                                                                'mealRef':
                                                                    serializeParam(
                                                                  columnMealRecipeRecord
                                                                      .reference,
                                                                  ParamType
                                                                      .DocumentReference,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Container(
                                                              width: 253.0,
                                                              height: 150.0,
                                                              child: Stack(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                children: [
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        150.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fadeInDuration:
                                                                            Duration(milliseconds: 500),
                                                                        fadeOutDuration:
                                                                            Duration(milliseconds: 500),
                                                                        imageUrl:
                                                                            columnMealRecipeRecord.banner,
                                                                        width:
                                                                            300.0,
                                                                        height:
                                                                            200.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorWidget: (context,
                                                                                error,
                                                                                stackTrace) =>
                                                                            Image.asset(
                                                                          'assets/images/error_image.png',
                                                                          width:
                                                                              300.0,
                                                                          height:
                                                                              200.0,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Opacity(
                                                                    opacity:
                                                                        0.2,
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          150.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Opacity(
                                                                    opacity:
                                                                        0.2,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              1.0),
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            60.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.black,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            bottomLeft:
                                                                                Radius.circular(10.0),
                                                                            bottomRight:
                                                                                Radius.circular(10.0),
                                                                            topLeft:
                                                                                Radius.circular(0.0),
                                                                            topRight:
                                                                                Radius.circular(0.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            8.0),
                                                                    child: StreamBuilder<
                                                                        UsersRecord>(
                                                                      stream: UsersRecord.getDocument(
                                                                          columnMealRecipeRecord
                                                                              .author!),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 24.0,
                                                                              height: 24.0,
                                                                              child: CircularProgressIndicator(
                                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                                  FlutterFlowTheme.of(context).success,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                        final informationColumnUsersRecord =
                                                                            snapshot.data!;
                                                                        return Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children:
                                                                              [
                                                                            Text(
                                                                              columnMealRecipeRecord.title,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    fontSize: 14.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    lineHeight: 1.5,
                                                                                  ),
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Text(
                                                                                  columnMealRecipeRecord.attribution == informationColumnUsersRecord.displayName ? 'By: ${informationColumnUsersRecord.displayName}' : 'By: ${columnMealRecipeRecord.attribution}',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        fontSize: 12.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        lineHeight: 1.5,
                                                                                      ),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                      child: Icon(
                                                                                        Icons.timer_sharp,
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                        size: 16.0,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      dateTimeFormat('Hm', columnMealRecipeRecord.prepTime!),
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                            fontSize: 10.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w300,
                                                                                          ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ].divide(SizedBox(width: 10.0)),
                                                                            ),
                                                                          ].divide(SizedBox(height: 2.0)),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      if (columnMealRecipeRecord
                                                                              .adminApproved ==
                                                                          false)
                                                                        Align(
                                                                          alignment: AlignmentDirectional(
                                                                              0.0,
                                                                              -1.0),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                6.0,
                                                                                8.0,
                                                                                0.0),
                                                                            child:
                                                                                Card(
                                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              elevation: 4.0,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.warning_rounded,
                                                                                      color: FlutterFlowTheme.of(context).warning,
                                                                                      size: 18.0,
                                                                                    ),
                                                                                    Text(
                                                                                      'Unverified',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: FlutterFlowTheme.of(context).error,
                                                                                            fontSize: 12.0,
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w500,
                                                                                          ),
                                                                                    ),
                                                                                  ].divide(SizedBox(width: 8.0)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      Stack(
                                                                        children: [
                                                                          if ((columnMealRecipeRecord.isPublic == true) &&
                                                                              (columnMealRecipeRecord.isReady == true))
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, -1.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 8.0, 0.0),
                                                                                child: Container(
                                                                                  width: 32.0,
                                                                                  height: 32.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.public_sharp,
                                                                                    color: FlutterFlowTheme.of(context).success,
                                                                                    size: 24.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if ((columnMealRecipeRecord.isPublic == false) &&
                                                                              (columnMealRecipeRecord.isReady == false))
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, -1.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 8.0, 0.0),
                                                                                child: Container(
                                                                                  width: 32.0,
                                                                                  height: 32.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.public_off_sharp,
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    size: 24.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if ((columnMealRecipeRecord.isPublic == false) &&
                                                                              (columnMealRecipeRecord.isReady == true))
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, -1.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 8.0, 0.0),
                                                                                child: Container(
                                                                                  width: 32.0,
                                                                                  height: 32.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.public_off_sharp,
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    size: 24.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if ((columnMealRecipeRecord.isPublic == true) &&
                                                                              (columnMealRecipeRecord.isReady == false))
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, -1.0),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 8.0, 0.0),
                                                                                child: Container(
                                                                                  width: 32.0,
                                                                                  height: 32.0,
                                                                                  decoration: BoxDecoration(
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Icon(
                                                                                    Icons.public_off_sharp,
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    size: 24.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                          .divide(SizedBox(
                                                              height: 16.0))
                                                          .addToEnd(SizedBox(
                                                              height: 32.0)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          KeepAliveWidgetWrapper(
                                            builder: (context) => Container(
                                              height: double.infinity,
                                              decoration: BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 16.0, 16.0, 0.0),
                                                child: Builder(
                                                  builder: (context) {
                                                    final savedRecipe =
                                                        ownerContainerSavedRecipeRecord
                                                                ?.savedMealRecipeId
                                                                ?.toList() ??
                                                            [];
                                                    return SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: List.generate(
                                                                savedRecipe
                                                                    .length,
                                                                (savedRecipeIndex) {
                                                          final savedRecipeItem =
                                                              savedRecipe[
                                                                  savedRecipeIndex];
                                                          return StreamBuilder<
                                                              MealRecipeRecord>(
                                                            stream: MealRecipeRecord
                                                                .getDocument(
                                                                    savedRecipeItem),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Center(
                                                                  child:
                                                                      SizedBox(
                                                                    width: 24.0,
                                                                    height:
                                                                        24.0,
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation<
                                                                              Color>(
                                                                        FlutterFlowTheme.of(context)
                                                                            .success,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              final item1MealRecipeRecord =
                                                                  snapshot
                                                                      .data!;
                                                              return InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  if (Navigator.of(
                                                                          context)
                                                                      .canPop()) {
                                                                    context
                                                                        .pop();
                                                                  }
                                                                  context
                                                                      .pushNamed(
                                                                    'details_screen',
                                                                    queryParameters:
                                                                        {
                                                                      'mealRef':
                                                                          serializeParam(
                                                                        item1MealRecipeRecord
                                                                            .reference,
                                                                        ParamType
                                                                            .DocumentReference,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        253.0,
                                                                    height:
                                                                        150.0,
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              150.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              fadeInDuration: Duration(milliseconds: 500),
                                                                              fadeOutDuration: Duration(milliseconds: 500),
                                                                              imageUrl: item1MealRecipeRecord.banner,
                                                                              width: 300.0,
                                                                              height: 200.0,
                                                                              fit: BoxFit.cover,
                                                                              errorWidget: (context, error, stackTrace) => Image.asset(
                                                                                'assets/images/error_image.png',
                                                                                width: 300.0,
                                                                                height: 200.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Opacity(
                                                                          opacity:
                                                                              0.2,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                150.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Opacity(
                                                                          opacity:
                                                                              0.2,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 1.0),
                                                                            child:
                                                                                Container(
                                                                              width: double.infinity,
                                                                              height: 75.0,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomLeft: Radius.circular(10.0),
                                                                                  bottomRight: Radius.circular(10.0),
                                                                                  topLeft: Radius.circular(0.0),
                                                                                  topRight: Radius.circular(0.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              8.0,
                                                                              8.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                item1MealRecipeRecord.title,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      fontSize: 14.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                              ),
                                                                              Text(
                                                                                'By: ${item1MealRecipeRecord.attribution}',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      fontSize: 10.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  StreamBuilder<UsersRecord>(
                                                                                    stream: UsersRecord.getDocument(item1MealRecipeRecord.author!),
                                                                                    builder: (context, snapshot) {
                                                                                      // Customize what your widget looks like when it's loading.
                                                                                      if (!snapshot.hasData) {
                                                                                        return Center(
                                                                                          child: SizedBox(
                                                                                            width: 24.0,
                                                                                            height: 24.0,
                                                                                            child: CircularProgressIndicator(
                                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                                FlutterFlowTheme.of(context).success,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                      final textUsersRecord = snapshot.data!;
                                                                                      return Text(
                                                                                        'Added By: ${textUsersRecord.displayName}',
                                                                                        maxLines: 1,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Poppins',
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              fontSize: 10.0,
                                                                                              letterSpacing: 0.0,
                                                                                            ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                        child: Icon(
                                                                                          Icons.timer_sharp,
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          size: 16.0,
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        dateTimeFormat('Hm', item1MealRecipeRecord.prepTime!),
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Poppins',
                                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                              fontSize: 10.0,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w300,
                                                                                            ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ].divide(SizedBox(width: 10.0)),
                                                                              ),
                                                                            ].divide(SizedBox(height: 2.0)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        })
                                                            .divide(SizedBox(
                                                                height: 16.0))
                                                            .addToEnd(SizedBox(
                                                                height: 32.0)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          KeepAliveWidgetWrapper(
                                            builder: (context) => Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              child: StreamBuilder<
                                                  List<PartnerReviewRecord>>(
                                                stream:
                                                    queryPartnerReviewRecord(
                                                  queryBuilder:
                                                      (partnerReviewRecord) =>
                                                          partnerReviewRecord
                                                              .orderBy(
                                                                  'date_created',
                                                                  descending:
                                                                      true),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 24.0,
                                                        height: 24.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .success,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<PartnerReviewRecord>
                                                      reviewColumnPartnerReviewRecordList =
                                                      snapshot.data!;
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: List.generate(
                                                              reviewColumnPartnerReviewRecordList
                                                                  .length,
                                                              (reviewColumnIndex) {
                                                        final reviewColumnPartnerReviewRecord =
                                                            reviewColumnPartnerReviewRecordList[
                                                                reviewColumnIndex];
                                                        return StreamBuilder<
                                                            PairedUserRecord>(
                                                          stream: PairedUserRecord
                                                              .getDocument(
                                                                  reviewColumnPartnerReviewRecord
                                                                      .pairedUserRef!),
                                                          builder: (context,
                                                              snapshot) {
                                                            // Customize what your widget looks like when it's loading.
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Center(
                                                                child: SizedBox(
                                                                  width: 24.0,
                                                                  height: 24.0,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .success,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            final cardReviewPairedUserRecord =
                                                                snapshot.data!;
                                                            return Container(
                                                              width: double
                                                                  .infinity,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxWidth:
                                                                    1270.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        4.0,
                                                                    color: Color(
                                                                        0x230E151B),
                                                                    offset:
                                                                        Offset(
                                                                      0.0,
                                                                      2.0,
                                                                    ),
                                                                  )
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                border:
                                                                    Border.all(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        16.0,
                                                                        8.0,
                                                                        16.0,
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      StreamBuilder<
                                                                          MealRecipeRecord>(
                                                                        stream:
                                                                            MealRecipeRecord.getDocument(reviewColumnPartnerReviewRecord.mealRecipeRef!),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          // Customize what your widget looks like when it's loading.
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Center(
                                                                              child: SizedBox(
                                                                                width: 24.0,
                                                                                height: 24.0,
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                                    FlutterFlowTheme.of(context).success,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }
                                                                          final parentMealRecipeInfoRowMealRecipeRecord =
                                                                              snapshot.data!;
                                                                          return Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    child: Image.network(
                                                                                      parentMealRecipeInfoRowMealRecipeRecord.banner,
                                                                                      width: 50.0,
                                                                                      height: 50.0,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        parentMealRecipeInfoRowMealRecipeRecord.title,
                                                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                              fontFamily: 'Poppins',
                                                                                              fontSize: 12.0,
                                                                                              letterSpacing: 0.0,
                                                                                            ),
                                                                                      ),
                                                                                      RatingBarIndicator(
                                                                                        itemBuilder: (context, index) => Icon(
                                                                                          Icons.star_rounded,
                                                                                          color: FlutterFlowTheme.of(context).tertiary,
                                                                                        ),
                                                                                        direction: Axis.horizontal,
                                                                                        rating: reviewColumnPartnerReviewRecord.star.toDouble(),
                                                                                        unratedColor: FlutterFlowTheme.of(context).alternate,
                                                                                        itemCount: 5,
                                                                                        itemSize: 18.0,
                                                                                      ),
                                                                                    ].divide(SizedBox(height: 8.0)),
                                                                                  ),
                                                                                ].divide(SizedBox(width: 8.0)),
                                                                              ),
                                                                              Text(
                                                                                valueOrDefault<String>(
                                                                                  functions.notificationTime(reviewColumnPartnerReviewRecord.dateCreated),
                                                                                  '0 seconds ago',
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            'Prepared by:',
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                          StreamBuilder<
                                                                              UsersRecord>(
                                                                            stream:
                                                                                UsersRecord.getDocument(cardReviewPairedUserRecord.recipient!),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              // Customize what your widget looks like when it's loading.
                                                                              if (!snapshot.hasData) {
                                                                                return Center(
                                                                                  child: SizedBox(
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    child: CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                                                        FlutterFlowTheme.of(context).success,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                              final nameOfPartnerTextUsersRecord = snapshot.data!;
                                                                              return Text(
                                                                                nameOfPartnerTextUsersRecord.displayName,
                                                                                style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontSize: 12.0,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            'Requested by:',
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                          StreamBuilder<
                                                                              UsersRecord>(
                                                                            stream:
                                                                                UsersRecord.getDocument(cardReviewPairedUserRecord.sender!),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              // Customize what your widget looks like when it's loading.
                                                                              if (!snapshot.hasData) {
                                                                                return Center(
                                                                                  child: SizedBox(
                                                                                    width: 24.0,
                                                                                    height: 24.0,
                                                                                    child: CircularProgressIndicator(
                                                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                                                        FlutterFlowTheme.of(context).success,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                              final userNameUsersRecord = snapshot.data!;
                                                                              return Text(
                                                                                userNameUsersRecord.displayName,
                                                                                style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      fontSize: 12.0,
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ].divide(SizedBox(width: 8.0)),
                                                                      ),
                                                                      Text(
                                                                        reviewColumnPartnerReviewRecord
                                                                            .description,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelLarge
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ]
                                                                        .divide(SizedBox(
                                                                            height:
                                                                                8.0))
                                                                        .addToStart(SizedBox(
                                                                            height:
                                                                                8.0))
                                                                        .addToEnd(SizedBox(
                                                                            height:
                                                                                8.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      })
                                                          .divide(SizedBox(
                                                              height: 16.0))
                                                          .addToStart(SizedBox(
                                                              height: 16.0)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (widget.userDocRef != currentUserReference)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    labelColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    unselectedLabelColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    unselectedLabelStyle: TextStyle(),
                                    indicatorColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Tab(
                                        text: 'Recipes',
                                      ),
                                    ],
                                    controller: _model.visitorTabBarController,
                                    onTap: (i) async {
                                      [() async {}][i]();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.visitorTabBarController,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 16.0, 16.0, 0.0),
                                        child: StreamBuilder<
                                            List<MealRecipeRecord>>(
                                          stream: queryMealRecipeRecord(
                                            queryBuilder: (mealRecipeRecord) =>
                                                mealRecipeRecord
                                                    .where(
                                                      'author',
                                                      isEqualTo:
                                                          widget.userDocRef,
                                                    )
                                                    .where(
                                                      'isPublic',
                                                      isEqualTo: true,
                                                    )
                                                    .orderBy('dateCreated'),
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 24.0,
                                                  height: 24.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .success,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            List<MealRecipeRecord>
                                                columnMealRecipeRecordList =
                                                snapshot.data!;
                                            return SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                        columnMealRecipeRecordList
                                                            .length, (columnIndex) {
                                                  final columnMealRecipeRecord =
                                                      columnMealRecipeRecordList[
                                                          columnIndex];
                                                  return StreamBuilder<
                                                      List<SavedRecipeRecord>>(
                                                    stream:
                                                        querySavedRecipeRecord(
                                                      queryBuilder:
                                                          (savedRecipeRecord) =>
                                                              savedRecipeRecord
                                                                  .where(
                                                        'user_id',
                                                        isEqualTo:
                                                            currentUserReference,
                                                      ),
                                                      singleRecord: true,
                                                    ),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 24.0,
                                                            height: 24.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .success,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      List<SavedRecipeRecord>
                                                          item1SavedRecipeRecordList =
                                                          snapshot.data!;
                                                      // Return an empty Container when the item does not exist.
                                                      if (snapshot
                                                          .data!.isEmpty) {
                                                        return Container();
                                                      }
                                                      final item1SavedRecipeRecord =
                                                          item1SavedRecipeRecordList
                                                                  .isNotEmpty
                                                              ? item1SavedRecipeRecordList
                                                                  .first
                                                              : null;
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          if (Navigator.of(
                                                                  context)
                                                              .canPop()) {
                                                            context.pop();
                                                          }
                                                          context.pushNamed(
                                                            'details_screen',
                                                            queryParameters: {
                                                              'mealRef':
                                                                  serializeParam(
                                                                columnMealRecipeRecord
                                                                    .reference,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Container(
                                                            width: 253.0,
                                                            height: 150.0,
                                                            child: Stack(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 150.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      fadeInDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      fadeOutDuration:
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                      imageUrl:
                                                                          columnMealRecipeRecord
                                                                              .banner,
                                                                      width:
                                                                          300.0,
                                                                      height:
                                                                          200.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorWidget: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/error_image.png',
                                                                        width:
                                                                            300.0,
                                                                        height:
                                                                            200.0,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Opacity(
                                                                  opacity: 0.2,
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        150.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Opacity(
                                                                  opacity: 0.2,
                                                                  child: Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            0.0,
                                                                            1.0),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          75.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(10.0),
                                                                          bottomRight:
                                                                              Radius.circular(10.0),
                                                                          topLeft:
                                                                              Radius.circular(0.0),
                                                                          topRight:
                                                                              Radius.circular(0.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          8.0),
                                                                  child: StreamBuilder<
                                                                      UsersRecord>(
                                                                    stream: UsersRecord.getDocument(
                                                                        columnMealRecipeRecord
                                                                            .author!),
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      // Customize what your widget looks like when it's loading.
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                24.0,
                                                                            height:
                                                                                24.0,
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                                FlutterFlowTheme.of(context).success,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      final informationColumnUsersRecord =
                                                                          snapshot
                                                                              .data!;
                                                                      return Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          Text(
                                                                            columnMealRecipeRecord.title,
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  fontSize: 14.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  lineHeight: 1.5,
                                                                                ),
                                                                          ),
                                                                          Text(
                                                                            'By: ${columnMealRecipeRecord.attribution}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                  fontSize: 10.0,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  lineHeight: 1.5,
                                                                                ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children:
                                                                                [
                                                                              Text(
                                                                                'Added by: ${informationColumnUsersRecord.displayName}',
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      fontSize: 10.0,
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      lineHeight: 1.5,
                                                                                    ),
                                                                              ),
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                    child: Icon(
                                                                                      Icons.timer_sharp,
                                                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                      size: 18.0,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    dateTimeFormat('Hm', columnMealRecipeRecord.prepTime!),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                          fontSize: 10.0,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w300,
                                                                                        ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ].divide(SizedBox(width: 10.0)),
                                                                          ),
                                                                        ].divide(SizedBox(height: 2.0)),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                })
                                                    .divide(
                                                        SizedBox(height: 16.0))
                                                    .addToEnd(
                                                        SizedBox(height: 32.0)),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
