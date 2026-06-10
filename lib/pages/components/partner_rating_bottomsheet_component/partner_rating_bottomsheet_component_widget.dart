import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/go_to_history_component/go_to_history_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Bottom-sheet that lets a user rate a meal cooked by their partner and
/// leave feedback, writing a new PartnerReviewRecord and marking the
/// associated notification as reviewed on submit.
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
  double? _starValue;
  final TextEditingController _feedbackController = TextEditingController();
  final FocusNode _feedbackFocus = FocusNode();

  @override
  void dispose() {
    _feedbackController.dispose();
    _feedbackFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: const RoundedRectangleBorder(
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
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 12.0, 0.0, 0.0),
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
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
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
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 12.0, 16.0, 0.0),
                child: Row(
                  children: [
                    RatingBar.builder(
                      onRatingUpdate: (newValue) =>
                          setState(() => _starValue = newValue),
                      itemBuilder: (context, index) => Icon(
                        Icons.star_rounded,
                        color: FlutterFlowTheme.of(context).tertiary,
                      ),
                      direction: Axis.horizontal,
                      initialRating: _starValue ?? 0.0,
                      unratedColor: FlutterFlowTheme.of(context).accent3,
                      itemCount: 5,
                      itemSize: 32.0,
                      glowColor: FlutterFlowTheme.of(context).tertiary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 16.0, 16.0, 0.0),
                child: TextFormField(
                  controller: _feedbackController,
                  focusNode: _feedbackFocus,
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
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        20.0, 32.0, 20.0, 12.0),
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(
                    builder: (context) => Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 24.0, 0.0, 44.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_starValue == null || _starValue == 0.0) {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: const Text('0-Star'),
                                  content: const Text(
                                      'You forgot to rate it with a star!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            if (_feedbackController.text == '') {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: const Text('Empty Feedback Form'),
                                    content: const Text(
                                        'You forgot to leave a feedback!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: const Text('Ok'),
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
                                  star: _starValue?.round(),
                                  description: _feedbackController.text,
                                  mealRecipeRef: widget.mealRecipeRef,
                                ),
                                ...mapToFirestore(
                                  {
                                    'date_created':
                                        FieldValue.serverTimestamp(),
                                  },
                                ),
                              });
                              // Hydrate the in-memory record so any downstream
                              // listener sees a populated value before the
                              // bottomsheet closes.
                              // ignore: unused_local_variable
                              final partnerReviewItemCreated =
                                  PartnerReviewRecord.getDocumentFromData({
                                ...createPartnerReviewRecordData(
                                  pairedUserRef: widget.pairedUserRef,
                                  star: _starValue?.round(),
                                  description: _feedbackController.text,
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
                              if (!context.mounted) return;
                              Navigator.pop(context);
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
                                    child: GoToHistoryComponentWidget(
                                      pairedUserRef: widget.pairedUserRef!,
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        },
                        text: 'Submit',
                        options: FFButtonOptions(
                          width: 270.0,
                          height: 50.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                          borderSide: const BorderSide(
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
