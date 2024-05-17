import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'publish_empty_recipe_component_model.dart';
export 'publish_empty_recipe_component_model.dart';

class PublishEmptyRecipeComponentWidget extends StatefulWidget {
  const PublishEmptyRecipeComponentWidget({
    super.key,
    required this.mealRef,
    required this.keyword,
  });

  final DocumentReference? mealRef;
  final String? keyword;

  @override
  State<PublishEmptyRecipeComponentWidget> createState() =>
      _PublishEmptyRecipeComponentWidgetState();
}

class _PublishEmptyRecipeComponentWidgetState
    extends State<PublishEmptyRecipeComponentWidget> {
  late PublishEmptyRecipeComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PublishEmptyRecipeComponentModel());

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
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 12.0, 0.0),
                          child: Text(
                            'Do you want to continue this recipe later?',
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          setState(() {
                            FFAppState().yesFinishRecipeLater = true;
                          });

                          await widget.mealRef!
                              .update(createMealRecipeRecordData(
                            isPublic: false,
                            isReady: true,
                          ));
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Information:'),
                                content: Text(
                                    'Your recipe has been saved as private. You can still find it in \"My Recipes\"'),
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
                          setState(() {
                            FFAppState().isBannerUploaded = false;
                            FFAppState().addVideoLink = '';
                            FFAppState().stepsList = [];
                            FFAppState().ingredientList = [];
                            FFAppState().addIsBasicRecipeInfoAdded = false;
                            FFAppState().procedureList = [];
                            FFAppState().counterBtnClicked = 0;
                            FFAppState().isProcedureItemEdited = false;
                            FFAppState().procedureJson =
                                ProcedureStruct.fromSerializableMap(
                                    jsonDecode('{\"steps\":\"\"}'));
                            FFAppState().wasProcedureListReordered = false;
                            FFAppState().chosenRecipeCategory = [];
                            FFAppState().recipeCategoryFromFirebase = [];
                            FFAppState().attributionTemp = '';
                            FFAppState().estimatedTimeSpinner =
                                DateTime.fromMillisecondsSinceEpoch(
                                    1714665600000);
                            FFAppState().yesFinishRecipeLater = false;
                          });

                          context.goNamed(
                            'home',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'YES',
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
                          await widget.mealRef!.delete();
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Information:'),
                                content: Text('Your recipe has been deleted.'),
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
                          setState(() {
                            FFAppState().isBannerUploaded = false;
                            FFAppState().addVideoLink = '';
                            FFAppState().stepsList = [];
                            FFAppState().ingredientList = [];
                            FFAppState().addIsBasicRecipeInfoAdded = false;
                            FFAppState().procedureList = [];
                            FFAppState().counterBtnClicked = 0;
                            FFAppState().isProcedureItemEdited = false;
                            FFAppState().procedureJson =
                                ProcedureStruct.fromSerializableMap(
                                    jsonDecode('{\"steps\":\"\"}'));
                            FFAppState().wasProcedureListReordered = false;
                            FFAppState().chosenRecipeCategory = [];
                            FFAppState().recipeCategoryFromFirebase = [];
                            FFAppState().attributionTemp = '';
                            FFAppState().estimatedTimeSpinner =
                                DateTime.fromMillisecondsSinceEpoch(
                                    1714665600000);
                          });

                          context.goNamed(
                            'home',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.fade,
                                duration: Duration(milliseconds: 0),
                              ),
                            },
                          );
                        },
                        text: 'NO',
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
