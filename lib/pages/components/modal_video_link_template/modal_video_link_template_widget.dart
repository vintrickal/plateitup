import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Bottom-sheet modal that captures a URL for the recipe's video guide and
/// writes it onto the meal-recipe doc. Validates the URL on save and clears
/// the field on cancel or invalid input.
///
/// Layout note: the sheet sizes to content (`MainAxisSize.min`) rather than
/// holding a fixed height. A fixed 320px box used to clip the bottom row of
/// buttons whenever the keyboard was open or on smaller phones — the parent
/// already wraps us in `Padding(padding: MediaQuery.viewInsetsOf(context))`
/// for keyboard avoidance, so we just need to be honest about our height.
class ModalVideoLinkTemplateWidget extends StatefulWidget {
  const ModalVideoLinkTemplateWidget({
    super.key,
    required this.docRef,
  });

  final DocumentReference? docRef;

  @override
  State<ModalVideoLinkTemplateWidget> createState() =>
      _ModalVideoLinkTemplateWidgetState();
}

class _ModalVideoLinkTemplateWidgetState
    extends State<ModalVideoLinkTemplateWidget> {
  final TextEditingController _videolinkController = TextEditingController();
  final FocusNode _videolinkFocus = FocusNode();

  @override
  void dispose() {
    _videolinkController.dispose();
    _videolinkFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(16.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 7.0,
                color: Color(0x33000000),
                offset: Offset(0.0, -2.0),
              )
            ],
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          // SafeArea(top: false) reserves space for the home indicator on
          // devices that have one — the buttons used to sit on top of it.
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  0.0, 8.0, 0.0, 12.0),
              child: Column(
                // Critical: don't expand to fill — let the content drive the
                // sheet's height. With MainAxisAlignment.end + fixed height
                // the column overflowed by ~12px whenever the content total
                // exceeded 320.
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Text(
                      'Recipe Video Guide',
                      style: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 4.0, 16.0, 0.0),
                    child: Text(
                      'Would greatly help if there\'s a video',
                      style: FlutterFlowTheme.of(context)
                          .labelMedium
                          .override(
                            fontFamily: 'Poppins',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: TextFormField(
                      controller: _videolinkController,
                      focusNode: _videolinkFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelStyle: FlutterFlowTheme.of(context)
                            .bodyLarge
                            .override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                        hintText: 'Insert link here...',
                        hintStyle: FlutterFlowTheme.of(context)
                            .labelLarge
                            .override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                        prefixIcon: Icon(
                          Icons.link_rounded,
                          size: 20.0,
                          color:
                              FlutterFlowTheme.of(context).secondaryText,
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
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        // Tightened from 24,24 — was reserving space for 4
                        // text lines even though URLs are a single line.
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 14.0, 12.0, 14.0),
                      ),
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily: 'Poppins',
                            letterSpacing: 0.0,
                          ),
                      // Was maxLines: 4 — the field rendered ~100px tall when
                      // empty, which was the main contributor to the overflow.
                      maxLines: 1,
                      cursorColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            _videolinkController.clear();
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                          options: FFButtonOptions(
                            height: 45.0,
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                            iconPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        FFButtonWidget(
                          onPressed: () async {
                            if (functions
                                .httpChecker(_videolinkController.text)!) {
                              AppCubit.instance
                                  .setAddVideoLink(_videolinkController.text);

                              await widget.docRef!
                                  .update(createMealRecipeRecordData(
                                videolink:
                                    AppCubit.instance.state.addVideoLink,
                              ));
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Invalid url link.',
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  duration:
                                      const Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                              _videolinkController.clear();
                              Navigator.pop(context);
                            }
                          },
                          text: 'Confirm',
                          options: FFButtonOptions(
                            height: 45.0,
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    20.0, 0.0, 20.0, 0.0),
                            iconPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).success,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                            elevation: 2.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
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
      ),
    );
  }
}
