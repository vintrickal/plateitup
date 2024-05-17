import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/no_meal_category_found/no_meal_category_found_widget.dart';
import '/pages/components/no_search_results_component/no_search_results_component_widget.dart';
import '/pages/components/resend_email_component/resend_email_component_widget.dart';
import 'dart:math';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'home_model.dart';
export 'home_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hasIconTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.pairedUserChecker = await queryPairedUserRecordCount();
      if (_model.pairedUserChecker != 0) {
        _model.pairedUserCollectionReceiver = await queryPairedUserRecordOnce(
          queryBuilder: (pairedUserRecord) => pairedUserRecord.where(
            'recipient',
            isEqualTo: currentUserReference,
          ),
          singleRecord: true,
        ).then((s) => s.firstOrNull);
        if ((_model.pairedUserCollectionReceiver != null) == true) {
          setState(() {
            FFAppState().hasPartner = true;
            FFAppState().pairedUserCollection =
                _model.pairedUserCollectionReceiver?.reference;
          });
          setState(() => _model.firestoreRequestCompleter = null);
          await _model.waitForFirestoreRequestCompleted(minWait: 500);
          _model.cOUNTReceiver = await queryReceiverNotificationRecordCount(
            queryBuilder: (receiverNotificationRecord) =>
                receiverNotificationRecord
                    .where(
                      'user_id',
                      isEqualTo: currentUserReference,
                    )
                    .where(
                      'is_shown_to_user',
                      isEqualTo: false,
                    ),
          );
          if (_model.cOUNTReceiver == 0) {
            _model.cOUNTSender = await querySenderNotificationRecordCount(
              queryBuilder: (senderNotificationRecord) =>
                  senderNotificationRecord
                      .where(
                        'user_id',
                        isEqualTo: currentUserReference,
                      )
                      .where(
                        'is_shown_to_user',
                        isEqualTo: false,
                      ),
            );
            if (_model.cOUNTSender == 0) {
              setState(() {
                FFAppState().counterBtnClicked = 0;
              });
              await actions.requestNotificationPermissions();
            } else {
              // receiver-notification loop
              while (FFAppState().senderNotificationDisplayed == false) {
                _model.senderDetails = await querySenderNotificationRecordOnce(
                  queryBuilder: (senderNotificationRecord) =>
                      senderNotificationRecord
                          .where(
                            'user_id',
                            isEqualTo: currentUserReference,
                          )
                          .where(
                            'is_shown_to_user',
                            isEqualTo: false,
                          ),
                  singleRecord: true,
                ).then((s) => s.firstOrNull);
                await actions.localNotification(
                  _model.senderDetails?.mealTitle,
                  _model.senderDetails?.mealStatusMessage,
                );

                await _model.senderDetails!.reference
                    .update(createSenderNotificationRecordData(
                  isShownToUser: true,
                ));
                _model.cOUNTInsideSenderLoop =
                    await querySenderNotificationRecordCount(
                  queryBuilder: (senderNotificationRecord) =>
                      senderNotificationRecord
                          .where(
                            'user_id',
                            isEqualTo: currentUserReference,
                          )
                          .where(
                            'is_shown_to_user',
                            isEqualTo: false,
                          ),
                );
                if (_model.cOUNTInsideSenderLoop == 0) {
                  setState(() {
                    FFAppState().senderNotificationDisplayed = true;
                  });
                } else {
                  setState(() {
                    FFAppState().senderNotificationDisplayed = false;
                  });
                }
              }
            }
          } else {
            // receiver-notification loop
            while (FFAppState().receiverNotificationDisplayed == false) {
              _model.receiverDetails =
                  await queryReceiverNotificationRecordOnce(
                queryBuilder: (receiverNotificationRecord) =>
                    receiverNotificationRecord
                        .where(
                          'user_id',
                          isEqualTo: currentUserReference,
                        )
                        .where(
                          'is_shown_to_user',
                          isEqualTo: false,
                        ),
                singleRecord: true,
              ).then((s) => s.firstOrNull);
              await actions.localNotification(
                _model.receiverDetails?.mealTitle,
                _model.receiverDetails?.mealStatusMessage,
              );

              await _model.receiverDetails!.reference
                  .update(createReceiverNotificationRecordData(
                isShownToUser: true,
              ));
              _model.cOUNTInsideReceiverLoop =
                  await queryReceiverNotificationRecordCount(
                queryBuilder: (receiverNotificationRecord) =>
                    receiverNotificationRecord
                        .where(
                          'user_id',
                          isEqualTo: currentUserReference,
                        )
                        .where(
                          'is_shown_to_user',
                          isEqualTo: false,
                        ),
              );
              if (_model.cOUNTInsideReceiverLoop == 0) {
                setState(() {
                  FFAppState().receiverNotificationDisplayed = true;
                });
              } else {
                setState(() {
                  FFAppState().receiverNotificationDisplayed = false;
                });
              }
            }
          }
        } else {
          setState(() {
            FFAppState().hasPartner = false;
          });
        }
      } else {
        setState(() {
          FFAppState().hasPartner = false;
        });
      }

      setState(() {
        FFAppState().counterBtnClicked = 0;
        FFAppState().senderNotificationDisplayed = false;
        FFAppState().receiverNotificationDisplayed = false;
      });
      await actions.requestNotificationPermissions();
    });

    _model.searchRecipeTextTextController ??= TextEditingController();
    _model.searchRecipeTextFocusNode ??= FocusNode();

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: true);
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              floatingActionButton: Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () async {
                    await authManager.refreshUser();
                    if (currentUserEmailVerified == true) {
                      while (FFAppState().counterBtnClicked == 0) {
                        setState(() {
                          FFAppState().counterBtnClicked =
                              FFAppState().counterBtnClicked + 1;
                        });

                        var mealRecipeRecordReference =
                            MealRecipeRecord.collection.doc();
                        await mealRecipeRecordReference.set({
                          ...createMealRecipeRecordData(
                            title: '',
                            duration: '',
                            banner:
                                'https://fakeimg.pl/600x150/cccccc/ffffff?text=Temp+Image',
                            videolink: '',
                            author: currentUserReference,
                            isPublic: true,
                            isReady: false,
                            prepTime: FFAppState().estimatedTimeSpinner,
                            adminApproved: false,
                          ),
                          ...mapToFirestore(
                            {
                              'ingredient': getIngredientListFirestoreData(
                                FFAppState()
                                    .ingredientList
                                    .map(
                                        (e) => IngredientStruct.maybeFromMap(e))
                                    .withoutNulls
                                    .toList(),
                              ),
                              'procedure': getProcedureListFirestoreData(
                                FFAppState()
                                    .stepsList
                                    .map((e) => ProcedureStruct.maybeFromMap(e))
                                    .withoutNulls
                                    .toList(),
                              ),
                              'dateCreated': FieldValue.serverTimestamp(),
                            },
                          ),
                        });
                        _model.createdMealRecipeCollection =
                            MealRecipeRecord.getDocumentFromData({
                          ...createMealRecipeRecordData(
                            title: '',
                            duration: '',
                            banner:
                                'https://fakeimg.pl/600x150/cccccc/ffffff?text=Temp+Image',
                            videolink: '',
                            author: currentUserReference,
                            isPublic: true,
                            isReady: false,
                            prepTime: FFAppState().estimatedTimeSpinner,
                            adminApproved: false,
                          ),
                          ...mapToFirestore(
                            {
                              'ingredient': getIngredientListFirestoreData(
                                FFAppState()
                                    .ingredientList
                                    .map(
                                        (e) => IngredientStruct.maybeFromMap(e))
                                    .withoutNulls
                                    .toList(),
                              ),
                              'procedure': getProcedureListFirestoreData(
                                FFAppState()
                                    .stepsList
                                    .map((e) => ProcedureStruct.maybeFromMap(e))
                                    .withoutNulls
                                    .toList(),
                              ),
                              'dateCreated': DateTime.now(),
                            },
                          ),
                        }, mealRecipeRecordReference);

                        await _model.createdMealRecipeCollection!.reference
                            .update(createMealRecipeRecordData(
                          mealRecipeId:
                              _model.createdMealRecipeCollection?.reference.id,
                        ));
                        setState(() {
                          FFAppState().addIsBasicRecipeInfoAdded = true;
                        });

                        context.pushNamed(
                          'add_recipe_screen',
                          queryParameters: {
                            'userRef': serializeParam(
                              currentUserReference,
                              ParamType.DocumentReference,
                            ),
                            'mealRef': serializeParam(
                              _model.createdMealRecipeCollection?.reference,
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
                              onTap: () => _model.unfocusNode.canRequestFocus
                                  ? FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode)
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
                                      _model.doesPairedDataExists =
                                          await queryPairedUserRecordOnce(
                                        queryBuilder: (pairedUserRecord) =>
                                            pairedUserRecord.where(
                                          'recipient',
                                          isEqualTo: currentUserReference,
                                        ),
                                        singleRecord: true,
                                      ).then((s) => s.firstOrNull);
                                      if ((_model.doesPairedDataExists !=
                                              null) ==
                                          true) {
                                        setState(() {
                                          FFAppState().PartnerUID = _model
                                              .doesPairedDataExists?.sender;
                                        });

                                        context.pushNamed(
                                          'profile_screen',
                                          queryParameters: {
                                            'userDocRef': serializeParam(
                                              currentUserReference,
                                              ParamType.DocumentReference,
                                            ),
                                            'partnerRef': serializeParam(
                                              _model
                                                  .doesPairedDataExists?.sender,
                                              ParamType.DocumentReference,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 0),
                                            ),
                                          },
                                        );
                                      } else {
                                        context.pushNamed(
                                          'profile_screen',
                                          queryParameters: {
                                            'userDocRef': serializeParam(
                                              currentUserReference,
                                              ParamType.DocumentReference,
                                            ),
                                            'partnerRef': serializeParam(
                                              currentUserReference,
                                              ParamType.DocumentReference,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 0),
                                            ),
                                          },
                                        );
                                      }

                                      setState(() {});
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
                                          controller: _model
                                              .searchRecipeTextTextController,
                                          focusNode:
                                              _model.searchRecipeTextFocusNode,
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
                                          validator: _model
                                              .searchRecipeTextTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                      if (_model.searchRecipeTextTextController
                                              .text !=
                                          '')
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              _model
                                                  .searchRecipeTextTextController
                                                  ?.clear();
                                            });
                                            setState(() {
                                              FFAppState().isShowFullList =
                                                  true;
                                            });
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
                                          if (_model
                                                  .searchRecipeTextTextController
                                                  .text !=
                                              '') {
                                            await queryMealRecipeRecordOnce()
                                                .then(
                                                  (records) => _model
                                                          .simpleSearchResults =
                                                      TextSearch(
                                                    records
                                                        .map(
                                                          (record) =>
                                                              TextSearchItem
                                                                  .fromTerms(
                                                                      record, [
                                                            record.title!
                                                          ]),
                                                        )
                                                        .toList(),
                                                  )
                                                          .search(_model
                                                              .searchRecipeTextTextController
                                                              .text)
                                                          .map((r) => r.object)
                                                          .toList(),
                                                )
                                                .onError((_, __) => _model
                                                    .simpleSearchResults = [])
                                                .whenComplete(
                                                    () => setState(() {}));

                                            setState(() {
                                              FFAppState().isShowFullList =
                                                  false;
                                            });
                                          }
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
                        if (FFAppState().hasPartner == true)
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
                                    _model.rEFRESHPairedUserCollectionReceiver =
                                        await queryPairedUserRecordOnce(
                                      queryBuilder: (pairedUserRecord) =>
                                          pairedUserRecord.where(
                                        'recipient',
                                        isEqualTo: currentUserReference,
                                      ),
                                      singleRecord: true,
                                    ).then((s) => s.firstOrNull);
                                    setState(() {
                                      FFAppState().pairedUserCollection = _model
                                          .rEFRESHPairedUserCollectionReceiver
                                          ?.reference;
                                    });
                                    setState(() => _model
                                        .firestoreRequestCompleter = null);
                                    await _model
                                        .waitForFirestoreRequestCompleted(
                                            minWait: 500);
                                    if (animationsMap[
                                            'iconOnActionTriggerAnimation'] !=
                                        null) {
                                      animationsMap[
                                              'iconOnActionTriggerAnimation']!
                                          .controller
                                          .stop();
                                    }

                                    setState(() {});
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
                                  future: (_model.firestoreRequestCompleter ??=
                                          Completer<int>()
                                            ..complete(
                                                queryMealRequestedNotificationRecordCount(
                                              queryBuilder:
                                                  (mealRequestedNotificationRecord) =>
                                                      mealRequestedNotificationRecord
                                                          .where(
                                                            'paired_user_id',
                                                            isEqualTo: FFAppState()
                                                                .pairedUserCollection,
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
                                        if (FFAppState().hasPartner == true)
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
                                                notificationColumnCount != 0
                                                    ? true
                                                    : false,
                                            shape: badges.BadgeShape.circle,
                                            badgeColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                            elevation: 2.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 8.0, 8.0, 8.0),
                                            position:
                                                badges.BadgePosition.topEnd(),
                                            animationType:
                                                badges.BadgeAnimationType.scale,
                                            toAnimate: true,
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
                                                        FFAppState()
                                                            .pairedUserCollection,
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
                                    _model.expandableExpandableController,
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
                                      if (FFAppState()
                                              .tappedCategoryName
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
                                            FFAppState()
                                                .homeRecipeCategory
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
                                                        if (FFAppState()
                                                                .tappedCategoryName
                                                                .contains(
                                                                    recipeCategoriesListViewItem) ==
                                                            true) {
                                                          setState(() {
                                                            FFAppState()
                                                                .removeFromTappedCategoryName(
                                                                    recipeCategoriesListViewItem);
                                                          });
                                                          if (FFAppState()
                                                                  .tappedCategoryName
                                                                  .length ==
                                                              0) {
                                                            setState(() {
                                                              FFAppState()
                                                                      .isMealFilteredByCategory =
                                                                  false;
                                                              FFAppState()
                                                                  .tappedCategoryName = [];
                                                            });
                                                            if (_shouldSetState)
                                                              setState(() {});
                                                            return;
                                                          } else {
                                                            setState(() {
                                                              FFAppState()
                                                                      .isMealFilteredByCategory =
                                                                  true;
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            FFAppState()
                                                                .addToTappedCategoryName(
                                                                    recipeCategoriesListViewItem);
                                                            FFAppState()
                                                                    .isMealFilteredByCategory =
                                                                true;
                                                          });
                                                        }

                                                        _model.mealFilteredByCategory =
                                                            await queryMealRecipeRecordOnce(
                                                          queryBuilder: (mealRecipeRecord) =>
                                                              mealRecipeRecord
                                                                  .whereArrayContainsAny(
                                                                      'category',
                                                                      FFAppState()
                                                                          .tappedCategoryName)
                                                                  .where(
                                                                    'isPublic',
                                                                    isEqualTo:
                                                                        true,
                                                                  )
                                                                  .where(
                                                                    'isReady',
                                                                    isEqualTo:
                                                                        true,
                                                                  )
                                                                  .where(
                                                                    'admin_approved',
                                                                    isEqualTo:
                                                                        true,
                                                                  ),
                                                        );
                                                        _shouldSetState = true;
                                                      } else {
                                                        setState(() {
                                                          FFAppState()
                                                                  .isMealFilteredByCategory =
                                                              false;
                                                          FFAppState()
                                                              .tappedCategoryName = [];
                                                        });
                                                      }

                                                      if (_shouldSetState)
                                                        setState(() {});
                                                    },
                                                    child: Container(
                                                      height: 40.0,
                                                      decoration: BoxDecoration(
                                                        color: () {
                                                          if (FFAppState()
                                                                  .isMealFilteredByCategory ==
                                                              false) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .success;
                                                          } else if ((FFAppState()
                                                                      .isMealFilteredByCategory ==
                                                                  true) &&
                                                              (FFAppState()
                                                                      .tappedCategoryName
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
                              if (FFAppState().isShowFullList) {
                                return Builder(
                                  builder: (context) {
                                    if (FFAppState().isMealFilteredByCategory ==
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
                                                  stream: UsersRecord.getDocument(
                                                      theAllContentGridMealRecipeRecord
                                                          .author!),
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
                                                            if (FFAppState()
                                                                    .tempHideWidget ==
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
                                                                                theAllContentGridMealRecipeRecord.prepTime!),
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
                                                                              FFAppState().addToSavedRecipeList(theAllContentGridMealRecipeRecord.reference);
                                                                            });

                                                                            await homeSavedRecipeRecord!.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'saved_meal_recipe_id': FieldValue.arrayUnion([
                                                                                    theAllContentGridMealRecipeRecord.reference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
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
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.contains(
                                                                            theAllContentGridMealRecipeRecord.reference) ==
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
                                                                              FFAppState().removeFromSavedRecipeList(theAllContentGridMealRecipeRecord.reference);
                                                                            });

                                                                            await homeSavedRecipeRecord!.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'saved_meal_recipe_id': FieldValue.arrayRemove([
                                                                                    theAllContentGridMealRecipeRecord.reference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
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
                                          final filteredList = _model
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
                                                  stream:
                                                      UsersRecord.getDocument(
                                                          filteredListItem
                                                              .author!),
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
                                                            if (FFAppState()
                                                                    .tempHideWidget ==
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
                                                                                filteredListItem.prepTime!),
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
                                                                              FFAppState().addToSavedRecipeList(filteredListItem.reference);
                                                                            });

                                                                            await homeSavedRecipeRecord!.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'saved_meal_recipe_id': FieldValue.arrayUnion([
                                                                                    filteredListItem.reference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
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
                                                                if (homeSavedRecipeRecord
                                                                        ?.savedMealRecipeId
                                                                        ?.contains(
                                                                            filteredListItem.reference) ==
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
                                                                              FFAppState().removeFromSavedRecipeList(filteredListItem.reference);
                                                                            });

                                                                            await homeSavedRecipeRecord!.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'saved_meal_recipe_id': FieldValue.arrayRemove([
                                                                                    filteredListItem.reference
                                                                                  ]),
                                                                                },
                                                                              ),
                                                                            });
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
                                        _model.simpleSearchResults.toList();
                                    if (searchResult.isEmpty) {
                                      return NoSearchResultsComponentWidget(
                                        searchItemName: _model
                                            .searchRecipeTextTextController
                                            .text,
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
                                                  if (FFAppState()
                                                          .tempHideWidget ==
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
                                                              stream: UsersRecord
                                                                  .getDocument(
                                                                      searchResultItem
                                                                          .author!),
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
                                                                    searchResultItem
                                                                        .prepTime
                                                                        ?.toString(),
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
                                                                  await homeSavedRecipeRecord!
                                                                      .reference
                                                                      .update({
                                                                    ...mapToFirestore(
                                                                      {
                                                                        'saved_meal_recipe_id':
                                                                            FieldValue.arrayUnion([
                                                                          _model
                                                                              .simpleSearchResults[searchResultIndex]
                                                                              .reference
                                                                        ]),
                                                                      },
                                                                    ),
                                                                  });
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
                                                      if (homeSavedRecipeRecord
                                                              ?.savedMealRecipeId
                                                              ?.contains(
                                                                  searchResultItem
                                                                      .reference) ==
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
                                                                  await homeSavedRecipeRecord!
                                                                      .reference
                                                                      .update({
                                                                    ...mapToFirestore(
                                                                      {
                                                                        'saved_meal_recipe_id':
                                                                            FieldValue.arrayRemove([
                                                                          _model
                                                                              .simpleSearchResults[searchResultIndex]
                                                                              .reference
                                                                        ]),
                                                                      },
                                                                    ),
                                                                  });
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
