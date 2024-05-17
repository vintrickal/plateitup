import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirmation_remove_partner_component_model.dart';
export 'confirmation_remove_partner_component_model.dart';

class ConfirmationRemovePartnerComponentWidget extends StatefulWidget {
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
  State<ConfirmationRemovePartnerComponentWidget> createState() =>
      _ConfirmationRemovePartnerComponentWidgetState();
}

class _ConfirmationRemovePartnerComponentWidgetState
    extends State<ConfirmationRemovePartnerComponentWidget> {
  late ConfirmationRemovePartnerComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => ConfirmationRemovePartnerComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: Container(
          width: 450.0,
          height: 220.0,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 12.0, 0.0),
                            child: Text(
                              'You want to remove ${widget.displayName} as your partner?',
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            FFAppState().yesImSureButtonPressed = true;
                          });
                          // Check if there's any data inside the collection "meal-requested-notification"
                          _model.userPairedDetails =
                              await queryPairedUserRecordOnce(
                            queryBuilder: (pairedUserRecord) =>
                                pairedUserRecord.where(
                              'sender',
                              isEqualTo: widget.userDocRef,
                            ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          while (FFAppState().mealRequestedCollectionEmpty ==
                              false) {
                            // Check if there's any data inside the collection "meal-requested-notification"
                            _model.uSERMealNotificationCount =
                                await queryMealRequestedNotificationRecordCount(
                              queryBuilder: (mealRequestedNotificationRecord) =>
                                  mealRequestedNotificationRecord.where(
                                'paired_user_id',
                                isEqualTo: _model.userPairedDetails?.reference,
                              ),
                            );
                            if (_model.uSERMealNotificationCount == 0) {
                              setState(() {
                                FFAppState().mealRequestedCollectionEmpty =
                                    true;
                              });
                            } else {
                              _model.mealNotificationItem =
                                  await queryMealRequestedNotificationRecordOnce(
                                queryBuilder:
                                    (mealRequestedNotificationRecord) =>
                                        mealRequestedNotificationRecord.where(
                                  'paired_user_id',
                                  isEqualTo:
                                      _model.userPairedDetails?.reference,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model.mealNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().mealRequestedCollectionEmpty =
                                    false;
                              });
                            }
                          }
                          // Delete USER's Paired ID
                          await _model.userPairedDetails!.reference.delete();
                          setState(() {
                            FFAppState().mealRequestedCollectionEmpty = false;
                          });
                          _model.partnerPairedDetails =
                              await queryPairedUserRecordOnce(
                            queryBuilder: (pairedUserRecord) =>
                                pairedUserRecord.where(
                              'sender',
                              isEqualTo: widget.partnerUserRef,
                            ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          while (FFAppState().mealRequestedCollectionEmpty ==
                              false) {
                            _model.pARTNERMealNotificationCount =
                                await queryMealRequestedNotificationRecordCount(
                              queryBuilder: (mealRequestedNotificationRecord) =>
                                  mealRequestedNotificationRecord.where(
                                'paired_user_id',
                                isEqualTo:
                                    _model.partnerPairedDetails?.reference,
                              ),
                            );
                            if (_model.pARTNERMealNotificationCount == 0) {
                              setState(() {
                                FFAppState().mealRequestedCollectionEmpty =
                                    true;
                              });
                            } else {
                              _model.partnerMealNotificationItem =
                                  await queryMealRequestedNotificationRecordOnce(
                                queryBuilder:
                                    (mealRequestedNotificationRecord) =>
                                        mealRequestedNotificationRecord.where(
                                  'paired_user_id',
                                  isEqualTo:
                                      _model.partnerPairedDetails?.reference,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model
                                  .partnerMealNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().mealRequestedCollectionEmpty =
                                    false;
                              });
                            }
                          }
                          await _model.partnerPairedDetails!.reference.delete();
                          while (FFAppState().noMoreNotification == false) {
                            // Reciever-Notificaton for USER
                            _model.uSERReceiverNotificationCOUNT =
                                await queryReceiverNotificationRecordCount(
                              queryBuilder: (receiverNotificationRecord) =>
                                  receiverNotificationRecord.where(
                                'user_id',
                                isEqualTo: widget.userDocRef,
                              ),
                            );
                            if (_model.uSERReceiverNotificationCOUNT == 0) {
                              setState(() {
                                FFAppState().noMoreNotification = true;
                              });
                            } else {
                              _model.uSERReceiverNotificationItem =
                                  await queryReceiverNotificationRecordOnce(
                                queryBuilder: (receiverNotificationRecord) =>
                                    receiverNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: widget.userDocRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model
                                  .uSERReceiverNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().noMoreNotification = false;
                              });
                            }
                          }
                          setState(() {
                            FFAppState().noMoreNotification = false;
                          });
                          while (FFAppState().noMoreNotification == false) {
                            _model.uSERSenderNotificationCOUNT =
                                await querySenderNotificationRecordCount(
                              queryBuilder: (senderNotificationRecord) =>
                                  senderNotificationRecord.where(
                                'user_id',
                                isEqualTo: widget.userDocRef,
                              ),
                            );
                            if (_model.uSERSenderNotificationCOUNT == 0) {
                              setState(() {
                                FFAppState().noMoreNotification = true;
                              });
                            } else {
                              _model.uSERSenderNotificationItem =
                                  await querySenderNotificationRecordOnce(
                                queryBuilder: (senderNotificationRecord) =>
                                    senderNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: widget.userDocRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model.uSERSenderNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().noMoreNotification = false;
                              });
                            }
                          }
                          setState(() {
                            FFAppState().noMoreNotification = false;
                          });
                          while (FFAppState().noMoreNotification == false) {
                            _model.pARTNERReceiverNotificationCOUNT =
                                await queryReceiverNotificationRecordCount(
                              queryBuilder: (receiverNotificationRecord) =>
                                  receiverNotificationRecord.where(
                                'user_id',
                                isEqualTo: widget.partnerUserRef,
                              ),
                            );
                            if (_model.pARTNERReceiverNotificationCOUNT == 0) {
                              setState(() {
                                FFAppState().noMoreNotification = true;
                              });
                            } else {
                              _model.pARTNERReceiverNotificationItem =
                                  await queryReceiverNotificationRecordOnce(
                                queryBuilder: (receiverNotificationRecord) =>
                                    receiverNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: widget.partnerUserRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model
                                  .pARTNERReceiverNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().noMoreNotification = false;
                              });
                            }
                          }
                          setState(() {
                            FFAppState().noMoreNotification = false;
                          });
                          while (FFAppState().noMoreNotification == false) {
                            _model.pARTNERSenderNotificationCOUNT =
                                await querySenderNotificationRecordCount(
                              queryBuilder: (senderNotificationRecord) =>
                                  senderNotificationRecord.where(
                                'user_id',
                                isEqualTo: widget.partnerUserRef,
                              ),
                            );
                            if (_model.pARTNERSenderNotificationCOUNT == 0) {
                              setState(() {
                                FFAppState().noMoreNotification = true;
                              });
                            } else {
                              _model.pARTNERSenderNotificationItem =
                                  await querySenderNotificationRecordOnce(
                                queryBuilder: (senderNotificationRecord) =>
                                    senderNotificationRecord.where(
                                  'user_id',
                                  isEqualTo: widget.partnerUserRef,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              await _model
                                  .pARTNERSenderNotificationItem!.reference
                                  .delete();
                              setState(() {
                                FFAppState().noMoreNotification = false;
                              });
                            }
                          }
                          setState(() {
                            FFAppState().noMoreNotification = false;
                          });
                          setState(() {
                            FFAppState().hasPartner = false;
                            FFAppState().mealRequestedCollectionEmpty = false;
                            FFAppState().yesImSureButtonPressed = false;
                          });
                          Navigator.pop(context);

                          context.goNamed(
                            'profile_screen',
                            queryParameters: {
                              'userDocRef': serializeParam(
                                widget.userDocRef,
                                ParamType.DocumentReference,
                              ),
                              'partnerRef': serializeParam(
                                widget.userDocRef,
                                ParamType.DocumentReference,
                              ),
                            }.withoutNulls,
                          );

                          setState(() {});
                        },
                        text: 'YES, I\'M SURE',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
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
                          borderRadius: BorderRadius.only(
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
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
                    ].divide(SizedBox(height: 8.0)),
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
