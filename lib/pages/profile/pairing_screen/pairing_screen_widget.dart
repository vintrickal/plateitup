import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pairing_screen_model.dart';
export 'pairing_screen_model.dart';

class PairingScreenWidget extends StatefulWidget {
  const PairingScreenWidget({
    super.key,
    required this.uniqueCode,
  });

  final String? uniqueCode;

  @override
  State<PairingScreenWidget> createState() => _PairingScreenWidgetState();
}

class _PairingScreenWidgetState extends State<PairingScreenWidget> {
  late PairingScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PairingScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.partnerStatusQuery = await queryPairedUserRecordOnce(
        queryBuilder: (pairedUserRecord) => pairedUserRecord.where(
          'recipient',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);
      if ((_model.partnerStatusQuery != null) == true) {
        setState(() {
          FFAppState().hasPartner = true;
        });
      } else {
        setState(() {
          FFAppState().hasPartner = false;
        });
      }
    });

    _model.partnerCodeTextfieldTextController ??= TextEditingController();
    _model.partnerCodeTextfieldFocusNode ??= FocusNode();

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

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 20.0,
                        borderWidth: 1.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).accent4,
                        icon: Icon(
                          Icons.close_outlined,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          setState(() {
                            _model.partnerCodeTextfieldTextController?.clear();
                          });
                          _model.establishedPartner =
                              await queryPairedUserRecordOnce(
                            queryBuilder: (pairedUserRecord) =>
                                pairedUserRecord.where(
                              'recipient',
                              isEqualTo: currentUserReference,
                            ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);
                          if ((_model.establishedPartner != null) == true) {
                            context.goNamed(
                              'profile_screen',
                              queryParameters: {
                                'userDocRef': serializeParam(
                                  currentUserReference,
                                  ParamType.DocumentReference,
                                ),
                                'partnerRef': serializeParam(
                                  _model.establishedPartner?.sender,
                                  ParamType.DocumentReference,
                                ),
                              }.withoutNulls,
                            );
                          } else {
                            context.safePop();
                          }

                          setState(() {});
                        },
                      ),
                    ),
                    Text(
                      'Partner Pairing',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Pair with your partner and let them know what meal do you want to be prepared for.',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 17.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'I want to invite my partner',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 16.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 8.0, 0.0),
                                                child: Text(
                                                  'My code: ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF55555C),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Text(
                                                valueOrDefault<String>(
                                                  widget.uniqueCode,
                                                  'unique-code',
                                                ),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 0.0, 0.0),
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
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Copied to Clipboard',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: widget
                                                                .uniqueCode!));
                                                  },
                                                  child: Icon(
                                                    Icons.content_copy,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                            .divide(SizedBox(height: 8.0))
                                            .addToStart(SizedBox(height: 8.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 135.0, 0.0, 0.0),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 180.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(),
                                                child: Text(
                                                  'I have my partner\'s code',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent4,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: TextFormField(
                                                            controller: _model
                                                                .partnerCodeTextfieldTextController,
                                                            focusNode: _model
                                                                .partnerCodeTextfieldFocusNode,
                                                            autofocus: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              hintText:
                                                                  'Enter Code',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedErrorBorder:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                            validator: _model
                                                                .partnerCodeTextfieldTextControllerValidator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        if (_model
                                                                .partnerCodeTextfieldTextController
                                                                .text !=
                                                            '') {
                                                          _model.partnerDetails =
                                                              await queryUsersRecordOnce(
                                                            queryBuilder:
                                                                (usersRecord) =>
                                                                    usersRecord
                                                                        .where(
                                                              'unique_code',
                                                              isEqualTo: _model
                                                                  .partnerCodeTextfieldTextController
                                                                  .text,
                                                            ),
                                                            singleRecord: true,
                                                          ).then((s) => s
                                                                  .firstOrNull);
                                                          if ((_model.partnerDetails !=
                                                                  null) ==
                                                              true) {
                                                            if (widget
                                                                    .uniqueCode ==
                                                                _model
                                                                    .partnerCodeTextfieldTextController
                                                                    .text) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'You can\'t do that',
                                                                    style:
                                                                        TextStyle(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                                  ),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          4000),
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondary,
                                                                ),
                                                              );
                                                            } else {
                                                              _model.partnerHasExistingPaired =
                                                                  await queryPairedUserRecordOnce(
                                                                queryBuilder:
                                                                    (pairedUserRecord) =>
                                                                        pairedUserRecord
                                                                            .where(
                                                                  'sender',
                                                                  isEqualTo: _model
                                                                      .partnerDetails
                                                                      ?.reference,
                                                                ),
                                                                singleRecord:
                                                                    true,
                                                              ).then((s) => s
                                                                      .firstOrNull);
                                                              if ((_model.partnerHasExistingPaired !=
                                                                      null) ==
                                                                  true) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'This person already has a partner.',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                  ),
                                                                );
                                                              } else {
                                                                var pairedUserRecordReference1 =
                                                                    PairedUserRecord
                                                                        .collection
                                                                        .doc();
                                                                await pairedUserRecordReference1
                                                                    .set(
                                                                        createPairedUserRecordData(
                                                                  recipient:
                                                                      currentUserReference,
                                                                  sender: _model
                                                                      .partnerDetails
                                                                      ?.reference,
                                                                  recipientName:
                                                                      currentUserDisplayName,
                                                                  senderName: _model
                                                                      .partnerDetails
                                                                      ?.displayName,
                                                                  recipientPhotoUrl:
                                                                      currentUserPhoto,
                                                                  senderPhotoUrl: _model
                                                                      .partnerDetails
                                                                      ?.photoUrl,
                                                                ));
                                                                _model.pairedUserDetails =
                                                                    PairedUserRecord
                                                                        .getDocumentFromData(
                                                                            createPairedUserRecordData(
                                                                              recipient: currentUserReference,
                                                                              sender: _model.partnerDetails?.reference,
                                                                              recipientName: currentUserDisplayName,
                                                                              senderName: _model.partnerDetails?.displayName,
                                                                              recipientPhotoUrl: currentUserPhoto,
                                                                              senderPhotoUrl: _model.partnerDetails?.photoUrl,
                                                                            ),
                                                                            pairedUserRecordReference1);

                                                                var pairedUserRecordReference2 =
                                                                    PairedUserRecord
                                                                        .collection
                                                                        .doc();
                                                                await pairedUserRecordReference2
                                                                    .set(
                                                                        createPairedUserRecordData(
                                                                  recipient: _model
                                                                      .partnerDetails
                                                                      ?.reference,
                                                                  sender:
                                                                      currentUserReference,
                                                                  recipientName: _model
                                                                      .partnerDetails
                                                                      ?.displayName,
                                                                  senderName:
                                                                      currentUserDisplayName,
                                                                  recipientPhotoUrl: _model
                                                                      .partnerDetails
                                                                      ?.photoUrl,
                                                                  senderPhotoUrl:
                                                                      currentUserPhoto,
                                                                ));
                                                                _model.pairedUserDetailsPartnerside =
                                                                    PairedUserRecord
                                                                        .getDocumentFromData(
                                                                            createPairedUserRecordData(
                                                                              recipient: _model.partnerDetails?.reference,
                                                                              sender: currentUserReference,
                                                                              recipientName: _model.partnerDetails?.displayName,
                                                                              senderName: currentUserDisplayName,
                                                                              recipientPhotoUrl: _model.partnerDetails?.photoUrl,
                                                                              senderPhotoUrl: currentUserPhoto,
                                                                            ),
                                                                            pairedUserRecordReference2);
                                                                setState(() {
                                                                  FFAppState()
                                                                          .hasPartner =
                                                                      true;
                                                                  FFAppState()
                                                                          .pairedUserCollection =
                                                                      _model
                                                                          .pairedUserDetails
                                                                          ?.reference;
                                                                });
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'You have successfully paired with ${_model.partnerDetails?.displayName}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                  ),
                                                                );

                                                                context.goNamed(
                                                                  'profile_screen',
                                                                  queryParameters:
                                                                      {
                                                                    'userDocRef':
                                                                        serializeParam(
                                                                      currentUserReference,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                    'partnerRef':
                                                                        serializeParam(
                                                                      _model
                                                                          .partnerDetails
                                                                          ?.reference,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              }
                                                            }
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Code does not exist.',
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        13.0,
                                                                  ),
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        4000),
                                                                backgroundColor:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondary,
                                                              ),
                                                            );
                                                          }
                                                        }

                                                        setState(() {});
                                                      },
                                                      text: 'Connect',
                                                      options: FFButtonOptions(
                                                        height: 50.0,
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    12.0,
                                                                    0.0),
                                                        iconPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .success,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                        elevation: 3.0,
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  0.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]
                                                .divide(SizedBox(height: 32.0))
                                                .addToStart(
                                                    SizedBox(height: 16.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 95.0, 0.0, 0.0),
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          width: 12.0,
                                        ),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          'or',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                letterSpacing: 0.0,
                                              ),
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
                  ].divide(SizedBox(height: 16.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
