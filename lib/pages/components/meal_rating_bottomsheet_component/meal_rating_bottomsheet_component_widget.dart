import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '/cubits/app/app_cubit.dart';

/// Bottom-sheet that lets a viewer rate a meal recipe and leave feedback,
/// writing a new ReviewRecord on submit.
class MealRatingBottomsheetComponentWidget extends StatefulWidget {
  const MealRatingBottomsheetComponentWidget({
    super.key,
    required this.mealRecipeRef,
  });

  final DocumentReference? mealRecipeRef;

  @override
  State<MealRatingBottomsheetComponentWidget> createState() =>
      _MealRatingBottomsheetComponentWidgetState();
}

class _MealRatingBottomsheetComponentWidgetState
    extends State<MealRatingBottomsheetComponentWidget> {
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
                  'What did you think of the recipe?',
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
                  'Let the recipe owner know what you think',
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
                  Padding(
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
                            AppCubit.instance.setIsReviewTabEmpty(true);

                            var reviewRecordReference =
                                ReviewRecord.createDoc(widget.mealRecipeRef!);
                            await reviewRecordReference.set({
                              ...createReviewRecordData(
                                userRef: currentUserReference,
                                star: _starValue?.round(),
                                description: _feedbackController.text,
                              ),
                              ...mapToFirestore(
                                {
                                  'date_created': FieldValue.serverTimestamp(),
                                },
                              ),
                            });
                            // Hydrate the in-memory record so any downstream
                            // listener sees a populated value before the
                            // bottomsheet closes.
                            // ignore: unused_local_variable
                            final reviewItemCreated =
                                ReviewRecord.getDocumentFromData({
                              ...createReviewRecordData(
                                userRef: currentUserReference,
                                star: _starValue?.round(),
                                description: _feedbackController.text,
                              ),
                              ...mapToFirestore(
                                {
                                  'date_created': DateTime.now(),
                                },
                              ),
                            }, reviewRecordReference);
                            AppCubit.instance.setIsReviewExist(true);
                            AppCubit.instance.setIsReviewTabEmpty(false);
                            if (!context.mounted) return;
                            Navigator.pop(context);
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
