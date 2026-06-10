import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/duplicate_request_message/duplicate_request_message_widget.dart';
import '/pages/components/successfully_sent_component/successfully_sent_component_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Confirms whether the user wants to send a meal-prep request to their
/// paired partner. Creates the meal-requested-notification plus matching
/// receiver/sender notification docs, deduping pending/approved requests.
class ConfirmationAssignMealToPartnerScreenWidget extends StatelessWidget {
  const ConfirmationAssignMealToPartnerScreenWidget({
    super.key,
    required this.pairedUserRef,
    required this.mealRecipeRef,
  });

  final DocumentReference? pairedUserRef;
  final DocumentReference? mealRecipeRef;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: StreamBuilder<MealRecipeRecord>(
          stream: MealRecipeRecord.getDocument(mealRecipeRef!),
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
              constraints: const BoxConstraints(
                maxWidth: 570.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFFE0E3E7),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<PairedUserRecord>(
                  stream: PairedUserRecord.getDocument(pairedUserRef!),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
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
                          color:
                              FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
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
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).success,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final senderColumnUsersRecord = snapshot.data!;
                              return Column(
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
                                        final receiverBtnUsersRecord =
                                            snapshot.data!;
                                        return FFButtonWidget(
                                          onPressed: () async {
                                            final mealRequestNotificationCOUNT =
                                                await queryMealRequestedNotificationRecordCount(
                                              queryBuilder:
                                                  (mealRequestedNotificationRecord) =>
                                                      mealRequestedNotificationRecord
                                                          .where(
                                                'paired_user_id',
                                                isEqualTo: pairedUserRef,
                                              ),
                                            );
                                            if (mealRequestNotificationCOUNT ==
                                                0) {
                                              AppCubit.instance.setYesPleaseBtnPressed(true);

                                              var mealRequestedNotificationRecordReference1 =
                                                  MealRequestedNotificationRecord
                                                      .collection
                                                      .doc();
                                              await mealRequestedNotificationRecordReference1
                                                  .set({
                                                ...createMealRequestedNotificationRecordData(
                                                  pairedUserId: pairedUserRef,
                                                  requestedMealId:
                                                      mealRecipeRef,
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
                                                mealId: mealRecipeRef,
                                              ));
                                              final receiverNotificationCreation =
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
                                                            mealId:
                                                                mealRecipeRef,
                                                          ),
                                                          receiverNotificationRecordReference1);
                                              // Update UID of receiver-notification collection

                                              await receiverNotificationCreation
                                                  .reference
                                                  .update(
                                                      createReceiverNotificationRecordData(
                                                uidReceiver:
                                                    receiverNotificationCreation
                                                        .reference.id,
                                              ));
                                              // sender-notification-collection

                                              var senderNotificationRecordReference1 =
                                                  SenderNotificationRecord
                                                      .collection
                                                      .doc();
                                              await senderNotificationRecordReference1
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
                                                mealId: mealRecipeRef,
                                              ));
                                              final senderNotificationCreation =
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
                                                            mealId:
                                                                mealRecipeRef,
                                                          ),
                                                          senderNotificationRecordReference1);
                                              // Update UID of sender-notification collection

                                              await senderNotificationCreation
                                                  .reference
                                                  .update(
                                                      createSenderNotificationRecordData(
                                                uidSender:
                                                    senderNotificationCreation
                                                        .reference.id,
                                              ));
                                              AppCubit.instance.setYesPleaseBtnPressed(false);
                                              if (!context.mounted) return;
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
                                                        const AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality
                                                                    .of(context)),
                                                    child: const SizedBox(
                                                      height: 100.0,
                                                      width: 160.0,
                                                      child:
                                                          SuccessfullySentComponentWidget(),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              final mealRequestedNotificationPENDING =
                                                  await queryMealRequestedNotificationRecordOnce(
                                                queryBuilder:
                                                    (mealRequestedNotificationRecord) =>
                                                        mealRequestedNotificationRecord
                                                            .where(
                                                              'paired_user_id',
                                                              isEqualTo:
                                                                  pairedUserRef,
                                                            )
                                                            .where(
                                                              'content_status',
                                                              isEqualTo:
                                                                  'pending',
                                                            )
                                                            .where(
                                                              'requested_meal_id',
                                                              isEqualTo:
                                                                  mealRecipeRef,
                                                            ),
                                                singleRecord: true,
                                              ).then((s) => s.firstOrNull);
                                              if ((mealRequestedNotificationPENDING !=
                                                      null) ==
                                                  true) {
                                                if (!context.mounted) return;
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
                                                          const AlignmentDirectional(
                                                                  0.0, 0.0)
                                                              .resolve(
                                                                  Directionality
                                                                      .of(context)),
                                                      child: const SizedBox(
                                                        height: 120.0,
                                                        width: 300.0,
                                                        child:
                                                            DuplicateRequestMessageWidget(),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                final mealRequestedNotificationAPPROVED =
                                                    await queryMealRequestedNotificationRecordOnce(
                                                  queryBuilder:
                                                      (mealRequestedNotificationRecord) =>
                                                          mealRequestedNotificationRecord
                                                              .where(
                                                                'paired_user_id',
                                                                isEqualTo:
                                                                    pairedUserRef,
                                                              )
                                                              .where(
                                                                'content_status',
                                                                isEqualTo:
                                                                    'approved',
                                                              )
                                                              .where(
                                                                'requested_meal_id',
                                                                isEqualTo:
                                                                    mealRecipeRef,
                                                              ),
                                                  singleRecord: true,
                                                ).then((s) => s.firstOrNull);
                                                if ((mealRequestedNotificationAPPROVED !=
                                                        null) ==
                                                    true) {
                                                  if (!context.mounted) return;
                                                  Navigator.pop(context);
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (dialogContext) {
                                                      return Dialog(
                                                        elevation: 0,
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        alignment: const AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality
                                                                    .of(context)),
                                                        child: const SizedBox(
                                                          height: 120.0,
                                                          width: 300.0,
                                                          child:
                                                              DuplicateRequestMessageWidget(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  AppCubit.instance.setYesPleaseBtnPressed(true);

                                                  var mealRequestedNotificationRecordReference2 =
                                                      MealRequestedNotificationRecord
                                                          .collection
                                                          .doc();
                                                  await mealRequestedNotificationRecordReference2
                                                      .set({
                                                    ...createMealRequestedNotificationRecordData(
                                                      pairedUserId:
                                                          pairedUserRef,
                                                      requestedMealId:
                                                          mealRecipeRef,
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
                                                    mealId: mealRecipeRef,
                                                  ));
                                                  final receiverNotificationCreationITEM =
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
                                                                mealId:
                                                                    mealRecipeRef,
                                                              ),
                                                              receiverNotificationRecordReference2);
                                                  // Update UID of receiver-notification collection

                                                  await receiverNotificationCreationITEM
                                                      .reference
                                                      .update(
                                                          createReceiverNotificationRecordData(
                                                    uidReceiver:
                                                        receiverNotificationCreationITEM
                                                            .reference.id,
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
                                                    mealId: mealRecipeRef,
                                                  ));
                                                  final senderNotificationCreationITEM =
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
                                                                mealId:
                                                                    mealRecipeRef,
                                                              ),
                                                              senderNotificationRecordReference2);
                                                  // Update UID of sender-notification collection

                                                  await senderNotificationCreationITEM
                                                      .reference
                                                      .update(
                                                          createSenderNotificationRecordData(
                                                    uidSender:
                                                        senderNotificationCreationITEM
                                                            .reference.id,
                                                  ));
                                                  AppCubit.instance.setYesPleaseBtnPressed(false);
                                                  if (!context.mounted) return;
                                                  Navigator.pop(context);
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (dialogContext) {
                                                      return Dialog(
                                                        elevation: 0,
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        backgroundColor: Colors
                                                            .transparent,
                                                        alignment: const AlignmentDirectional(
                                                                0.0, 0.0)
                                                            .resolve(
                                                                Directionality
                                                                    .of(context)),
                                                        child: const SizedBox(
                                                          height: 100.0,
                                                          width: 160.0,
                                                          child:
                                                              SuccessfullySentComponentWidget(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          text: 'YES, PLEASE',
                                          options: FFButtonOptions(
                                            height: 40.0,
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(
                                                24.0, 0.0, 24.0, 0.0),
                                            iconPadding:
                                                const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .success,
                                                  fontSize: 12.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                            elevation: 0.0,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(0.0),
                                              bottomRight:
                                                  Radius.circular(0.0),
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
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
                                ].divide(const SizedBox(height: 8.0)),
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
