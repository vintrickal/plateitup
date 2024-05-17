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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'meal_request_notification_screen_model.dart';
export 'meal_request_notification_screen_model.dart';

class MealRequestNotificationScreenWidget extends StatefulWidget {
  const MealRequestNotificationScreenWidget({
    super.key,
    required this.pairedUserRef,
  });

  final DocumentReference? pairedUserRef;

  @override
  State<MealRequestNotificationScreenWidget> createState() =>
      _MealRequestNotificationScreenWidgetState();
}

class _MealRequestNotificationScreenWidgetState
    extends State<MealRequestNotificationScreenWidget>
    with TickerProviderStateMixin {
  late MealRequestNotificationScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MealRequestNotificationScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.sENTPairedUserDetails = await queryPairedUserRecordOnce(
        queryBuilder: (pairedUserRecord) => pairedUserRecord.where(
          'sender',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      _model.sENTTabCountChecker =
          await queryMealRequestedNotificationRecordCount(
        queryBuilder: (mealRequestedNotificationRecord) =>
            mealRequestedNotificationRecord.where(
          'paired_user_id',
          isEqualTo: _model.sENTPairedUserDetails?.reference,
        ),
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 1,
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
    return StreamBuilder<PairedUserRecord>(
      stream: PairedUserRecord.getDocument(widget.pairedUserRef!),
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
        final mealRequestNotificationScreenPairedUserRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.goNamed('home');
                },
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
              title: Text(
                'Meal Request Notification',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Align(
                  alignment: Alignment(0.0, 0),
                  child: TabBar(
                    labelColor: FlutterFlowTheme.of(context).primaryText,
                    unselectedLabelColor:
                        FlutterFlowTheme.of(context).secondaryText,
                    labelStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                    unselectedLabelStyle: TextStyle(),
                    indicatorColor: FlutterFlowTheme.of(context).alternate,
                    padding: EdgeInsets.all(4.0),
                    tabs: [
                      Tab(
                        text: 'To',
                      ),
                      Tab(
                        text: 'From',
                      ),
                    ],
                    controller: _model.tabBarController,
                    onTap: (i) async {
                      [() async {}, () async {}][i]();
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      KeepAliveWidgetWrapper(
                        builder: (context) => StreamBuilder<
                            List<MealRequestedNotificationRecord>>(
                          stream: queryMealRequestedNotificationRecord(
                            queryBuilder: (mealRequestedNotificationRecord) =>
                                mealRequestedNotificationRecord
                                    .where(
                                      'paired_user_id',
                                      isEqualTo: _model
                                          .sENTPairedUserDetails?.reference,
                                    )
                                    .where(
                                      'reviewed',
                                      isEqualTo: false,
                                    )
                                    .orderBy('date_requested',
                                        descending: true),
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
                            List<MealRequestedNotificationRecord>
                                columnMealRequestedNotificationRecordList =
                                snapshot.data!;
                            if (columnMealRequestedNotificationRecordList
                                .isEmpty) {
                              return Center(
                                child: Container(
                                  height: 180.0,
                                  child: NoSentActivityWidget(),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                    columnMealRequestedNotificationRecordList
                                        .length, (columnIndex) {
                                  final columnMealRequestedNotificationRecord =
                                      columnMealRequestedNotificationRecordList[
                                          columnIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: StreamBuilder<PairedUserRecord>(
                                      stream: PairedUserRecord.getDocument(
                                          columnMealRequestedNotificationRecord
                                              .pairedUserId!),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: CircularProgressIndicator(
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
                                        final item1PairedUserRecord =
                                            snapshot.data!;
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3.0,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0.0,
                                                  1.0,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder<UsersRecord>(
                                                  stream:
                                                      UsersRecord.getDocument(
                                                          item1PairedUserRecord
                                                              .sender!),
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
                                                    final containerUsersRecord =
                                                        snapshot.data!;
                                                    return Container(
                                                      width: 48.0,
                                                      height: 48.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent1,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 120.0,
                                                        height: 120.0,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          containerUsersRecord
                                                              .photoUrl,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                4.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Requested Meal',
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                            Text(
                                                              () {
                                                                if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'approved') {
                                                                  return '(Preparing)';
                                                                } else if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'rejected') {
                                                                  return '(Rejected)';
                                                                } else if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'done') {
                                                                  return '(Done)';
                                                                } else if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'cancel') {
                                                                  return '(Canceled)';
                                                                } else {
                                                                  return '(Pending)';
                                                                }
                                                              }(),
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: () {
                                                                      if (columnMealRequestedNotificationRecord
                                                                              .contentStatus ==
                                                                          'approved') {
                                                                        return FlutterFlowTheme.of(context)
                                                                            .tertiary;
                                                                      } else if (columnMealRequestedNotificationRecord
                                                                              .contentStatus ==
                                                                          'rejected') {
                                                                        return FlutterFlowTheme.of(context)
                                                                            .error;
                                                                      } else if (columnMealRequestedNotificationRecord
                                                                              .contentStatus ==
                                                                          'done') {
                                                                        return FlutterFlowTheme.of(context)
                                                                            .success;
                                                                      } else if (columnMealRequestedNotificationRecord
                                                                              .contentStatus ==
                                                                          'cancel') {
                                                                        return FlutterFlowTheme.of(context)
                                                                            .error;
                                                                      } else {
                                                                        return FlutterFlowTheme.of(context)
                                                                            .warning;
                                                                      }
                                                                    }(),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            () {
                                                              if (columnMealRequestedNotificationRecord
                                                                      .contentStatus ==
                                                                  'approved') {
                                                                return 'Your meal is being prepared';
                                                              } else if (columnMealRequestedNotificationRecord
                                                                      .contentStatus ==
                                                                  'rejected') {
                                                                return 'Your meal has been rejected';
                                                              } else if (columnMealRequestedNotificationRecord
                                                                      .contentStatus ==
                                                                  'done') {
                                                                return 'Your meal is ready to be served';
                                                              } else if (columnMealRequestedNotificationRecord
                                                                      .contentStatus ==
                                                                  'cancel') {
                                                                return 'Your request has been withdrawn';
                                                              } else {
                                                                return 'You have requested this meal to be prepared';
                                                              }
                                                            }(),
                                                            maxLines: 2,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: StreamBuilder<
                                                              MealRecipeRecord>(
                                                            stream: MealRecipeRecord
                                                                .getDocument(
                                                                    columnMealRequestedNotificationRecord
                                                                        .requestedMealId!),
                                                            builder: (context,
                                                                snapshot) {
                                                              // Customize what your widget looks like when it's loading.
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return MealRecipeDeletedWidget();
                                                              }
                                                              final rowMealRecipeRecord =
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
                                                                  context
                                                                      .goNamed(
                                                                    'details_screen',
                                                                    queryParameters:
                                                                        {
                                                                      'mealRef':
                                                                          serializeParam(
                                                                        rowMealRecipeRecord
                                                                            .reference,
                                                                        ParamType
                                                                            .DocumentReference,
                                                                      ),
                                                                    }.withoutNulls,
                                                                    extra: <String,
                                                                        dynamic>{
                                                                      kTransitionInfoKey:
                                                                          TransitionInfo(
                                                                        hasTransition:
                                                                            true,
                                                                        transitionType:
                                                                            PageTransitionType.fade,
                                                                        duration:
                                                                            Duration(milliseconds: 600),
                                                                      ),
                                                                    },
                                                                  );

                                                                  await columnMealRequestedNotificationRecord
                                                                      .reference
                                                                      .update(
                                                                          createMealRequestedNotificationRecordData(
                                                                    contentWasTapped:
                                                                        true,
                                                                  ));
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              44.0,
                                                                          height:
                                                                              44.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                            border:
                                                                                Border.all(
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(2.0),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              child: Image.network(
                                                                                rowMealRecipeRecord.banner,
                                                                                width: 44.0,
                                                                                height: 44.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                rowMealRecipeRecord.title,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                child: Text(
                                                                                  dateTimeFormat('Hm', rowMealRecipeRecord.prepTime!),
                                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          18.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          4.0),
                                                              child: Text(
                                                                columnMealRequestedNotificationRecord
                                                                            .contentStatus ==
                                                                        'pending'
                                                                    ? functions.notificationTime(
                                                                        columnMealRequestedNotificationRecord
                                                                            .dateRequested)!
                                                                    : functions.notificationTime(
                                                                        columnMealRequestedNotificationRecord
                                                                            .dateActionTaken)!,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'done')
                                                                  Builder(
                                                                    builder:
                                                                        (context) =>
                                                                            FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (dialogContext) {
                                                                            return Dialog(
                                                                              elevation: 0,
                                                                              insetPadding: EdgeInsets.zero,
                                                                              backgroundColor: Colors.transparent,
                                                                              alignment: AlignmentDirectional(0.0, 1.0).resolve(Directionality.of(context)),
                                                                              child: GestureDetector(
                                                                                onTap: () => _model.unfocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(_model.unfocusNode) : FocusScope.of(context).unfocus(),
                                                                                child: PartnerRatingBottomsheetComponentWidget(
                                                                                  pairedUserRef: columnMealRequestedNotificationRecord.pairedUserId!,
                                                                                  mealRecipeRef: columnMealRequestedNotificationRecord.requestedMealId!,
                                                                                  mealRequestedNotificationRef: columnMealRequestedNotificationRecord.reference,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            setState(() {}));
                                                                      },
                                                                      text:
                                                                          'Rate',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .star_rate,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .warning,
                                                                        size:
                                                                            14.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            30.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        iconPadding:
                                                                            EdgeInsets.all(0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'pending')
                                                                  FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await columnMealRequestedNotificationRecord
                                                                          .reference
                                                                          .update(
                                                                              createMealRequestedNotificationRecordData(
                                                                        contentStatus:
                                                                            'cancel',
                                                                        dateActionTaken:
                                                                            columnMealRequestedNotificationRecord.dateActionTaken,
                                                                      ));
                                                                      _model.receiverNotificationItem =
                                                                          await queryReceiverNotificationRecordOnce(
                                                                        queryBuilder: (receiverNotificationRecord) => receiverNotificationRecord
                                                                            .where(
                                                                              'user_id',
                                                                              isEqualTo: mealRequestNotificationScreenPairedUserRecord.recipient,
                                                                            )
                                                                            .where(
                                                                              'meal_id',
                                                                              isEqualTo: columnMealRequestedNotificationRecord.requestedMealId,
                                                                            ),
                                                                        singleRecord:
                                                                            true,
                                                                      ).then((s) =>
                                                                              s.firstOrNull);

                                                                      await _model
                                                                          .receiverNotificationItem!
                                                                          .reference
                                                                          .update(
                                                                              createReceiverNotificationRecordData(
                                                                        isShownToUser:
                                                                            false,
                                                                        mealStatusMessage:
                                                                            'Your meal request has been canceled',
                                                                      ));

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    text:
                                                                        'Cancel',
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          30.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                                      iconPadding:
                                                                          EdgeInsets.all(
                                                                              0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                              ].divide(SizedBox(
                                                                  width: 8.0)),
                                                            ),
                                                          ],
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).divide(SizedBox(height: 16.0)).addToEnd(
                                    SizedBox(height: 32.0)),
                              ),
                            );
                          },
                        ),
                      ),
                      KeepAliveWidgetWrapper(
                        builder: (context) => StreamBuilder<
                            List<MealRequestedNotificationRecord>>(
                          stream: queryMealRequestedNotificationRecord(
                            queryBuilder: (mealRequestedNotificationRecord) =>
                                mealRequestedNotificationRecord
                                    .where(
                                      'paired_user_id',
                                      isEqualTo: widget.pairedUserRef,
                                    )
                                    .orderBy('date_requested',
                                        descending: true),
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
                            List<MealRequestedNotificationRecord>
                                columnMealRequestedNotificationRecordList =
                                snapshot.data!;
                            if (columnMealRequestedNotificationRecordList
                                .isEmpty) {
                              return Center(
                                child: Container(
                                  height: 180.0,
                                  child: NoRequestOrderScreenWidget(),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(
                                    columnMealRequestedNotificationRecordList
                                        .length, (columnIndex) {
                                  final columnMealRequestedNotificationRecord =
                                      columnMealRequestedNotificationRecordList[
                                          columnIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: StreamBuilder<UsersRecord>(
                                      stream: UsersRecord.getDocument(
                                          mealRequestNotificationScreenPairedUserRecord
                                              .sender!),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 24.0,
                                              height: 24.0,
                                              child: CircularProgressIndicator(
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
                                        final item1UsersRecord = snapshot.data!;
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3.0,
                                                color: Color(0x33000000),
                                                offset: Offset(
                                                  0.0,
                                                  1.0,
                                                ),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .success,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 120.0,
                                                    height: 120.0,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Image.network(
                                                      item1UsersRecord.photoUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                4.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Meal Request',
                                                              maxLines: 1,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                            if (columnMealRequestedNotificationRecord
                                                                    .contentStatus ==
                                                                'cancel')
                                                              Text(
                                                                '(Canceled)',
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .error,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            columnMealRequestedNotificationRecord
                                                                        .contentStatus ==
                                                                    'cancel'
                                                                ? '${item1UsersRecord.displayName} has withdrawn this request.'
                                                                : '${item1UsersRecord.displayName} has requested to have this meal prepared.',
                                                            maxLines: 2,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: StreamBuilder<
                                                              MealRecipeRecord>(
                                                            stream: MealRecipeRecord
                                                                .getDocument(
                                                                    columnMealRequestedNotificationRecord
                                                                        .requestedMealId!),
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
                                                              final rowMealRecipeRecord =
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
                                                                  context
                                                                      .goNamed(
                                                                    'details_screen',
                                                                    queryParameters:
                                                                        {
                                                                      'mealRef':
                                                                          serializeParam(
                                                                        rowMealRecipeRecord
                                                                            .reference,
                                                                        ParamType
                                                                            .DocumentReference,
                                                                      ),
                                                                    }.withoutNulls,
                                                                    extra: <String,
                                                                        dynamic>{
                                                                      kTransitionInfoKey:
                                                                          TransitionInfo(
                                                                        hasTransition:
                                                                            true,
                                                                        transitionType:
                                                                            PageTransitionType.fade,
                                                                        duration:
                                                                            Duration(milliseconds: 600),
                                                                      ),
                                                                    },
                                                                  );

                                                                  await columnMealRequestedNotificationRecord
                                                                      .reference
                                                                      .update(
                                                                          createMealRequestedNotificationRecordData(
                                                                    contentWasTapped:
                                                                        true,
                                                                  ));
                                                                },
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              44.0,
                                                                          height:
                                                                              44.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                            border:
                                                                                Border.all(
                                                                              color: FlutterFlowTheme.of(context).alternate,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(2.0),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              child: Image.network(
                                                                                rowMealRecipeRecord.banner,
                                                                                width: 44.0,
                                                                                height: 44.0,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              12.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                rowMealRecipeRecord.title,
                                                                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                child: Text(
                                                                                  dateTimeFormat('Hm', rowMealRecipeRecord.prepTime!),
                                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      size:
                                                                          18.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          4.0),
                                                              child: Text(
                                                                '${functions.notificationTime(columnMealRequestedNotificationRecord.dateRequested)}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                            if (columnMealRequestedNotificationRecord
                                                                    .contentStatus !=
                                                                'cancel')
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (columnMealRequestedNotificationRecord
                                                                          .contentStatus ==
                                                                      'pending')
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await columnMealRequestedNotificationRecord
                                                                            .reference
                                                                            .update({
                                                                          ...createMealRequestedNotificationRecordData(
                                                                            contentStatus:
                                                                                'approved',
                                                                          ),
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'date_action_taken': FieldValue.serverTimestamp(),
                                                                            },
                                                                          ),
                                                                        });
                                                                        _model.senderNotificationItem =
                                                                            await querySenderNotificationRecordOnce(
                                                                          queryBuilder: (senderNotificationRecord) => senderNotificationRecord
                                                                              .where(
                                                                                'user_id',
                                                                                isEqualTo: mealRequestNotificationScreenPairedUserRecord.sender,
                                                                              )
                                                                              .where(
                                                                                'meal_id',
                                                                                isEqualTo: columnMealRequestedNotificationRecord.requestedMealId,
                                                                              ),
                                                                          singleRecord:
                                                                              true,
                                                                        ).then((s) =>
                                                                                s.firstOrNull);

                                                                        await _model
                                                                            .senderNotificationItem!
                                                                            .reference
                                                                            .update(createSenderNotificationRecordData(
                                                                          isShownToUser:
                                                                              false,
                                                                          mealStatusMessage:
                                                                              'Your meal has been approved and is now being prepared',
                                                                        ));

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      text:
                                                                          'Accept',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            30.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .success,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  if (columnMealRequestedNotificationRecord
                                                                          .contentStatus ==
                                                                      'pending')
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await columnMealRequestedNotificationRecord
                                                                            .reference
                                                                            .update({
                                                                          ...createMealRequestedNotificationRecordData(
                                                                            contentStatus:
                                                                                'rejected',
                                                                          ),
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'date_action_taken': FieldValue.serverTimestamp(),
                                                                            },
                                                                          ),
                                                                        });
                                                                        _model.senderNotificationRejectedItem =
                                                                            await querySenderNotificationRecordOnce(
                                                                          queryBuilder: (senderNotificationRecord) => senderNotificationRecord
                                                                              .where(
                                                                                'user_id',
                                                                                isEqualTo: mealRequestNotificationScreenPairedUserRecord.sender,
                                                                              )
                                                                              .where(
                                                                                'meal_id',
                                                                                isEqualTo: columnMealRequestedNotificationRecord.requestedMealId,
                                                                              ),
                                                                          singleRecord:
                                                                              true,
                                                                        ).then((s) =>
                                                                                s.firstOrNull);

                                                                        await _model
                                                                            .senderNotificationRejectedItem!
                                                                            .reference
                                                                            .update(createSenderNotificationRecordData(
                                                                          isShownToUser:
                                                                              false,
                                                                          mealStatusMessage:
                                                                              'Your meal request has been rejected',
                                                                        ));

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      text:
                                                                          'Reject',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            30.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .error,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  if (columnMealRequestedNotificationRecord
                                                                          .contentStatus ==
                                                                      'approved')
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        await columnMealRequestedNotificationRecord
                                                                            .reference
                                                                            .update({
                                                                          ...createMealRequestedNotificationRecordData(
                                                                            contentStatus:
                                                                                'done',
                                                                          ),
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'date_action_taken': FieldValue.serverTimestamp(),
                                                                            },
                                                                          ),
                                                                        });
                                                                        _model.senderNotificationDoneItem =
                                                                            await querySenderNotificationRecordOnce(
                                                                          queryBuilder: (senderNotificationRecord) => senderNotificationRecord
                                                                              .where(
                                                                                'user_id',
                                                                                isEqualTo: mealRequestNotificationScreenPairedUserRecord.sender,
                                                                              )
                                                                              .where(
                                                                                'meal_id',
                                                                                isEqualTo: columnMealRequestedNotificationRecord.requestedMealId,
                                                                              ),
                                                                          singleRecord:
                                                                              true,
                                                                        ).then((s) =>
                                                                                s.firstOrNull);

                                                                        await _model
                                                                            .senderNotificationDoneItem!
                                                                            .reference
                                                                            .update(createSenderNotificationRecordData(
                                                                          isShownToUser:
                                                                              false,
                                                                          mealStatusMessage:
                                                                              'Your meal request is complete and ready to be served',
                                                                        ));

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      text:
                                                                          'Done',
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            30.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .success,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                  if (columnMealRequestedNotificationRecord
                                                                          .reviewed ==
                                                                      true)
                                                                    FFButtonWidget(
                                                                      onPressed:
                                                                          () async {
                                                                        context
                                                                            .pushNamed(
                                                                          'profile_screen',
                                                                          queryParameters:
                                                                              {
                                                                            'userDocRef':
                                                                                serializeParam(
                                                                              mealRequestNotificationScreenPairedUserRecord.recipient,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                            'partnerRef':
                                                                                serializeParam(
                                                                              mealRequestNotificationScreenPairedUserRecord.sender,
                                                                              ParamType.DocumentReference,
                                                                            ),
                                                                            'tabIndex':
                                                                                serializeParam(
                                                                              2,
                                                                              ParamType.int,
                                                                            ),
                                                                          }.withoutNulls,
                                                                          extra: <String,
                                                                              dynamic>{
                                                                            kTransitionInfoKey:
                                                                                TransitionInfo(
                                                                              hasTransition: true,
                                                                              transitionType: PageTransitionType.fade,
                                                                              duration: Duration(milliseconds: 0),
                                                                            ),
                                                                          },
                                                                        );
                                                                      },
                                                                      text:
                                                                          'See Review',
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .reviews,
                                                                        size:
                                                                            15.0,
                                                                      ),
                                                                      options:
                                                                          FFButtonOptions(
                                                                        height:
                                                                            30.0,
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            0.0,
                                                                            12.0,
                                                                            0.0),
                                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        textStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: Colors.white,
                                                                              fontSize: 14.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                ].divide(SizedBox(
                                                                    width:
                                                                        8.0)),
                                                              ),
                                                          ],
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 8.0)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }).divide(SizedBox(height: 16.0)).addToEnd(
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
        );
      },
    );
  }
}
