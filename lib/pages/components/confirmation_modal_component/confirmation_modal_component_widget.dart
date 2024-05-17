import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirmation_modal_component_model.dart';
export 'confirmation_modal_component_model.dart';

class ConfirmationModalComponentWidget extends StatefulWidget {
  const ConfirmationModalComponentWidget({
    super.key,
    required this.deleteBtnText,
    required this.cancelBtnText,
    required this.keyword,
    required this.title,
    this.recipeID,
  });

  final String? deleteBtnText;
  final String? cancelBtnText;
  final String? keyword;
  final String? title;
  final DocumentReference? recipeID;

  @override
  State<ConfirmationModalComponentWidget> createState() =>
      _ConfirmationModalComponentWidgetState();
}

class _ConfirmationModalComponentWidgetState
    extends State<ConfirmationModalComponentWidget> {
  late ConfirmationModalComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfirmationModalComponentModel());

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
        child: StreamBuilder<List<SavedRecipeRecord>>(
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
            List<SavedRecipeRecord> cardModalBasicSavedRecipeRecordList =
                snapshot.data!;
            // Return an empty Container when the item does not exist.
            if (snapshot.data!.isEmpty) {
              return Container();
            }
            final cardModalBasicSavedRecipeRecord =
                cardModalBasicSavedRecipeRecordList.isNotEmpty
                    ? cardModalBasicSavedRecipeRecordList.first
                    : null;
            return Container(
              height: 200.0,
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget.title,
                                  'title',
                                ),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              setState(() {
                                FFAppState().yesDeleteAction = true;
                              });
                              if (widget.keyword == 'DELETE-RECIPE-ADD') {
                                await widget.recipeID!.delete();
                                setState(() {
                                  FFAppState().isAddRecipeContentDeleted = true;
                                });
                                if (FFAppState()
                                        .savedRecipeList
                                        .contains(widget.recipeID) ==
                                    true) {
                                  setState(() {
                                    FFAppState().removeFromSavedRecipeList(
                                        widget.recipeID!);
                                  });

                                  await cardModalBasicSavedRecipeRecord!
                                      .reference
                                      .update({
                                    ...mapToFirestore(
                                      {
                                        'saved_meal_recipe_id':
                                            FieldValue.arrayRemove(
                                                [widget.recipeID]),
                                      },
                                    ),
                                  });
                                  Navigator.pop(context);

                                  context.goNamed('home');
                                } else {
                                  Navigator.pop(context);

                                  context.goNamed('home');
                                }
                              } else {
                                if (widget.keyword == 'DELETE-RECIPE-EDIT') {
                                  await widget.recipeID!.delete();
                                  setState(() {
                                    FFAppState().isEditRecipeContentDeleted =
                                        true;
                                  });
                                  if (FFAppState()
                                          .savedRecipeList
                                          .contains(widget.recipeID) ==
                                      true) {
                                    setState(() {
                                      FFAppState().removeFromSavedRecipeList(
                                          widget.recipeID!);
                                    });

                                    await cardModalBasicSavedRecipeRecord!
                                        .reference
                                        .update({
                                      ...mapToFirestore(
                                        {
                                          'saved_meal_recipe_id':
                                              FieldValue.arrayRemove(
                                                  [widget.recipeID]),
                                        },
                                      ),
                                    });
                                    Navigator.pop(context);

                                    context.goNamed('home');
                                  } else {
                                    Navigator.pop(context);

                                    context.goNamed('home');
                                  }
                                } else {
                                  if (widget.keyword ==
                                      'DELETE-RECIPE-DETAILS') {
                                    await widget.recipeID!.delete();
                                    if (FFAppState()
                                            .savedRecipeList
                                            .contains(widget.recipeID) ==
                                        true) {
                                      setState(() {
                                        FFAppState().removeFromSavedRecipeList(
                                            widget.recipeID!);
                                      });

                                      await cardModalBasicSavedRecipeRecord!
                                          .reference
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'saved_meal_recipe_id':
                                                FieldValue.arrayRemove(
                                                    [widget.recipeID]),
                                          },
                                        ),
                                      });
                                      Navigator.pop(context);

                                      context.goNamed('home');
                                    } else {
                                      Navigator.pop(context);

                                      context.goNamed('home');
                                    }
                                  }
                                }
                              }
                            },
                            text: widget.deleteBtnText!,
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.of(context).error,
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
                              hoverColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              hoverTextColor:
                                  FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              if (widget.keyword == 'DELETE-RECIPE-ADD') {
                                setState(() {
                                  FFAppState().isAddRecipeContentDeleted =
                                      false;
                                });
                              } else {
                                if (widget.keyword == 'DELETE-RECIPE-EDIT') {
                                  setState(() {
                                    FFAppState().isEditRecipeContentDeleted =
                                        false;
                                  });
                                } else {
                                  if (widget.keyword ==
                                      '\'DELETE-RECIPE-DETAILS') {
                                    Navigator.pop(context);
                                  }
                                }
                              }

                              Navigator.pop(context);
                            },
                            text: widget.cancelBtnText!,
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
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
                                  FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
