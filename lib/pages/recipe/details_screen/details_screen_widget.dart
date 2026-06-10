import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/flutter_flow/custom_functions.dart' as functions;
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
import 'details_cubit.dart';
import 'details_state.dart';

/// Recipe details screen — Cubit conversion.
///
/// [DetailsCubit] owns the page-load aggregation; the widget keeps the
/// `TabController` (it needs the `TickerProvider`) and the focus node.
class DetailsScreenWidget extends StatelessWidget {
  const DetailsScreenWidget({
    super.key,
    required this.mealRef,
    this.savedRecipeDoc,
  });

  final DocumentReference? mealRef;
  final DocumentReference? savedRecipeDoc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsCubit()..onPageLoad(mealRef: mealRef!),
      child: _DetailsView(
        mealRef: mealRef,
        savedRecipeDoc: savedRecipeDoc,
      ),
    );
  }
}

class _DetailsView extends StatefulWidget {
  const _DetailsView({required this.mealRef, required this.savedRecipeDoc});

  final DocumentReference? mealRef;
  final DocumentReference? savedRecipeDoc;

  @override
  State<_DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<_DetailsView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late final TabController _tabBarController = TabController(
    vsync: this,
    length: 3,
    initialIndex: 0,
  )..addListener(() => setState(() {}));

  @override
  void dispose() {
    _unfocusNode.dispose();
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, app.AppState>(
      builder: (context, _) => BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, detailsState) => _buildBody(context, detailsState),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DetailsState detailsState) {
    return StreamBuilder<MealRecipeRecord>(
      stream: MealRecipeRecord.getDocument(widget.mealRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
        final detailsScreenMealRecipeRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            floatingActionButton: Visibility(
              visible: (AppCubit.instance.state.isReviewExist == false) &&
                  (_tabBarController.index == 2) &&
                  (detailsScreenMealRecipeRecord.author !=
                      currentUserReference),
              child: Builder(
                builder: (context) => FloatingActionButton.extended(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: AlignmentDirectional(0.0, 1.0)
                              .resolve(Directionality.of(context)),
                          child: GestureDetector(
                            onTap: () => _unfocusNode.canRequestFocus
                                ? FocusScope.of(context)
                                    .requestFocus(_unfocusNode)
                                : FocusScope.of(context).unfocus(),
                            child: MealRatingBottomsheetComponentWidget(
                              mealRecipeRef: widget.mealRef!,
                            ),
                          ),
                        );
                      },
                    ).then((value) => setState(() {}));
                  },
                  backgroundColor: FlutterFlowTheme.of(context).success,
                  elevation: 8.0,
                  label: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.rate_review,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                      Text(
                        'Write Review',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                          ),
                          child: Hero(
                            tag: detailsScreenMealRecipeRecord.banner,
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: detailsScreenMealRecipeRecord.banner,
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/error_image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.2,
                          child: Container(
                            width: double.infinity,
                            height: 200.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryText,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.goNamed('home');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 8.0, 8.0, 8.0),
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (detailsScreenMealRecipeRecord
                                                  .author ==
                                              currentUserReference) {
                                            if (AppCubit.instance.state.hasPartner ==
                                                true) {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                1.0, -1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () => _unfocusNode
                                                              .canRequestFocus
                                                          ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                          : FocusScope.of(context).unfocus(),
                                                      child: Container(
                                                        height: 340.0,
                                                        width: 30.0,
                                                        child:
                                                            OptionAuthorComponentWidget(
                                                          userRef:
                                                              currentUserReference!,
                                                          mealRef:
                                                              widget.mealRef!,
                                                          ingredientList:
                                                              detailsScreenMealRecipeRecord
                                                                  .ingredient,
                                                          procedureList:
                                                              detailsScreenMealRecipeRecord
                                                                  .procedure,
                                                          pairedUserRef: detailsState
                                                              .pairedUserSenderRef,
                                                          recipeCategoryList:
                                                              detailsScreenMealRecipeRecord
                                                                  .category,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                1.0, -1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () => _unfocusNode
                                                              .canRequestFocus
                                                          ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                          : FocusScope.of(context).unfocus(),
                                                      child: Container(
                                                        height: 300.0,
                                                        width: 30.0,
                                                        child:
                                                            OptionAuthorComponentWidget(
                                                          userRef:
                                                              currentUserReference!,
                                                          mealRef:
                                                              widget.mealRef!,
                                                          ingredientList:
                                                              detailsScreenMealRecipeRecord
                                                                  .ingredient,
                                                          procedureList:
                                                              detailsScreenMealRecipeRecord
                                                                  .procedure,
                                                          recipeCategoryList:
                                                              detailsScreenMealRecipeRecord
                                                                  .category,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                            }
                                          } else {
                                            if (AppCubit.instance.state.hasPartner ==
                                                true) {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                1.0, -1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () => _unfocusNode
                                                              .canRequestFocus
                                                          ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                          : FocusScope.of(context).unfocus(),
                                                      child: Container(
                                                        height: 230.0,
                                                        width: 30.0,
                                                        child:
                                                            OptionNotAuthorComponentWidget(
                                                          userRef:
                                                              currentUserReference!,
                                                          mealRef:
                                                              detailsScreenMealRecipeRecord
                                                                  .reference,
                                                          pairedUserRef: detailsState
                                                              .pairedUserSenderRef,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    alignment:
                                                        AlignmentDirectional(
                                                                1.0, -1.0)
                                                            .resolve(
                                                                Directionality.of(
                                                                    context)),
                                                    child: GestureDetector(
                                                      onTap: () => _unfocusNode
                                                              .canRequestFocus
                                                          ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                          : FocusScope.of(context).unfocus(),
                                                      child: Container(
                                                        height: 170.0,
                                                        width: 30.0,
                                                        child:
                                                            OptionNotAuthorComponentWidget(
                                                          userRef:
                                                              currentUserReference!,
                                                          mealRef:
                                                              detailsScreenMealRecipeRecord
                                                                  .reference,
                                                          pairedUserRef: detailsState
                                                              .pairedUserSenderRef,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            shape: BoxShape.rectangle,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 8.0, 8.0),
                                            child: Icon(
                                              Icons.keyboard_control_sharp,
                                              color: Color(0xFF121212),
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.1,
                                    child: Container(
                                      width: double.infinity,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 8.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 4.0, 0.0),
                                              child: Icon(
                                                Icons.timer_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                size: 14.0,
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                dateTimeFormat(
                                                    'Hm',
                                                    detailsScreenMealRecipeRecord
                                                        .prepTime),
                                                '00:00',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ].divide(SizedBox(width: 10.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 8.0),
                                child: StreamBuilder<UsersRecord>(
                                  // MVP: null-safe author fallback.
                                  stream: UsersRecord.getDocument(
                                      detailsScreenMealRecipeRecord.author ??
                                          currentUserReference!),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 24.0,
                                          height: 24.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .success,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final nameRowUsersRecord = snapshot.data!;
                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (detailsScreenMealRecipeRecord
                                                    .author ==
                                                currentUserReference) {
                                              // Look up the paired-user record
                                              // for the current viewer; if
                                              // one exists, surface the
                                              // partner uid to AppCubit and
                                              // open the partner's profile.
                                              final paired =
                                                  await queryPairedUserRecordOnce(
                                                queryBuilder: (q) => q.where(
                                                  'recipient',
                                                  isEqualTo:
                                                      currentUserReference,
                                                ),
                                                singleRecord: true,
                                              ).then((s) => s.firstOrNull);
                                              if (!context.mounted) return;
                                              if (paired != null) {
                                                AppCubit.instance.setPartnerUid(paired.sender);
                                                context.pushNamed(
                                                  'profile_screen',
                                                  queryParameters: {
                                                    'userDocRef':
                                                        serializeParam(
                                                      currentUserReference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'partnerRef':
                                                        serializeParam(
                                                      paired.sender,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        const TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .fade,
                                                      duration: Duration(
                                                          milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              } else {
                                                context.pushNamed(
                                                  'profile_screen',
                                                  queryParameters: {
                                                    'userDocRef':
                                                        serializeParam(
                                                      currentUserReference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                    'partnerRef':
                                                        serializeParam(
                                                      currentUserReference,
                                                      ParamType
                                                          .DocumentReference,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType
                                                              .fade,
                                                      duration: Duration(
                                                          milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              }
                                            } else {
                                              context.goNamed(
                                                'profile_screen',
                                                queryParameters: {
                                                  'userDocRef': serializeParam(
                                                    detailsScreenMealRecipeRecord
                                                        .author,
                                                    ParamType.DocumentReference,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            }

                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 30.0,
                                                height: 30.0,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CachedNetworkImage(
                                                  fadeInDuration: Duration(
                                                      milliseconds: 500),
                                                  fadeOutDuration: Duration(
                                                      milliseconds: 500),
                                                  imageUrl: nameRowUsersRecord
                                                      .photoUrl,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/error_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                nameRowUsersRecord.displayName,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ].divide(SizedBox(width: 8.0)),
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (detailsScreenMealRecipeRecord
                                                    .videolink !=
                                                '') {
                                              await launchURL(
                                                  detailsScreenMealRecipeRecord
                                                      .videolink);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'There\'s no link available',
                                                    style: TextStyle(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondary,
                                                ),
                                              );
                                            }
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 4.0, 0.0),
                                                child: Icon(
                                                  Icons.play_circle,
                                                  color:
                                                      detailsScreenMealRecipeRecord
                                                                  .videolink !=
                                                              ''
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .success
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                              Text(
                                                'Play Video',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: detailsScreenMealRecipeRecord
                                                                  .videolink !=
                                                              ''
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .success
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              detailsScreenMealRecipeRecord
                                                  .title,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                setState(() {
                                                  _tabBarController!
                                                      .animateTo(
                                                    2,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                });
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 3.0),
                                                    child: Icon(
                                                      Icons.star_sharp,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      detailsState.starAverage
                                                          ?.toString(),
                                                      '0',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
                                        ),
                                        if (detailsScreenMealRecipeRecord
                                                .attribution !=
                                            currentUserDisplayName)
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: AuthUserStreamWidget(
                                              builder: (context) => Text(
                                                'By: ${detailsScreenMealRecipeRecord.attribution}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final categoryList =
                                                    detailsScreenMealRecipeRecord
                                                        .category
                                                        .toList();
                                                return Wrap(
                                                  spacing: 0.0,
                                                  runSpacing: 8.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: List.generate(
                                                      categoryList.length,
                                                      (categoryListIndex) {
                                                    final categoryListItem =
                                                        categoryList[
                                                            categoryListIndex];
                                                    return Visibility(
                                                      visible:
                                                          categoryListItem !=
                                                              ' ',
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 40.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    categoryListItem,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (currentUserEmail ==
                                      'admin@admin.plateitup')
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Builder(
                                            builder: (context) =>
                                                FFButtonWidget(
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      alignment:
                                                          AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality.of(
                                                                      context)),
                                                      child: GestureDetector(
                                                        onTap: () => _unfocusNode
                                                                .canRequestFocus
                                                            ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                            : FocusScope.of(context).unfocus(),
                                                        child:
                                                            ReportedReasonContainerWidget(
                                                          mealRef:
                                                              widget.mealRef!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                              text: 'Denied',
                                              options: FFButtonOptions(
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () async {
                                              await widget.mealRef!.update(
                                                  createMealRecipeRecordData(
                                                adminApproved: true,
                                                isPublic: true,
                                                isRecipeReported: false,
                                                isReady: true,
                                              ));
                                              context.safePop();
                                            },
                                            text: 'Approve',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .success,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                              elevation: 3.0,
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16.0)),
                                      ),
                                    ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  height: 200.0,
                                  decoration: BoxDecoration(),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment(0.0, 0),
                                          child: FlutterFlowButtonTabBar(
                                            useToggleButtonStyle: false,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 11.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      lineHeight: 1.5,
                                                    ),
                                            unselectedLabelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 11.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      lineHeight: 1.5,
                                                    ),
                                            labelColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            unselectedLabelColor:
                                                Color(0xFF129575),
                                            backgroundColor: Color(0xFF129575),
                                            unselectedBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            unselectedBorderColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderWidth: 0.0,
                                            borderRadius: 8.0,
                                            elevation: 0.0,
                                            buttonMargin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    2.0, 0.0, 4.0, 0.0),
                                            padding: EdgeInsets.all(4.0),
                                            tabs: [
                                              Tab(
                                                text: 'Ingredient',
                                              ),
                                              Tab(
                                                text: 'Procedure',
                                              ),
                                              Tab(
                                                text: 'Reviews',
                                              ),
                                            ],
                                            controller: _tabBarController,
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
                                            controller: _tabBarController,
                                            children: [
                                              KeepAliveWidgetWrapper(
                                                builder: (context) => Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 0.0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        8.0),
                                                            child: Text(
                                                              '${detailsScreenMealRecipeRecord.ingredient.length.toString()} items',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: Color(
                                                                        0xFFA9A9A9),
                                                                    fontSize:
                                                                        12.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (detailsScreenMealRecipeRecord
                                                                .ingredient
                                                                .length !=
                                                            0)
                                                          Builder(
                                                            builder: (context) {
                                                              final ingredient =
                                                                  detailsScreenMealRecipeRecord
                                                                      .ingredient
                                                                      .map(
                                                                          (e) =>
                                                                              e)
                                                                      .toList();
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: List.generate(
                                                                        ingredient
                                                                            .length,
                                                                        (ingredientIndex) {
                                                                  final ingredientItem =
                                                                      ingredient[
                                                                          ingredientIndex];
                                                                  return Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        76.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children:
                                                                            [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children:
                                                                                [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/default-ingredient.png',
                                                                                  width: 52.0,
                                                                                  height: 52.0,
                                                                                  fit: BoxFit.cover,
                                                                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                    'assets/images/error_image.png',
                                                                                    width: 52.0,
                                                                                    height: 52.0,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 150.0,
                                                                                decoration: BoxDecoration(),
                                                                                child: Text(
                                                                                  ingredientItem.ingrName,
                                                                                  maxLines: 2,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        color: Color(0xFF121212),
                                                                                        fontSize: 16.0,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        lineHeight: 1.5,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ].divide(SizedBox(width: 8.0)),
                                                                          ),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                child: Text(
                                                                                  ingredientItem.ingrQuantity,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        color: Color(0xFFA9A9A9),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        lineHeight: 1.5,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                ingredientItem.ingrUnit,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: Color(0xFFA9A9A9),
                                                                                      letterSpacing: 0.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                      lineHeight: 1.5,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ].divide(SizedBox(width: 12.0)),
                                                                      ),
                                                                    ),
                                                                  );
                                                                })
                                                                    .divide(SizedBox(
                                                                        height:
                                                                            8.0))
                                                                    .addToEnd(SizedBox(
                                                                        height:
                                                                            32.0)),
                                                              );
                                                            },
                                                          ),
                                                        if (detailsScreenMealRecipeRecord
                                                                .ingredient
                                                                .length ==
                                                            0)
                                                          Text(
                                                            'Ingredients were not added!',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              KeepAliveWidgetWrapper(
                                                builder: (context) => Container(
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 12.0,
                                                                0.0, 0.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          if (detailsScreenMealRecipeRecord
                                                                  .procedure
                                                                  .length !=
                                                              0)
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                final procedure =
                                                                    detailsScreenMealRecipeRecord
                                                                        .procedure
                                                                        .toList();
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: List.generate(
                                                                      procedure
                                                                          .length,
                                                                      (procedureIndex) {
                                                                    final procedureItem =
                                                                        procedure[
                                                                            procedureIndex];
                                                                    return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            12.0,
                                                                            12.0,
                                                                            12.0,
                                                                            12.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children:
                                                                              [
                                                                            Text(
                                                                              'Step ${functions.incrementSteps(procedureIndex).toString()}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              procedureItem.steps,
                                                                              maxLines: 10,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w300,
                                                                                  ),
                                                                            ),
                                                                          ].divide(SizedBox(height: 4.0)),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).divide(SizedBox(height: 16.0)).addToEnd(
                                                                      SizedBox(
                                                                          height:
                                                                              32.0)),
                                                                );
                                                              },
                                                            ),
                                                          if (detailsScreenMealRecipeRecord
                                                                  .procedure
                                                                  .length ==
                                                              0)
                                                            Text(
                                                              'Procedures were not added!',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                        ].divide(SizedBox(
                                                            height: 12.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              KeepAliveWidgetWrapper(
                                                builder: (context) => Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Visibility(
                                                      visible: AppCubit.instance.state.isReviewTabEmpty ==
                                                          false,
                                                      child: StreamBuilder<
                                                          List<ReviewRecord>>(
                                                        stream:
                                                            queryReviewRecord(
                                                          parent:
                                                              widget.mealRef,
                                                          queryBuilder: (reviewRecord) =>
                                                              reviewRecord.orderBy(
                                                                  'date_created',
                                                                  descending:
                                                                      true),
                                                        ),
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
                                                          List<ReviewRecord>
                                                              reviewColumnReviewRecordList =
                                                              snapshot.data!;
                                                          return SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: List.generate(
                                                                      reviewColumnReviewRecordList
                                                                          .length,
                                                                      (reviewColumnIndex) {
                                                                final reviewColumnReviewRecord =
                                                                    reviewColumnReviewRecordList[
                                                                        reviewColumnIndex];
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
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
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
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children:
                                                                            [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              StreamBuilder<UsersRecord>(
                                                                                stream: UsersRecord.getDocument(reviewColumnReviewRecord.userRef!),
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
                                                                                    valueOrDefault<String>(
                                                                                      textUsersRecord.displayName,
                                                                                      'name',
                                                                                    ),
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Poppins',
                                                                                          fontSize: 12.0,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                              StreamBuilder<List<UserReviewLikesRecord>>(
                                                                                stream: queryUserReviewLikesRecord(
                                                                                  queryBuilder: (userReviewLikesRecord) => userReviewLikesRecord
                                                                                      .where(
                                                                                        'review_subcollection_ref',
                                                                                        isEqualTo: reviewColumnReviewRecord.reference,
                                                                                      )
                                                                                      .where(
                                                                                        'user_ref',
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
                                                                                  List<UserReviewLikesRecord> stackUserReviewLikesRecordList = snapshot.data!;
                                                                                  final stackUserReviewLikesRecord = stackUserReviewLikesRecordList.isNotEmpty ? stackUserReviewLikesRecordList.first : null;
                                                                                  return Stack(
                                                                                    alignment: AlignmentDirectional(1.0, 1.0),
                                                                                    children: [
                                                                                      if (reviewColumnReviewRecord.userRef != currentUserReference)
                                                                                        FlutterFlowIconButton(
                                                                                          borderColor: Colors.transparent,
                                                                                          borderRadius: 20.0,
                                                                                          buttonSize: 34.0,
                                                                                          icon: Icon(
                                                                                            Icons.thumb_up_alt,
                                                                                            color: valueOrDefault<Color>(
                                                                                              (stackUserReviewLikesRecord != null) == true ? FlutterFlowTheme.of(context).success : FlutterFlowTheme.of(context).secondaryText,
                                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                                            ),
                                                                                            size: 18.0,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            if ((stackUserReviewLikesRecord != null) == true) {
                                                                                              await stackUserReviewLikesRecord!.reference.delete();
                                                                                            } else {
                                                                                              await UserReviewLikesRecord.collection.doc().set(createUserReviewLikesRecordData(
                                                                                                reviewSubcollectionRef: reviewColumnReviewRecord.reference,
                                                                                                userRef: currentUserReference,
                                                                                              ));
                                                                                            }

                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      FutureBuilder<int>(
                                                                                        future: queryUserReviewLikesRecordCount(
                                                                                          queryBuilder: (userReviewLikesRecord) => userReviewLikesRecord.where(
                                                                                            'review_subcollection_ref',
                                                                                            isEqualTo: reviewColumnReviewRecord.reference,
                                                                                          ),
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
                                                                                          int likeRowCount = snapshot.data!;
                                                                                          return Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Text(
                                                                                                likeRowCount == 0 ? ' ' : likeRowCount.toString(),
                                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                      fontFamily: 'Poppins',
                                                                                                      color: FlutterFlowTheme.of(context).success,
                                                                                                      fontSize: 12.0,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                    ),
                                                                                              ),
                                                                                              if ((reviewColumnReviewRecord.userRef == currentUserReference) && (likeRowCount != 0))
                                                                                                Text(
                                                                                                  'Likes',
                                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                        fontFamily: 'Poppins',
                                                                                                        color: FlutterFlowTheme.of(context).success,
                                                                                                        fontSize: 12.0,
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                      ),
                                                                                                ),
                                                                                            ].divide(SizedBox(width: 4.0)),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                RatingBarIndicator(
                                                                                  itemBuilder: (context, index) => Icon(
                                                                                    Icons.star_rounded,
                                                                                    color: FlutterFlowTheme.of(context).tertiary,
                                                                                  ),
                                                                                  direction: Axis.horizontal,
                                                                                  rating: valueOrDefault<double>(
                                                                                    reviewColumnReviewRecord.star.toDouble(),
                                                                                    0.0,
                                                                                  ),
                                                                                  unratedColor: FlutterFlowTheme.of(context).alternate,
                                                                                  itemCount: 5,
                                                                                  itemSize: 18.0,
                                                                                ),
                                                                                Text(
                                                                                  valueOrDefault<String>(
                                                                                    functions.notificationTime(reviewColumnReviewRecord.dateCreated),
                                                                                    '0 seconds ago',
                                                                                  ),
                                                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ].divide(SizedBox(width: 16.0)),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            valueOrDefault<String>(
                                                                              reviewColumnReviewRecord.description,
                                                                              'Description',
                                                                            ),
                                                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 12.0,
                                                                                  letterSpacing: 0.0,
                                                                                ),
                                                                          ),
                                                                          if (reviewColumnReviewRecord.userRef ==
                                                                              currentUserReference)
                                                                            Align(
                                                                              alignment: AlignmentDirectional(1.0, 1.0),
                                                                              child: Builder(
                                                                                builder: (context) => FlutterFlowIconButton(
                                                                                  borderRadius: 0.0,
                                                                                  buttonSize: 40.0,
                                                                                  icon: Icon(
                                                                                    Icons.edit_square,
                                                                                    color: Color(0xFFE97A4A),
                                                                                    size: 20.0,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    await showDialog(
                                                                                      barrierDismissible: false,
                                                                                      context: context,
                                                                                      builder: (dialogContext) {
                                                                                        return Dialog(
                                                                                          elevation: 0,
                                                                                          insetPadding: EdgeInsets.zero,
                                                                                          backgroundColor: Colors.transparent,
                                                                                          alignment: AlignmentDirectional(0.0, 1.0).resolve(Directionality.of(context)),
                                                                                          child: GestureDetector(
                                                                                            onTap: () => _unfocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(_unfocusNode) : FocusScope.of(context).unfocus(),
                                                                                            child: EditMealRatingBottomsheetComponentWidget(
                                                                                              id: reviewColumnReviewRecord.reference,
                                                                                              rating: reviewColumnReviewRecord.star,
                                                                                              feedback: reviewColumnReviewRecord.description,
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ).then((value) => setState(() {}));
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ].divide(SizedBox(height: 8.0)).addToStart(SizedBox(height: 8.0)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })
                                                                  .divide(SizedBox(
                                                                      height:
                                                                          16.0))
                                                                  .addToStart(
                                                                      SizedBox(
                                                                          height:
                                                                              8.0))
                                                                  .addToEnd(SizedBox(
                                                                      height:
                                                                          32.0)),
                                                            ),
                                                          );
                                                        },
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
