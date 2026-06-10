import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/deletion_reminder/deletion_reminder_widget.dart';
import '/pages/components/no_meal_category_found/no_meal_category_found_widget.dart';

/// Admin moderation dashboard with two tabs: pending account deletion
/// requests, and meal recipes that users have flagged as inappropriate.
class AdminHomeWidget extends StatefulWidget {
  const AdminHomeWidget({super.key});

  @override
  State<AdminHomeWidget> createState() => _AdminHomeWidgetState();
}

class _AdminHomeWidgetState extends State<AdminHomeWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _unfocusNode = FocusNode();
  late final TabController _tabBarController = TabController(
    length: 2,
    vsync: this,
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
      builder: (context, appState) {
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).success,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 54.0,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              title: Text(
                'Admin Control',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                    ),
              ),
              actions: const [],
              centerTitle: true,
              elevation: 2.0,
            ),
            body: SafeArea(
              top: true,
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: const Alignment(0.0, 0),
                            child: TabBar(
                              labelColor:
                                  FlutterFlowTheme.of(context).primaryText,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                              unselectedLabelStyle: const TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).success,
                              padding: const EdgeInsets.all(4.0),
                              tabs: const [
                                Tab(text: 'Delete Request'),
                                Tab(text: 'Meal Recipe Request'),
                              ],
                              controller: _tabBarController,
                              onTap: (i) async {
                                [() async {}, () async {}][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabBarController,
                              children: [
                                KeepAliveWidgetWrapper(
                                  builder: (context) => _buildDeleteRequestsTab(
                                      context, appState),
                                ),
                                KeepAliveWidgetWrapper(
                                  builder: (context) =>
                                      _buildMealRecipeRequestsTab(
                                          context, appState),
                                ),
                              ],
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
        );
      },
    );
  }

  Widget _buildDeleteRequestsTab(BuildContext context, app.AppState appState) {
    return StreamBuilder<List<DeleteAccountRequestRecord>>(
      stream: queryDeleteAccountRequestRecord(),
      builder: (context, snapshot) {
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
        final deleteRequestColumnDeleteAccountRequestRecordList = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: List.generate(
                deleteRequestColumnDeleteAccountRequestRecordList.length,
                (deleteRequestColumnIndex) {
              final deleteRequestColumnDeleteAccountRequestRecord =
                  deleteRequestColumnDeleteAccountRequestRecordList[
                      deleteRequestColumnIndex];
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    8.0, 0.0, 8.0, 0.0),
                child: StreamBuilder<UsersRecord>(
                  stream: UsersRecord.getDocument(
                      deleteRequestColumnDeleteAccountRequestRecord.userId!),
                  builder: (context, snapshot) {
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
                    final itemContainerUsersRecord = snapshot.data!;
                    return Container(
                      width: double.infinity,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          itemContainerUsersRecord.photoUrl,
                                          width: 300.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                itemContainerUsersRecord
                                                    .displayName,
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Poppins',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 0.0, 8.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    functions.notificationTime(
                                                        deleteRequestColumnDeleteAccountRequestRecord
                                                            .dateRequested),
                                                    'time past',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            itemContainerUsersRecord.email,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ].divide(
                                            const SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 8.0)),
                                ),
                                Text(
                                  'Reason:',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 8.0, 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        deleteRequestColumnDeleteAccountRequestRecord
                                                    .reason !=
                                                'Other'
                                            ? deleteRequestColumnDeleteAccountRequestRecord
                                                .reason
                                            : deleteRequestColumnDeleteAccountRequestRecord
                                                .otherReason,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                                  .divide(const SizedBox(height: 4.0))
                                  .addToStart(const SizedBox(height: 16.0)),
                            ),
                          ),
                          Builder(
                            builder: (context) => FFButtonWidget(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      elevation: 0,
                                      insetPadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      alignment: const AlignmentDirectional(
                                              0.0, 0.0)
                                          .resolve(Directionality.of(context)),
                                      child: GestureDetector(
                                        onTap: () =>
                                            _unfocusNode.canRequestFocus
                                                ? FocusScope.of(context)
                                                    .requestFocus(_unfocusNode)
                                                : FocusScope.of(context)
                                                    .unfocus(),
                                        child: const SizedBox(
                                          height: 150.0,
                                          width: 350.0,
                                          child: DeletionReminderWidget(),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                AppCubit.instance.setNoMoreMealRecipe(false);
                                while (AppCubit.instance.state.noMoreMealRecipe == false) {
                                  final mealRecipeItem =
                                      await queryMealRecipeRecordOnce(
                                    queryBuilder: (mealRecipeRecord) =>
                                        mealRecipeRecord.where(
                                      'author',
                                      isEqualTo:
                                          deleteRequestColumnDeleteAccountRequestRecord
                                              .userId,
                                    ),
                                    singleRecord: true,
                                  ).then((s) => s.firstOrNull);
                                  if (mealRecipeItem == null) {
                                    AppCubit.instance.setNoMoreMealRecipe(true);
                                  } else {
                                    await mealRecipeItem.reference.delete();
                                    AppCubit.instance.setNoMoreMealRecipe(false);
                                  }
                                }
                                AppCubit.instance.setNoMoreMealRecipe(false);
                                while (
                                    AppCubit.instance.state.noMoreSavedRecipe == false) {
                                  final savedRecipeItem =
                                      await querySavedRecipeRecordOnce(
                                    queryBuilder: (savedRecipeRecord) =>
                                        savedRecipeRecord.where(
                                      'user_id',
                                      isEqualTo:
                                          deleteRequestColumnDeleteAccountRequestRecord
                                              .userId,
                                    ),
                                    singleRecord: true,
                                  ).then((s) => s.firstOrNull);
                                  if (savedRecipeItem == null) {
                                    AppCubit.instance.setNoMoreSavedRecipe(true);
                                  } else {
                                    await savedRecipeItem.reference.delete();
                                    AppCubit.instance.setNoMoreSavedRecipe(false);
                                  }
                                }
                                final deleteAccountRequestItem =
                                    await queryDeleteAccountRequestRecordOnce(
                                  queryBuilder: (deleteAccountRequestRecord) =>
                                      deleteAccountRequestRecord.where(
                                    'user_id',
                                    isEqualTo:
                                        deleteRequestColumnDeleteAccountRequestRecord
                                            .userId,
                                  ),
                                  singleRecord: true,
                                ).then((s) => s.firstOrNull);
                                await deleteAccountRequestItem!.reference
                                    .delete();
                                await deleteRequestColumnDeleteAccountRequestRecord
                                    .userId!
                                    .delete();
                              },
                              text: '',
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: FlutterFlowTheme.of(context).info,
                                size: 36.0,
                              ),
                              options: FFButtonOptions(
                                height: double.infinity,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(0.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                        ].addToStart(const SizedBox(width: 8.0)),
                      ),
                    );
                  },
                ),
              );
            })
                .divide(const SizedBox(height: 16.0))
                .addToStart(const SizedBox(height: 16.0)),
          ),
        );
      },
    );
  }

  Widget _buildMealRecipeRequestsTab(
      BuildContext context, app.AppState appState) {
    return StreamBuilder<List<MealRecipeRecord>>(
      stream: queryMealRecipeRecord(
        queryBuilder: (mealRecipeRecord) => mealRecipeRecord
            .where('isPublic', isEqualTo: true)
            .where('isReady', isEqualTo: true)
            .where('isRecipeReported', isEqualTo: true),
      ),
      builder: (context, snapshot) {
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
        final theAllContentGridMealRecipeRecordList = snapshot.data!;
        if (theAllContentGridMealRecipeRecordList.isEmpty) {
          return const SizedBox(
            height: 150.0,
            child: NoMealCategoryFoundWidget(
              title: 'No Recipe Available',
              message: 'There are currently no recipes available.',
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 42.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 3.0,
            childAspectRatio: 1.0,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: theAllContentGridMealRecipeRecordList.length,
          itemBuilder: (context, theAllContentGridIndex) {
            final theAllContentGridMealRecipeRecord =
                theAllContentGridMealRecipeRecordList[theAllContentGridIndex];
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  16.0, 8.0, 16.0, 8.0),
              child: StreamBuilder<UsersRecord>(
                // MVP: null-safe author fallback.
                stream: UsersRecord.getDocument(
                    theAllContentGridMealRecipeRecord.author ??
                        currentUserReference!),
                builder: (context, snapshot) {
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
                  final item1UsersRecord = snapshot.data!;
                  return InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                        'details_screen',
                        queryParameters: {
                          'mealRef': serializeParam(
                            theAllContentGridMealRecipeRecord.reference,
                            ParamType.DocumentReference,
                          ),
                        }.withoutNulls,
                      );
                    },
                    child: Stack(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Hero(
                            tag: theAllContentGridMealRecipeRecord.banner,
                            transitionOnUserGestures: true,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                theAllContentGridMealRecipeRecord.banner,
                                width: 300.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        if (appState.tempHideWidget == false)
                          Opacity(
                            opacity: 0.2,
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 1.0),
                              child: Container(
                                width: double.infinity,
                                height: 80.0,
                                decoration: const BoxDecoration(
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 8.0, 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                theAllContentGridMealRecipeRecord.title,
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      lineHeight: 1.5,
                                    ),
                                minFontSize: 11.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'By: ${theAllContentGridMealRecipeRecord.attribution}',
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0.0, 0.0, 4.0, 0.0),
                                        child: Icon(
                                          Icons.timer_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 12.0,
                                        ),
                                      ),
                                      Text(
                                        dateTimeFormat(
                                            'Hm',
                                            theAllContentGridMealRecipeRecord
                                                    .prepTime ??
                                                DateTime(2024)),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w300,
                                            ),
                                      ),
                                    ],
                                  ),
                                ].divide(const SizedBox(width: 10.0)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    'Added by: ${item1UsersRecord.displayName}'
                                        .maybeHandleOverflow(maxChars: 35),
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 10.0,
                                          letterSpacing: 0.0,
                                        ),
                                    minFontSize: 8.0,
                                  ),
                                ],
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                      ],
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
}
