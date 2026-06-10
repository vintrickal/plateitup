import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Confirm-delete modal for recipes (add / edit / details flows). Looks up the
/// current user's saved-recipes doc so it can also remove the recipe id from
/// the saved list when the user confirms deletion.
class ConfirmationModalComponentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
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
                                valueOrDefault<String>(
                                  title,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 16.0, 0.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              AppCubit.instance.setYesDeleteAction(true);
                              if (keyword == 'DELETE-RECIPE-ADD') {
                                await recipeID!.delete();
                                AppCubit.instance.setIsAddRecipeContentDeleted(true);
                                if (AppCubit.instance.state.savedRecipeList
                                        .contains(recipeID) ==
                                    true) {
                                  AppCubit.instance.removeFromSavedRecipeList(recipeID!);

                                  await cardModalBasicSavedRecipeRecord!
                                      .reference
                                      .update({
                                    ...mapToFirestore(
                                      {
                                        'saved_meal_recipe_id':
                                            FieldValue.arrayRemove([recipeID]),
                                      },
                                    ),
                                  });
                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  context.goNamed('home');
                                } else {
                                  if (!context.mounted) return;
                                  Navigator.pop(context);

                                  context.goNamed('home');
                                }
                              } else {
                                if (keyword == 'DELETE-RECIPE-EDIT') {
                                  await recipeID!.delete();
                                  AppCubit.instance.setIsEditRecipeContentDeleted(true);
                                  if (AppCubit.instance.state.savedRecipeList
                                          .contains(recipeID) ==
                                      true) {
                                    AppCubit.instance.removeFromSavedRecipeList(recipeID!);

                                    await cardModalBasicSavedRecipeRecord!
                                        .reference
                                        .update({
                                      ...mapToFirestore(
                                        {
                                          'saved_meal_recipe_id':
                                              FieldValue.arrayRemove(
                                                  [recipeID]),
                                        },
                                      ),
                                    });
                                    if (!context.mounted) return;
                                    Navigator.pop(context);

                                    context.goNamed('home');
                                  } else {
                                    if (!context.mounted) return;
                                    Navigator.pop(context);

                                    context.goNamed('home');
                                  }
                                } else {
                                  if (keyword == 'DELETE-RECIPE-DETAILS') {
                                    await recipeID!.delete();
                                    if (AppCubit.instance.state.savedRecipeList
                                            .contains(recipeID) ==
                                        true) {
                                      AppCubit.instance.removeFromSavedRecipeList(recipeID!);

                                      await cardModalBasicSavedRecipeRecord!
                                          .reference
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'saved_meal_recipe_id':
                                                FieldValue.arrayRemove(
                                                    [recipeID]),
                                          },
                                        ),
                                      });
                                      if (!context.mounted) return;
                                      Navigator.pop(context);

                                      context.goNamed('home');
                                    } else {
                                      if (!context.mounted) return;
                                      Navigator.pop(context);

                                      context.goNamed('home');
                                    }
                                  }
                                }
                              }
                            },
                            text: deleteBtnText!,
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                              borderRadius: const BorderRadius.only(
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
                              if (keyword == 'DELETE-RECIPE-ADD') {
                                AppCubit.instance.setIsAddRecipeContentDeleted(false);
                              } else {
                                if (keyword == 'DELETE-RECIPE-EDIT') {
                                  AppCubit.instance.setIsEditRecipeContentDeleted(false);
                                } else {
                                  if (keyword == '\'DELETE-RECIPE-DETAILS') {
                                    Navigator.pop(context);
                                  }
                                }
                              }

                              Navigator.pop(context);
                            },
                            text: cancelBtnText!,
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(
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
                        ].divide(const SizedBox(height: 8.0)),
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
