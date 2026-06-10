import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Confirmation dialog for unpairing from a partner. The Yes button cascades
/// through every Firestore collection tied to the two users (paired-user,
/// partner-review, meal-requested-notification, receiver/sender-notification)
/// and deletes their data before sending the user back to the profile screen.
class ConfirmationRemovePartnerComponentWidget extends StatelessWidget {
  const ConfirmationRemovePartnerComponentWidget({
    super.key,
    required this.displayName,
    required this.pairedUserRef,
    required this.partnerUserRef,
    required this.userDocRef,
  });

  final String? displayName;
  final DocumentReference? pairedUserRef;
  final DocumentReference? partnerUserRef;
  final DocumentReference? userDocRef;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: Container(
          width: 450.0,
          height: 220.0,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 12.0, 0.0),
                          child: Text(
                            'You want to remove $displayName as your partner?',
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.0,
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
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 16.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          AppCubit.instance.setYesImSureButtonPressed(true);
                          // Check if there's any data inside the collection "meal-requested-notification"
                          final userPairedDetails =
                              await queryPairedUserRecordOnce(
                            queryBuilder: (pairedUserRecord) =>
                                pairedUserRecord.where(
                              'sender',
                              isEqualTo: userDocRef,
                            ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          while (AppCubit.instance.state.mealRequestedCollectionEmpty ==
                              false) {
                            // Check if there's any data inside the collection "meal-requested-notification"
                            final uSERMealNotificationCount =
                                await queryMealRequestedNotificationRecordCount(
                              queryBuilder: (mealRequestedNotificationRecord) =>
                                  mealRequestedNotificationRecord.where(
                                'paired_user_id',
                                isEqualTo: userPairedDetails?.reference,
                              ),
                            );
                            if (uSERMealNotificationCount == 0) {
                              AppCubit.instance.setMealRequestedCollectionEmpty(true);
                            } else {
                              final mealNotificationItem =
                                  await queryMealRequestedNotificationRecordOnce(
                                queryBuilder:
                                    (mealRequestedNotificationRecord) =>
                                        mealRequestedNotificationRecord.where(
                                  'paired_user_id',
                                  isEqualTo: userPairedDetails?.reference,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await mealNotificationItem!.reference.delete();
                              AppCubit.instance.setMealRequestedCollectionEmpty(false);
                            }
                          }
                          final userPartnerReviewId =
                              await queryPartnerReviewRecordOnce(
                            parent: userPairedDetails?.reference,
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          await userPartnerReviewId!.reference.delete();
                          // Delete USER's Paired ID
                          await userPairedDetails!.reference.delete();
                          AppCubit.instance.setMealRequestedCollectionEmpty(false);
                          final partnerPairedDetails =
                              await queryPairedUserRecordOnce(
                            queryBuilder: (pairedUserRecord) =>
                                pairedUserRecord.where(
                              'sender',
                              isEqualTo: partnerUserRef,
                            ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          while (AppCubit.instance.state.mealRequestedCollectionEmpty ==
                              false) {
                            final pARTNERMealNotificationCount =
                                await queryMealRequestedNotificationRecordCount(
                              queryBuilder: (mealRequestedNotificationRecord) =>
                                  mealRequestedNotificationRecord.where(
                                'paired_user_id',
                                isEqualTo: partnerPairedDetails?.reference,
                              ),
                            );
                            if (pARTNERMealNotificationCount == 0) {
                              AppCubit.instance.setMealRequestedCollectionEmpty(true);
                            } else {
                              final partnerMealNotificationItem =
                                  await queryMealRequestedNotificationRecordOnce(
                                queryBuilder:
                                    (mealRequestedNotificationRecord) =>
                                        mealRequestedNotificationRecord.where(
                                  'paired_user_id',
                                  isEqualTo: partnerPairedDetails?.reference,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await partnerMealNotificationItem!.reference
                                  .delete();
                              AppCubit.instance.setMealRequestedCollectionEmpty(false);
                            }
                          }
                          final partnerPartnerReviewId =
                              await queryPartnerReviewRecordOnce(
                            parent: partnerPairedDetails?.reference,
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          await partnerPartnerReviewId!.reference.delete();
                          await partnerPairedDetails!.reference.delete();
                          while (AppCubit.instance.state.noMoreNotification == false) {
                            // Reciever-Notificaton for USER
                            final uSERReceiverNotificationCOUNT =
                                await queryReceiverNotificationRecordCount(
                              queryBuilder: (receiverNotificationRecord) =>
                                  receiverNotificationRecord.where(
                                'user_id',
                                isEqualTo: userDocRef,
                              ),
                            );
                            if (uSERReceiverNotificationCOUNT == 0) {
                              AppCubit.instance.setNoMoreNotification(true);
                            } else {
                              final uSERReceiverNotificationItem =
                                  await queryReceiverNotificationRecordOnce(
                                queryBuilder: (receiverNotificationRecord) =>
                                    receiverNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: userDocRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await uSERReceiverNotificationItem!.reference
                                  .delete();
                              AppCubit.instance.setNoMoreNotification(false);
                            }
                          }
                          AppCubit.instance.setNoMoreNotification(false);
                          while (AppCubit.instance.state.noMoreNotification == false) {
                            final uSERSenderNotificationCOUNT =
                                await querySenderNotificationRecordCount(
                              queryBuilder: (senderNotificationRecord) =>
                                  senderNotificationRecord.where(
                                'user_id',
                                isEqualTo: userDocRef,
                              ),
                            );
                            if (uSERSenderNotificationCOUNT == 0) {
                              AppCubit.instance.setNoMoreNotification(true);
                            } else {
                              final uSERSenderNotificationItem =
                                  await querySenderNotificationRecordOnce(
                                queryBuilder: (senderNotificationRecord) =>
                                    senderNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: userDocRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await uSERSenderNotificationItem!.reference
                                  .delete();
                              AppCubit.instance.setNoMoreNotification(false);
                            }
                          }
                          AppCubit.instance.setNoMoreNotification(false);
                          while (AppCubit.instance.state.noMoreNotification == false) {
                            final pARTNERReceiverNotificationCOUNT =
                                await queryReceiverNotificationRecordCount(
                              queryBuilder: (receiverNotificationRecord) =>
                                  receiverNotificationRecord.where(
                                'user_id',
                                isEqualTo: partnerUserRef,
                              ),
                            );
                            if (pARTNERReceiverNotificationCOUNT == 0) {
                              AppCubit.instance.setNoMoreNotification(true);
                            } else {
                              final pARTNERReceiverNotificationItem =
                                  await queryReceiverNotificationRecordOnce(
                                queryBuilder: (receiverNotificationRecord) =>
                                    receiverNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: partnerUserRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await pARTNERReceiverNotificationItem!.reference
                                  .delete();
                              AppCubit.instance.setNoMoreNotification(false);
                            }
                          }
                          AppCubit.instance.setNoMoreNotification(false);
                          while (AppCubit.instance.state.noMoreNotification == false) {
                            final pARTNERSenderNotificationCOUNT =
                                await querySenderNotificationRecordCount(
                              queryBuilder: (senderNotificationRecord) =>
                                  senderNotificationRecord.where(
                                'user_id',
                                isEqualTo: partnerUserRef,
                              ),
                            );
                            if (pARTNERSenderNotificationCOUNT == 0) {
                              AppCubit.instance.setNoMoreNotification(true);
                            } else {
                              final pARTNERSenderNotificationItem =
                                  await querySenderNotificationRecordOnce(
                                queryBuilder: (senderNotificationRecord) =>
                                    senderNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: partnerUserRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await pARTNERSenderNotificationItem!.reference
                                  .delete();
                              AppCubit.instance.setNoMoreNotification(false);
                            }
                          }
                          AppCubit.instance.setNoMoreNotification(false);
                          AppCubit.instance.setHasPartner(false);
                          AppCubit.instance.setMealRequestedCollectionEmpty(false);
                          AppCubit.instance.setYesImSureButtonPressed(false);
                          if (!context.mounted) return;
                          Navigator.pop(context);

                          context.goNamed(
                            'profile_screen',
                            queryParameters: {
                              'userDocRef': serializeParam(
                                userDocRef,
                                ParamType.DocumentReference,
                              ),
                              'partnerRef': serializeParam(
                                userDocRef,
                                ParamType.DocumentReference,
                              ),
                            }.withoutNulls,
                          );
                        },
                        text: 'YES, I\'M SURE',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).success,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                          elevation: 0.0,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                            topLeft: Radius.circular(0.0),
                            topRight: Radius.circular(0.0),
                          ),
                          hoverColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          hoverTextColor:
                              FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        text: 'NO, I CHANGE MY MIND',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(0.0),
                          hoverColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          hoverTextColor:
                              FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ].divide(const SizedBox(height: 8.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
