import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/go_to_history_component/go_to_history_component_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'partner_rating_bottomsheet_component_model.dart';
export 'partner_rating_bottomsheet_component_model.dart';

class PartnerRatingBottomsheetComponentWidget extends StatefulWidget {
  const PartnerRatingBottomsheetComponentWidget({
    super.key,
    required this.pairedUserRef,
    required this.mealRecipeRef,
    required this.mealRequestedNotificationRef,
  });

  final DocumentReference? pairedUserRef;
  final DocumentReference? mealRecipeRef;
  final DocumentReference? mealRequestedNotificationRef;

  @override
  State<PartnerRatingBottomsheetComponentWidget> createState() =>
      _PartnerRatingBottomsheetComponentWidgetState();
}

class _PartnerRatingBottomsheetComponentWidgetState
    extends State<PartnerRatingBottomsheetComponentWidget> {
  late PartnerRatingBottomsheetComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => PartnerRatingBottomsheetComponentModel());

    _model.feedbackFormTextController ??= TextEditingController();
    _model.feedbackFormFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 370.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Container(
                      width: 50.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
                child: Text(
                  'How was your meal?',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
                child: Text(
                  'Let your partner know what you think',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RatingBar.builder(
                      onRatingUpdate: (newValue) =>
                          setState(() => _model.mealRatingStarValue = newValue),
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: FlutterFlowTheme.of(context).tertiary,
                      ),
                      direction: Axis.horizontal,
                      initialRating: _model.mealRatingStarValue ??= 0.0,
                      unratedColor: FlutterFlowTheme.of(context).accent3,
                      itemCount: 5,
                      itemSize: 32.0,
                      glowColor: FlutterFlowTheme.of(context).tertiary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: TextFormField(
                  controller: _model.feedbackFormTextController,
                  focusNode: _model.feedbackFormFocusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here...',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).success,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 32.0, 20.0, 12.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                      ),
                  textAlign: TextAlign.start,
                  maxLines: 4,
                  maxLength: 200,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.multiline,
                  validator: _model.feedbackFormTextControllerValidator
                      .asValidator(context),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(
                    builder: (context) => Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 44.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_model.mealRatingStarValue == 0.0) {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('0-Star'),
                                  content: Text(
                                      'You forgot to rate it with a star!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            if (_model.feedbackFormTextController.text == '') {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Empty Feedback Form'),
                                    content:
                                        Text('You forgot to leave a feedback!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              var partnerReviewRecordReference =
                                  PartnerReviewRecord.createDoc(
                                      widget.pairedUserRef!);
                              await partnerReviewRecordReference.set({
                                ...createPartnerReviewRecordData(
                                  pairedUserRef: widget.pairedUserRef,
                                  star: _model.mealRatingStarValue?.round(),
                                  description:
                                      _model.feedbackFormTextController.text,
                                  mealRecipeRef: widget.mealRecipeRef,
                                ),
                                ...mapToFirestore(
                                  {
                                    'date_created':
                                        FieldValue.serverTimestamp(),
                                  },
                                ),
                              });
                              _model.partnerReviewItemCreated =
                                  PartnerReviewRecord.getDocumentFromData({
                                ...createPartnerReviewRecordData(
                                  pairedUserRef: widget.pairedUserRef,
                                  star: _model.mealRatingStarValue?.round(),
                                  description:
                                      _model.feedbackFormTextController.text,
                                  mealRecipeRef: widget.mealRecipeRef,
                                ),
                                ...mapToFirestore(
                                  {
                                    'date_created': DateTime.now(),
                                  },
                                ),
                              }, partnerReviewRecordReference);

                              await widget.mealRequestedNotificationRef!.update(
                                  createMealRequestedNotificationRecordData(
                                reviewed: true,
                              ));
                              Navigator.pop(context);
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: GoToHistoryComponentWidget(
                                      pairedUserRef: widget.pairedUserRef!,
                                    ),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            }
                          }

                          setState(() {});
                        },
                        text: 'Submit',
                        options: FFButtonOptions(
                          width: 270.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).success,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
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
  }
}
