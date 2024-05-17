import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/duplicate_request_message/duplicate_request_message_widget.dart';
import '/pages/components/successfully_sent_component/successfully_sent_component_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirmation_assign_meal_to_partner_screen_model.dart';
export 'confirmation_assign_meal_to_partner_screen_model.dart';

class ConfirmationAssignMealToPartnerScreenWidget extends StatefulWidget {
  const ConfirmationAssignMealToPartnerScreenWidget({
    super.key,
    required this.pairedUserRef,
    required this.mealRecipeRef,
  });

  final DocumentReference? pairedUserRef;
  final DocumentReference? mealRecipeRef;

  @override
  State<ConfirmationAssignMealToPartnerScreenWidget> createState() =>
      _ConfirmationAssignMealToPartnerScreenWidgetState();
}

class _ConfirmationAssignMealToPartnerScreenWidgetState
    extends State<ConfirmationAssignMealToPartnerScreenWidget> {
  late ConfirmationAssignMealToPartnerScreenModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => ConfirmationAssignMealToPartnerScreenModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: StreamBuilder<MealRecipeRecord>(
          stream: MealRecipeRecord.getDocument(widget.mealRecipeRef!),
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
            final mealRecipeContainerMealRecipeRecord = snapshot.data!;
            return Container(
              width: 450.0,
              height: 240.0,
              constraints: BoxConstraints(
                maxWidth: 570.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Color(0xFFE0E3E7),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: StreamBuilder<PairedUserRecord>(
                  stream: PairedUserRecord.getDocument(widget.pairedUserRef!),
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
                    final pairedUserColumnPairedUserRecord = snapshot.data!;
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 0.0),
                                  child: Text(
                                    'You want this meal to be prepared by your partner?',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 18.0,
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: StreamBuilder<UsersRecord>(
                            stream: UsersRecord.getDocument(
                                pairedUserColumnPairedUserRecord.sender!),
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
                              final senderColumnUsersRecord = snapshot.data!;
                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Builder(
                                    builder: (context) =>
                                        StreamBuilder<UsersRecord>(
                                      stream: UsersRecord.getDocument(
                                          pairedUserColumnPairedUserRecord
                                              .recipient!),
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
                                        final receiverBtnUsersRecord =
                                            snapshot.data!;
                                        return FFButtonWidget(
                                          onPressed: () async {
                                            _model.mealRequestNotificationCOUNT =
                                                await queryMealRequestedNotificationRecordCount(
                                              queryBuilder:
                                                  (mealRequestedNotificationRecord) =>
                                                      mealRequestedNotificationRecord
                                                          .where(
                                                'paired_user_id',
                                                isEqualTo: widget.pairedUserRef,
                                              ),
                                            );
                                            if (_model
                                                    .mealRequestNotificationCOUNT ==
                                                0) {
                                              setState(() {
                                                FFAppState()
                                                    .yesPleaseBtnPressed = true;
                                              });

                                              var mealRequestedNotificationRecordReference1 =
                                                  MealRequestedNotificationRecord
                                                      .collection
                                                      .doc();
                                              await mealRequestedNotificationRecordReference1
                                                  .set({
                                                ...createMealRequestedNotificationRecordData(
                                                  pairedUserId:
                                                      widget.pairedUserRef,
                                                  requestedMealId:
                                                      widget.mealRecipeRef,
                                                  contentWasTapped: false,
                                                  contentStatus: 'pending',
                                                  reviewed: false,
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'date_requested': FieldValue
                                                        .serverTimestamp(),
                                                    'date_action_taken':
                                                        FieldValue
                                                            .serverTimestamp(),
                                                  },
                                                ),
                                              });
                                              _model.createdRequest =
                                                  MealRequestedNotificationRecord
                                                      .getDocumentFromData({
                                                ...createMealRequestedNotificationRecordData(
                                                  pairedUserId:
                                                      widget.pairedUserRef,
                                                  requestedMealId:
                                                      widget.mealRecipeRef,
                                                  contentWasTapped: false,
                                                  contentStatus: 'pending',
                                                  reviewed: false,
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'date_requested':
                                                        DateTime.now(),
                                                    'date_action_taken':
                                                        DateTime.now(),
                                                  },
                                                ),
                                              }, mealRequestedNotificationRecordReference1);
                                              // receiver-notification-collection

                                              var receiverNotificationRecordReference1 =
                                                  ReceiverNotificationRecord
                                                      .collection
                                                      .doc();
                                              await receiverNotificationRecordReference1
                                                  .set(
                                                      createReceiverNotificationRecordData(
                                                userId: receiverBtnUsersRecord
                                                    .reference,
                                                isShownToUser: false,
                                                mealTitle:
                                                    mealRecipeContainerMealRecipeRecord
                                                        .title,
                                                mealStatusMessage:
                                                    '${senderColumnUsersRecord.displayName} has requested to have this meal prepared',
                                                mealId: widget.mealRecipeRef,
                                              ));
                                              _model.receiverNotificationCreation =
                                                  ReceiverNotificationRecord
                                                      .getDocumentFromData(
                                                          createReceiverNotificationRecordData(
                                                            userId:
                                                                receiverBtnUsersRecord
                                                                    .reference,
                                                            isShownToUser:
                                                                false,
                                                            mealTitle:
                                                                mealRecipeContainerMealRecipeRecord
                                                                    .title,
                                                            mealStatusMessage:
                                                                '${senderColumnUsersRecord.displayName} has requested to have this meal prepared',
                                                            mealId: widget
                                                                .mealRecipeRef,
                                                          ),
                                                          receiverNotificationRecordReference1);
                                              // Update UID of receiver-notification collection

                                              await _model
                                                  .receiverNotificationCreation!
                                                  .reference
                                                  .update(
                                                      createReceiverNotificationRecordData(
                                                uidReceiver: _model
                                                    .receiverNotificationCreation
                                                    ?.reference
                                                    .id,
                                              ));
                                              // sender-notification-collection

                                              var senderNotificationRecordReference1 =
                                                  SenderNotificationRecord
                                                      .collection
                                                      .doc();
                                              await senderNotificationRecordReference1
                                                  .set(
                                                      createSenderNotificationRecordData(
                                                userId: senderColumnUsersRecord
                                                    .reference,
                                                isShownToUser: true,
                                                mealTitle:
                                                    mealRecipeContainerMealRecipeRecord
                                                        .title,
                                                mealStatusMessage: ' ',
                                                mealId: widget.mealRecipeRef,
                                              ));
                                              _model.senderNotificationCreation =
                                                  SenderNotificationRecord
                                                      .getDocumentFromData(
                                                          createSenderNotificationRecordData(
                                                            userId:
                                                                senderColumnUsersRecord
                                                                    .reference,
                                                            isShownToUser: true,
                                                            mealTitle:
                                                                mealRecipeContainerMealRecipeRecord
                                                                    .title,
                                                            mealStatusMessage:
                                                                ' ',
                                                            mealId: widget
                                                                .mealRecipeRef,
                                                          ),
                                                          senderNotificationRecordReference1);
                                              // Update UID of sender-notification collection

                                              await _model
                                                  .senderNotificationCreation!
                                                  .reference
                                                  .update(
                                                      createSenderNotificationRecordData(
                                                uidSender: _model
                                                    .senderNotificationCreation
                                                    ?.reference
                                                    .id,
                                              ));
                                              setState(() {
                                                FFAppState()
                                                        .yesPleaseBtnPressed =
                                                    false;
                                              });
                                              Navigator.pop(context);
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
                                                    child: Container(
                                                      height: 100.0,
                                                      width: 160.0,
                                                      child:
                                                          SuccessfullySentComponentWidget(),
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                  (value) => setState(() {}));
                                            } else {
                                              _model.mealRequestedNotificationPENDING =
                                                  await queryMealRequestedNotificationRecordOnce(
                                                queryBuilder:
                                                    (mealRequestedNotificationRecord) =>
                                                        mealRequestedNotificationRecord
                                                            .where(
                                                              'paired_user_id',
                                                              isEqualTo: widget
                                                                  .pairedUserRef,
                                                            )
                                                            .where(
                                                              'content_status',
                                                              isEqualTo:
                                                                  'pending',
                                                            )
                                                            .where(
                                                              'requested_meal_id',
                                                              isEqualTo: widget
                                                                  .mealRecipeRef,
                                                            ),
                                                singleRecord: true,
                                              ).then((s) => s.firstOrNull);
                                              if ((_model.mealRequestedNotificationPENDING !=
                                                      null) ==
                                                  true) {
                                                Navigator.pop(context);
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
                                                      child: Container(
                                                        height: 120.0,
                                                        width: 300.0,
                                                        child:
                                                            DuplicateRequestMessageWidget(),
                                                      ),
                                                    );
                                                  },
                                                ).then(
                                                    (value) => setState(() {}));
                                              } else {
                                                _model.mealRequestedNotificationAPPROVED =
                                                    await queryMealRequestedNotificationRecordOnce(
                                                  queryBuilder:
                                                      (mealRequestedNotificationRecord) =>
                                                          mealRequestedNotificationRecord
                                                              .where(
                                                                'paired_user_id',
                                                                isEqualTo: widget
                                                                    .pairedUserRef,
                                                              )
                                                              .where(
                                                                'content_status',
                                                                isEqualTo:
                                                                    'approved',
                                                              )
                                                              .where(
                                                                'requested_meal_id',
                                                                isEqualTo: widget
                                                                    .mealRecipeRef,
                                                              ),
                                                  singleRecord: true,
                                                ).then((s) => s.firstOrNull);
                                                if ((_model.mealRequestedNotificationAPPROVED !=
                                                        null) ==
                                                    true) {
                                                  Navigator.pop(context);
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
                                                        child: Container(
                                                          height: 120.0,
                                                          width: 300.0,
                                                          child:
                                                              DuplicateRequestMessageWidget(),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      setState(() {}));
                                                } else {
                                                  setState(() {
                                                    FFAppState()
                                                            .yesPleaseBtnPressed =
                                                        true;
                                                  });

                                                  var mealRequestedNotificationRecordReference2 =
                                                      MealRequestedNotificationRecord
                                                          .collection
                                                          .doc();
                                                  await mealRequestedNotificationRecordReference2
                                                      .set({
                                                    ...createMealRequestedNotificationRecordData(
                                                      pairedUserId:
                                                          widget.pairedUserRef,
                                                      requestedMealId:
                                                          widget.mealRecipeRef,
                                                      contentWasTapped: false,
                                                      contentStatus: 'pending',
                                                      reviewed: false,
                                                    ),
                                                    ...mapToFirestore(
                                                      {
                                                        'date_requested':
                                                            FieldValue
                                                                .serverTimestamp(),
                                                        'date_action_taken':
                                                            FieldValue
                                                                .serverTimestamp(),
                                                      },
                                                    ),
                                                  });
                                                  _model.createdRequestChecker =
                                                      MealRequestedNotificationRecord
                                                          .getDocumentFromData({
                                                    ...createMealRequestedNotificationRecordData(
                                                      pairedUserId:
                                                          widget.pairedUserRef,
                                                      requestedMealId:
                                                          widget.mealRecipeRef,
                                                      contentWasTapped: false,
                                                      contentStatus: 'pending',
                                                      reviewed: false,
                                                    ),
                                                    ...mapToFirestore(
                                                      {
                                                        'date_requested':
                                                            DateTime.now(),
                                                        'date_action_taken':
                                                            DateTime.now(),
                                                      },
                                                    ),
                                                  }, mealRequestedNotificationRecordReference2);
                                                  // receiver-notification-collection

                                                  var receiverNotificationRecordReference2 =
                                                      ReceiverNotificationRecord
                                                          .collection
                                                          .doc();
                                                  await receiverNotificationRecordReference2
                                                      .set(
                                                          createReceiverNotificationRecordData(
                                                    userId:
                                                        receiverBtnUsersRecord
                                                            .reference,
                                                    isShownToUser: false,
                                                    mealTitle:
                                                        mealRecipeContainerMealRecipeRecord
                                                            .title,
                                                    mealStatusMessage:
                                                        '${senderColumnUsersRecord.displayName} has requested to have this meal prepared',
                                                    mealId:
                                                        widget.mealRecipeRef,
                                                  ));
                                                  _model.receiverNotificationCreationITEM =
                                                      ReceiverNotificationRecord
                                                          .getDocumentFromData(
                                                              createReceiverNotificationRecordData(
                                                                userId:
                                                                    receiverBtnUsersRecord
                                                                        .reference,
                                                                isShownToUser:
                                                                    false,
                                                                mealTitle:
                                                                    mealRecipeContainerMealRecipeRecord
                                                                        .title,
                                                                mealStatusMessage:
                                                                    '${senderColumnUsersRecord.displayName} has requested to have this meal prepared',
                                                                mealId: widget
                                                                    .mealRecipeRef,
                                                              ),
                                                              receiverNotificationRecordReference2);
                                                  // Update UID of receiver-notification collection

                                                  await _model
                                                      .receiverNotificationCreationITEM!
                                                      .reference
                                                      .update(
                                                          createReceiverNotificationRecordData(
                                                    uidReceiver: _model
                                                        .receiverNotificationCreationITEM
                                                        ?.reference
                                                        .id,
                                                  ));
                                                  // sender-notification-collection

                                                  var senderNotificationRecordReference2 =
                                                      SenderNotificationRecord
                                                          .collection
                                                          .doc();
                                                  await senderNotificationRecordReference2
                                                      .set(
                                                          createSenderNotificationRecordData(
                                                    userId:
                                                        senderColumnUsersRecord
                                                            .reference,
                                                    isShownToUser: true,
                                                    mealTitle:
                                                        mealRecipeContainerMealRecipeRecord
                                                            .title,
                                                    mealStatusMessage: ' ',
                                                    mealId:
                                                        widget.mealRecipeRef,
                                                  ));
                                                  _model.senderNotificationCreationITEM =
                                                      SenderNotificationRecord
                                                          .getDocumentFromData(
                                                              createSenderNotificationRecordData(
                                                                userId:
                                                                    senderColumnUsersRecord
                                                                        .reference,
                                                                isShownToUser:
                                                                    true,
                                                                mealTitle:
                                                                    mealRecipeContainerMealRecipeRecord
                                                                        .title,
                                                                mealStatusMessage:
                                                                    ' ',
                                                                mealId: widget
                                                                    .mealRecipeRef,
                                                              ),
                                                              senderNotificationRecordReference2);
                                                  // Update UID of sender-notification collection

                                                  await _model
                                                      .senderNotificationCreationITEM!
                                                      .reference
                                                      .update(
                                                          createSenderNotificationRecordData(
                                                    uidSender: _model
                                                        .senderNotificationCreationITEM
                                                        ?.reference
                                                        .id,
                                                  ));
                                                  setState(() {
                                                    FFAppState()
                                                            .yesPleaseBtnPressed =
                                                        false;
                                                  });
                                                  Navigator.pop(context);
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
                                                        child: Container(
                                                          height: 100.0,
                                                          width: 160.0,
                                                          child:
                                                              SuccessfullySentComponentWidget(),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      setState(() {}));
                                                }
                                              }
                                            }

                                            setState(() {});
                                          },
                                          text: 'YES, PLEASE',
                                          options: FFButtonOptions(
                                            height: 40.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .success,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            elevation: 0.0,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                            ),
                                            hoverColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            hoverTextColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    text: 'NO, I CHANGE MY MIND',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(0.0),
                                      hoverColor: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      hoverTextColor:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
