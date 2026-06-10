import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/cubits/auth/auth_cubit.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/no_meal_category_found/no_meal_category_found_widget.dart';
import '/pages/components/no_search_results_component/no_search_results_component_widget.dart';
import '/pages/components/resend_email_component/resend_email_component_widget.dart';
import 'home_cubit.dart';
import 'home_state.dart';

/// Home — Cubit conversion.
///
/// [HomeWidget] is now a thin shell that injects [HomeCubit]. The real screen
/// is [_HomeView] (kept Stateful so we own text/focus controllers and the
/// `ExpandableController`, which don't compose with immutable state).
///
/// State machine:
///   * [HomeState] holds the in-page search hits and the category-filter
///     result. Both used to be `HomeModel` fields mutated with `setState`.
///   * [HomeCubit] owns the page-load orchestration (paired-user check +
///     notification drain), refresh, search, category filter, FAB action.
///   * Global app state reads/writes go through `AppCubit.instance` —
///     reads return the immutable `AppState`, writes go through `set*` /
///     `addTo*` / etc. methods that emit a new state.
class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..onPageLoad(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hasIconTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  // Widget-local controllers — these don't move into the cubit because
  // Flutter's text-field/focus machinery is imperative and lifecycle-coupled
  // to a State object.
  final _unfocusNode = FocusNode();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  late final ExpandableController _expandableController;

  /// Memoised future for the unread-meal-requests count badge. Reset to null
  /// by the refresh icon so the next rebuild re-runs the query. Matches the
  /// original FlutterFlow `firestoreRequestCompleter` pattern.
  Completer<int>? _firestoreRequestCompleter;

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController(initialExpanded: true);

    // Kick off the page-load orchestration. The cubit owns it now; we just
    // need a frame to be in place before we touch context.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (mounted) setState(() {});
    });

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 60.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.linear,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to AppCubit so any `AppCubit.instance.state.x` read further down (which
    // proxies to AppCubit.instance.state) triggers a rebuild when those
    // fields change. Cheap because Equatable filters duplicate states.
    return BlocBuilder<AppCubit, app.AppState>(
      builder: (context, appState) =>
          BlocBuilder<HomeCubit, HomeState>(builder: (context, homeState) {
        return _buildBody(context, appState, homeState);
      }),
    );
  }

  Widget _buildBody(BuildContext context, app.AppState appState,
      HomeState homeState) {
    return StreamBuilder<List<SavedRecipeRecord>>(
      stream: querySavedRecipeRecord(
        queryBuilder: (savedRecipeRecord) => savedRecipeRecord.where(
          'user_id',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
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
        List<SavedRecipeRecord> homeSavedRecipeRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final homeSavedRecipeRecord = homeSavedRecipeRecordList.isNotEmpty
            ? homeSavedRecipeRecordList.first
            : null;
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              floatingActionButton: Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () async {
                    // Refresh from Firebase so the email-verified flag is
                    // accurate before we let the user start a new recipe.
                    await context.read<AuthCubit>().refreshCurrentUser();
                    if (currentUserEmailVerified == true) {
                      final mealRef = await context
                          .read<HomeCubit>()
                          .createBlankMealRecipe();
                      if (mealRef != null && context.mounted) {
                        context.pushNamed(
                          'add_recipe_screen',
                          queryParameters: {
                            'userRef': serializeParam(
                              currentUserReference,
                              ParamType.DocumentReference,
                            ),
                            'mealRef': serializeParam(
                              mealRef,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                        );
                      }
                    } else {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return Dialog(
                            elevation: 0,
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            alignment: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            child: GestureDetector(
                              onTap: () => _unfocusNode.canRequestFocus
                                  ? FocusScope.of(context)
                                      .requestFocus(_unfocusNode)
                                  : FocusScope.of(context).unfocus(),
                              child: ResendEmailComponentWidget(),
                            ),
                          );
                        },
                      ).then((value) => setState(() {}));
                    }

                    setState(() {});
                  },
                  backgroundColor: FlutterFlowTheme.of(context).success,
                  elevation: 8.0,
                  child: Icon(
                    Icons.add,
                    color: FlutterFlowTheme.of(context).info,
                    size: 24.0,
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
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 24.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Hello ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                lineHeight: 1.5,
                                              ),
                                        ),
                                        AuthUserStreamWidget(
                                          builder: (context) => Text(
                                            currentUserDisplayName,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 20.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ).animateOnPageLoad(animationsMap[
                                        'rowOnPageLoadAnimation']!),
                                    Text(
                                      'What meal do you want to prepare?',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFA9A9A9),
                                            fontSize: 11.0,
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                          ),
                                    ).animateOnPageLoad(animationsMap[
                                        'textOnPageLoadAnimation']!),
                                  ],
                                ),
                                AuthUserStreamWidget(
                                  builder: (context) => InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      // resolvePartnerForProfileNav returns
                                      // the partner ref if one exists and
                                      // also pushes it into AppCubit so the
                                      // profile screen can read it. If no
                                      // pair, we open the user's own profile.
                                      final partnerRef = await context
                                          .read<HomeCubit>()
                                          .resolvePartnerForProfileNav();
                                      if (!context.mounted) return;
                                      context.pushNamed(
                                        'profile_screen',
                                        queryParameters: {
                                          'userDocRef': serializeParam(
                                            currentUserReference,
                                            ParamType.DocumentReference,
                                          ),
                                          'partnerRef': serializeParam(
                                            partnerRef ?? currentUserReference,
                                            ParamType.DocumentReference,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey:
                                              const TransitionInfo(
                                            hasTransition: true,
                                            transitionType:
                                                PageTransitionType.fade,
                                            duration:
                                                Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        currentUserPhoto,
                                        width: 40.0,
                                        height: 40.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                child: Container(
                                  width: 200.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Color(0xFFD9D9D9),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: Icon(
                                          Icons.search_sharp,
                                          color: Color(0xFFBDBDBD),
                                          size: 24.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _searchController,
                                          focusNode: _searchFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: false,
                                            hintText: 'Search recipe',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFA9A9A9),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      lineHeight: 1.5,
                                                    ),
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                lineHeight: 1.5,
                                              ),
                                        ),
                                      ),
                                      if (_searchController.text != '')
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            setState(_searchController.clear);
                                            AppCubit.instance.setIsShowFullList(true);
                                          },
                                          child: Icon(
                                            Icons.close_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 18.0,
                                          ),
                                        ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          final query = _searchController.text;
                                          if (query.isEmpty) return;
                                          try {
                                            final records =
                                                await queryMealRecipeRecordOnce();
                                            final hits = TextSearch(
                                              records
                                                  .map((r) => TextSearchItem
                                                      .fromTerms(
                                                          r, [r.title!]))
                                                  .toList(),
                                            )
                                                .search(query)
                                                .map((r) => r.object)
                                                .toList();
                                            if (!context.mounted) return;
                                            context
                                                .read<HomeCubit>()
                                                .setSearchResults(hits);
                                          } catch (_) {
                                            if (!context.mounted) return;
                                            context
                                                .read<HomeCubit>()
                                                .setSearchResults(const []);
                                          }
                                          AppCubit.instance.setIsShowFullList(false);
                                        },
                                        text: 'Search',
                                        options: FFButtonOptions(
                                          height: 45.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
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
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 4.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (AppCubit.instance.state.hasPartner == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (animationsMap[
                                            'iconOnActionTriggerAnimation'] !=
                                        null) {
                                      setState(() => hasIconTriggered = true);
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) async =>
                                              await animationsMap[
                                                      'iconOnActionTriggerAnimation']!
                                                  .controller
                                                ..reset()
                                                ..repeat());
                                    }
                                    // Refresh paired user + invalidate the
                                    // memoised notification-count future so
                                    // the badge re-queries.
                                    await context
                                        .read<HomeCubit>()
                                        .refreshPairedUser();
                                    setState(() {
                                      _firestoreRequestCompleter = null;
                                    });
                                    await Future<void>.delayed(
                                        const Duration(milliseconds: 500));
                                    if (animationsMap[
                                            'iconOnActionTriggerAnimation'] !=
                                        null) {
                                      animationsMap[
                                              'iconOnActionTriggerAnimation']!
                                          .controller
                                          .stop();
                                    }
                                    if (mounted) setState(() {});
                                  },
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    size: 24.0,
                                  ),
                                ).animateOnActionTrigger(
                                    animationsMap[
                                        'iconOnActionTriggerAnimation']!,
                                    hasBeenTriggered: hasIconTriggered),
                                FutureBuilder<int>(
                                  future: (_firestoreRequestCompleter ??=
                                          Completer<int>()
                                            ..complete(
                                                queryMealRequestedNotificationRecordCount(
                                              queryBuilder:
                                                  (mealRequestedNotificationRecord) =>
                                                      mealRequestedNotificationRecord
                                                          .where(
                                                            'paired_user_id',
                                                            isEqualTo: AppCubit.instance.state.pairedUserCollection,
                                                          )
                                                          .where(
                                                            'content_status',
                                                            isEqualTo:
                                                                'pending',
                                                          ),
                                            )))
                                      .future,
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
                                    int notificationColumnCount =
                                        snapshot.data!;
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (AppCubit.instance.state.hasPartner == true)
                                          badges.Badge(
                                            badgeContent: Text(
                                              notificationColumnCount != 0
                                                  ? '${notificationColumnCount.toString()}'
                                                  : '0',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            showBadge:
                                                notificationColumnCount != 0,
                                            badgeStyle: badges.BadgeStyle(
                                              shape: badges.BadgeShape.circle,
                                              badgeColor:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              elevation: 2.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 8.0, 8.0, 8.0),
                                            ),
                                            position:
                                                badges.BadgePosition.topEnd(),
                                            // badgeAnimation:
                                            //     badges.BadgeAnimation(
                                            //   type: badges
                                            //       .BadgeAnimationType.scale,
                                            //   toAnimate: true,
                                            // ),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  context.pushNamed(
                                                    'meal_request_notification_screen',
                                                    queryParameters: {
                                                      'pairedUserRef':
                                                          serializeParam(
                                                        AppCubit.instance.state.pairedUserCollection,
                                                        ParamType
                                                            .DocumentReference,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                },
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .conciergeBell,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .success,
                                                  size: 36.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: ExpandableNotifier(
                                controller:
                                    _expandableController,
                                child: ExpandablePanel(
                                  header: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Public Recipes',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      if (AppCubit.instance.state.tappedCategoryName
                                              .length !=
                                          0)
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, -1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    2.0, 0.0, 0.0, 8.0),
                                            child: Text(
                                              'Filtered',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  collapsed: Container(
                                    width: double.infinity,
                                    height: 40.0,
                                    decoration: BoxDecoration(),
                                    child: Builder(
                                      builder: (context) {
                                        final recipeCategoriesListView =
                                            AppCubit.instance.state.homeRecipeCategory
                                                .toList();
                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              recipeCategoriesListView.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(width: 8.0),
                                          itemBuilder: (context,
                                              recipeCategoriesListViewIndex) {
                                            final recipeCategoriesListViewItem =
                                                recipeCategoriesListView[
                                                    recipeCategoriesListViewIndex];
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      var _shouldSetState =
                                                          false;
                                                      if (recipeCategoriesListViewItem !=
                                                          'All') {
                                                        if (AppCubit.instance.state.tappedCategoryName
                                                                .contains(
                                                                    recipeCategoriesListViewItem) ==
                                                            true) {
                                                          setState(() {
                                                            AppCubit.instance.removeFromTappedCategoryName(
                                                                    recipeCategoriesListViewItem);
                                                          });
                                                          if (AppCubit.instance.state.tappedCategoryName
                                                                  .length ==
                                                              0) {
                                                            setState(() {
                                                              AppCubit.instance.setIsMealFilteredByCategory(false);
                                                              AppCubit.instance.setTappedCategoryName([]);
                                                            });
                                                            if (_shouldSetState)
                                                              setState(() {});
                                                            return;
                                                          } else {
                                                            setState(() {
                                                              AppCubit.instance.setIsMealFilteredByCategory(true);
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            AppCubit.instance.addToTappedCategoryName(
                                                                    recipeCategoriesListViewItem);
                                                            AppCubit.instance.setIsMealFilteredByCategory(true);
                                                          });
                                                        }

                                                        await context
                                                            .read<HomeCubit>()
                                                            .applyCategoryFilter(
                                                                AppCubit.instance.state.tappedCategoryName);
                                                        _shouldSetState = true;
                                                      } else {
                                                        setState(() {
                                                          AppCubit.instance.setIsMealFilteredByCategory(false);
                                                          AppCubit.instance.setTappedCategoryName([]);
                                                        });
                                                      }

                                                      if (_shouldSetState)
                                                        setState(() {});
                                                    },
                                                    child: Container(
                                                      height: 40.0,
                                                      decoration: BoxDecoration(
                                                        color: () {
                                                          if (AppCubit.instance.state.isMealFilteredByCategory ==
                                                              false) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .success;
                                                          } else if ((AppCubit.instance.state.isMealFilteredByCategory ==
                                                                  true) &&
                                                              (AppCubit.instance.state.tappedCategoryName
                                                                      .contains(
                                                                          recipeCategoriesListViewItem) ==
                                                                  true)) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .success;
                                                          } else {
                                                            return Color(
                                                                0xFFBAB5B5);
                                                          }
                                                        }(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: Text(
                                                            recipeCategoriesListViewItem,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  fontSize:
                                                                      13.0,
                                                                  letterSpacing:
                                                                      recipeCategoriesListViewIndex ==
                                                                              0
                                                                          ? 3.0
                                                                          : 0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  expanded: Container(),
                                  theme: ExpandableThemeData(
                                    tapHeaderToExpand: true,
                                    tapBodyToExpand: false,
                                    tapBodyToCollapse: false,
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    hasIcon: true,
                                    collapseIcon: Icons.filter_list_rounded,
                                    iconSize: 26.0,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (AppCubit.instance.state.isShowFullList) {
                                return Builder(
                                  builder: (context) {
                                    if (AppCubit.instance.state.isMealFilteredByCategory ==
                                        false) {
                                      return StreamBuilder<
                                          List<MealRecipeRecord>>(
                                        stream: queryMealRecipeRecord(
                                          queryBuilder: (mealRecipeRecord) =>
                                              mealRecipeRecord
                                                  .where(
                                                    'isPublic',
                                                    isEqualTo: true,
                                                  )
                                                  .where(
                                                    'isReady',
                                                    isEqualTo: true,
                                                  )
                                                  .where(
                                                    'admin_approved',
                                                    isEqualTo: true,
                                                  ),
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
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          List<MealRecipeRecord>
                                              theAllContentGridMealRecipeRecordList =
                                              snapshot.data!;
                                          if (theAllContentGridMealRecipeRecordList
                                              .isEmpty) {
                                            return Container(
                                              height: 150.0,
                                              child: NoMealCategoryFoundWidget(
                                                title: 'No Recipe Available',
                                                message:
                                                    'There are currently no recipes available.',
                                              ),
                                            );
                                          }
                                          return GridView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              64.0,
                                            ),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 1.0,
                                              mainAxisSpacing: 9.0,
                                              childAspectRatio: 1.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                theAllContentGridMealRecipeRecordList
                                                    .length,
                                            itemBuilder: (context,
                                                theAllContentGridIndex) {
                                              final theAllContentGridMealRecipeRecord =
                                                  theAllContentGridMealRecipeRecordList[
                                                      theAllContentGridIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 8.0, 16.0, 8.0),
                                                child:
                                                    StreamBuilder<UsersRecord>(
                                                  // MVP: `.author` can be null
                                                  // when the seed roundtrip
                                                  // through fake_cloud_firestore
                                                  // drops the DocumentReference.
                                                  // Fall back to the current
                                                  // (demo) user so we never
                                                  // hit a null-check crash.
                                                  stream: UsersRecord.getDocument(
                                                      theAllContentGridMealRecipeRecord
                                                              .author ??
                                                          currentUserReference!),
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
                                                    final item1UsersRecord =
                                                        snapshot.data!;
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
                                                        context.pushNamed(
                                                          'details_screen',
                                                          queryParameters: {
                                                            'mealRef':
                                                                serializeParam(
                                                              theAllContentGridMealRecipeRecord
                                                                  .reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                            'savedRecipeDoc':
                                                                serializeParam(
                                                              homeSavedRecipeRecord
                                                                  ?.reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Hero(
                                                                tag:
                                                                    theAllContentGridMealRecipeRecord
                                                                        .banner,
                                                                transitionOnUserGestures:
                                                                    true,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .network(
                                                                    theAllContentGridMealRecipeRecord
                                                                        .banner,
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
                                                              opacity: 0.3,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                              ),
                                                            ),
                                                            if (AppCubit.instance.state.tempHideWidget ==
                                                                false)
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
                                                                        80.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
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
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          8.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoSizeText(
                                                                    theAllContentGridMealRecipeRecord
                                                                        .title,
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                    minFontSize:
                                                                        11.0,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'By: ${theAllContentGridMealRecipeRecord.attribution}',
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 10.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                4.0,
                                                                                0.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.timer_sharp,
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            dateTimeFormat('Hm',
                                                                                theAllContentGridMealRecipeRecord.prepTime ?? DateTime(2024)),
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
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            10.0)),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      AutoSizeText(
                                                                        'Added by: ${item1UsersRecord.displayName}'.maybeHandleOverflow(
                                                                            maxChars:
                                                                                35),
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 10.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        minFontSize:
                                                                            8.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        4.0)),
                                                              ),
                                                            ),
                                                            Stack(
                                                              children: [
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.contains(
                                                                            theAllContentGridMealRecipeRecord.reference) ==
                                                                    false)
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            32.0,
                                                                        height:
                                                                            32.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              AppCubit.instance.addToSavedRecipeList(theAllContentGridMealRecipeRecord.reference);
                                                                            });

                                                                            // MVP: fake_cloud_firestore drops DocumentReferences inside
                                                                            // FieldValue.arrayUnion. Splice locally and write the full list.
                                                                            final ref = theAllContentGridMealRecipeRecord.reference;
                                                                            final current = homeSavedRecipeRecord?.savedMealRecipeId ?? const <DocumentReference>[];
                                                                            final next = [
                                                                              ...current.where((r) => r.path != ref.path),
                                                                              ref,
                                                                            ];
                                                                            await homeSavedRecipeRecord!.reference.update({'saved_meal_recipe_id': next});
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.bookmark_border,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).success,
                                                                            size:
                                                                                22.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                // Path-based comparison — fake_cloud_firestore's
                                                                // DocumentReference equality isn't reliable, so .contains()
                                                                // returns false even when the ref is in the list.
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.any((r) =>
                                                                            r.path ==
                                                                            theAllContentGridMealRecipeRecord.reference.path) ==
                                                                    true)
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            32.0,
                                                                        height:
                                                                            32.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              AppCubit.instance.removeFromSavedRecipeList(theAllContentGridMealRecipeRecord.reference);
                                                                            });

                                                                            // See arrayUnion site above re: fake_cloud_firestore.
                                                                            final ref = theAllContentGridMealRecipeRecord.reference;
                                                                            final current = homeSavedRecipeRecord?.savedMealRecipeId ?? const <DocumentReference>[];
                                                                            final next = current.where((r) => r.path != ref.path).toList();
                                                                            await homeSavedRecipeRecord!.reference.update({'saved_meal_recipe_id': next});
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.bookmark_rounded,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).success,
                                                                            size:
                                                                                22.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      return Builder(
                                        builder: (context) {
                                          final filteredList = homeState
                                                  .mealFilteredByCategory
                                                  ?.toList() ??
                                              [];
                                          if (filteredList.isEmpty) {
                                            return Center(
                                              child: Container(
                                                height: 150.0,
                                                child:
                                                    NoMealCategoryFoundWidget(
                                                  title: 'No Meal Recipe',
                                                  message:
                                                      'It seems that there are no recipes in this category.',
                                                ),
                                              ),
                                            );
                                          }
                                          return GridView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              64.0,
                                            ),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 1.0,
                                              mainAxisSpacing: 9.0,
                                              childAspectRatio: 1.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: filteredList.length,
                                            itemBuilder:
                                                (context, filteredListIndex) {
                                              final filteredListItem =
                                                  filteredList[
                                                      filteredListIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 8.0, 16.0, 8.0),
                                                child:
                                                    StreamBuilder<UsersRecord>(
                                                  // MVP: see comment in the
                                                  // Public Recipes grid above
                                                  // re: null-safe author.
                                                  stream:
                                                      UsersRecord.getDocument(
                                                          filteredListItem
                                                                  .author ??
                                                              currentUserReference!),
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
                                                    final item1UsersRecord =
                                                        snapshot.data!;
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
                                                        context.pushNamed(
                                                          'details_screen',
                                                          queryParameters: {
                                                            'mealRef':
                                                                serializeParam(
                                                              filteredListItem
                                                                  .reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                            'savedRecipeDoc':
                                                                serializeParam(
                                                              homeSavedRecipeRecord
                                                                  ?.reference,
                                                              ParamType
                                                                  .DocumentReference,
                                                            ),
                                                          }.withoutNulls,
                                                        );
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Stack(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              child: Hero(
                                                                tag:
                                                                    filteredListItem
                                                                        .banner,
                                                                transitionOnUserGestures:
                                                                    true,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .network(
                                                                    filteredListItem
                                                                        .banner,
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
                                                              opacity: 0.3,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                              ),
                                                            ),
                                                            if (AppCubit.instance.state.tempHideWidget ==
                                                                false)
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
                                                                        80.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
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
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          8.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoSizeText(
                                                                    filteredListItem
                                                                        .title,
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                    minFontSize:
                                                                        11.0,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'By: ${filteredListItem.attribution}',
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 10.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                4.0,
                                                                                0.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.timer_sharp,
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            dateTimeFormat('Hm',
                                                                                filteredListItem.prepTime ?? DateTime(2024)),
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
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            10.0)),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      AutoSizeText(
                                                                        'Added by: ${item1UsersRecord.displayName}'.maybeHandleOverflow(
                                                                            maxChars:
                                                                                35),
                                                                        maxLines:
                                                                            1,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                              fontSize: 10.0,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                        minFontSize:
                                                                            8.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        4.0)),
                                                              ),
                                                            ),
                                                            Stack(
                                                              children: [
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.contains(
                                                                            filteredListItem.reference) ==
                                                                    false)
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            32.0,
                                                                        height:
                                                                            32.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              AppCubit.instance.addToSavedRecipeList(filteredListItem.reference);
                                                                            });

                                                                            // MVP: splice locally; see Public Recipes grid above.
                                                                            final ref = filteredListItem.reference;
                                                                            final current = homeSavedRecipeRecord?.savedMealRecipeId ?? const <DocumentReference>[];
                                                                            final next = [
                                                                              ...current.where((r) => r.path != ref.path),
                                                                              ref,
                                                                            ];
                                                                            await homeSavedRecipeRecord!.reference.update({'saved_meal_recipe_id': next});
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.bookmark_border,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).success,
                                                                            size:
                                                                                22.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                // Path-based comparison; see Public Recipes grid.
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.any((r) =>
                                                                            r.path ==
                                                                            filteredListItem.reference.path) ==
                                                                    true)
                                                                  Align(
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          8.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            32.0,
                                                                        height:
                                                                            32.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              AppCubit.instance.removeFromSavedRecipeList(filteredListItem.reference);
                                                                            });

                                                                            // MVP: splice locally.
                                                                            final ref = filteredListItem.reference;
                                                                            final current = homeSavedRecipeRecord?.savedMealRecipeId ?? const <DocumentReference>[];
                                                                            final next = current.where((r) => r.path != ref.path).toList();
                                                                            await homeSavedRecipeRecord!.reference.update({'saved_meal_recipe_id': next});
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.bookmark_rounded,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).success,
                                                                            size:
                                                                                22.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              } else {
                                return Builder(
                                  builder: (context) {
                                    final searchResult =
                                        homeState.searchResults.toList();
                                    if (searchResult.isEmpty) {
                                      return NoSearchResultsComponentWidget(
                                        searchItemName: _searchController.text,
                                      );
                                    }
                                    return GridView.builder(
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        0,
                                        64.0,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 1.0,
                                        mainAxisSpacing: 9.0,
                                        childAspectRatio: 1.0,
                                      ),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: searchResult.length,
                                      itemBuilder:
                                          (context, searchResultIndex) {
                                        final searchResultItem =
                                            searchResult[searchResultIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 8.0, 16.0, 8.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                'details_screen',
                                                queryParameters: {
                                                  'mealRef': serializeParam(
                                                    searchResultItem.reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                  'savedRecipeDoc':
                                                      serializeParam(
                                                    homeSavedRecipeRecord
                                                        ?.reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Stack(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        searchResultItem.banner,
                                                        width: 300.0,
                                                        height: 200.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: 0.2,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  if (AppCubit.instance.state.tempHideWidget ==
                                                      false)
                                                    Opacity(
                                                      opacity: 0.2,
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 1.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 80.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      10.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10.0),
                                                              topLeft: Radius
                                                                  .circular(
                                                                      0.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      0.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                8.0, 8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        AutoSizeText(
                                                          searchResultItem
                                                              .title,
                                                          maxLines: 1,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                lineHeight: 1.5,
                                                              ),
                                                          minFontSize: 11.0,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            StreamBuilder<
                                                                UsersRecord>(
                                                              // MVP: see
                                                              // null-safe
                                                              // author comment
                                                              // in Public
                                                              // Recipes grid.
                                                              stream: UsersRecord
                                                                  .getDocument(
                                                                      searchResultItem
                                                                              .author ??
                                                                          currentUserReference!),
                                                              builder: (context,
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
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(
                                                                          FlutterFlowTheme.of(context)
                                                                              .success,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                final textUsersRecord =
                                                                    snapshot
                                                                        .data!;
                                                                return Text(
                                                                  'By: ${searchResultItem.attribution}',
                                                                  maxLines: 1,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                );
                                                              },
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .timer_sharp,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    size: 12.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    dateTimeFormat(
                                                                        'Hm',
                                                                        searchResultItem
                                                                            .prepTime),
                                                                    '00:00',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontSize:
                                                                            10.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 10.0)),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            AuthUserStreamWidget(
                                                              builder: (context) =>
                                                                  AutoSizeText(
                                                                'Added by: ${currentUserDisplayName}'
                                                                    .maybeHandleOverflow(
                                                                        maxChars:
                                                                            35),
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                                minFontSize:
                                                                    8.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 4.0)),
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      if (homeSavedRecipeRecord
                                                              ?.savedMealRecipeId
                                                              ?.contains(
                                                                  searchResultItem
                                                                      .reference) ==
                                                          false)
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        8.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Container(
                                                              width: 32.0,
                                                              height: 32.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: InkWell(
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
                                                                  // MVP: splice locally; see Public Recipes grid.
                                                                  final ref = homeState
                                                                      .searchResults[searchResultIndex]
                                                                      .reference;
                                                                  final current = homeSavedRecipeRecord?.savedMealRecipeId ??
                                                                      const <DocumentReference>[];
                                                                  final next = [
                                                                    ...current.where((r) => r.path != ref.path),
                                                                    ref,
                                                                  ];
                                                                  await homeSavedRecipeRecord!
                                                                      .reference
                                                                      .update({'saved_meal_recipe_id': next});
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .bookmark_border,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .success,
                                                                  size: 22.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      // Path-based comparison; see Public Recipes grid.
                                                      if (homeSavedRecipeRecord
                                                              ?.savedMealRecipeId
                                                              ?.any((r) =>
                                                                  r.path ==
                                                                  searchResultItem
                                                                      .reference.path) ==
                                                          true)
                                                        Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  1.0, -1.0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        8.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Container(
                                                              width: 32.0,
                                                              height: 32.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: InkWell(
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
                                                                  // MVP: splice locally.
                                                                  final ref = homeState
                                                                      .searchResults[searchResultIndex]
                                                                      .reference;
                                                                  final current = homeSavedRecipeRecord?.savedMealRecipeId ??
                                                                      const <DocumentReference>[];
                                                                  final next = current
                                                                      .where((r) => r.path != ref.path)
                                                                      .toList();
                                                                  await homeSavedRecipeRecord!
                                                                      .reference
                                                                      .update({'saved_meal_recipe_id': next});
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .bookmark_rounded,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .success,
                                                                  size: 22.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
