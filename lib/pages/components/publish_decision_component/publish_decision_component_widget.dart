import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/edit_recipe_with_moderator_approval_component/edit_recipe_with_moderator_approval_component_widget.dart';
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Prompts the user to publish a finished recipe to the public catalog or
/// keep it private. Handles the moderator-approval flow when the recipe is
/// being edited.
class PublishDecisionComponentWidget extends StatelessWidget {
  const PublishDecisionComponentWidget({
    super.key,
    required this.mealRef,
    required this.keyword,
  });

  final DocumentReference? mealRef;
  final String? keyword;

  void _resetAddRecipeAppState() {
    AppCubit.instance.setIsBannerUploaded(false);
    AppCubit.instance.setAddVideoLink('');
    AppCubit.instance.setStepsList([]);
    AppCubit.instance.setAddIsBasicRecipeInfoAdded(false);
    AppCubit.instance.setProcedureList([]);
    AppCubit.instance.setCounterBtnClicked(0);
    AppCubit.instance.setIsProcedureItemEdited(false);
    AppCubit.instance.setProcedureJson(ProcedureStruct.fromSerializableMap(jsonDecode('{\"steps\":\"\"}')));
    AppCubit.instance.setWasProcedureListReordered(false);
    AppCubit.instance.setIngredientNewList([]);
    AppCubit.instance.setChosenRecipeCategory([]);
    AppCubit.instance.setRecipeCategoryFromFirebase([]);
    AppCubit.instance.setAttributionTemp('');
    AppCubit.instance.setEstimatedTimeSpinner(DateTime.fromMillisecondsSinceEpoch(1714665600000));
  }

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
                            'Publish recipe to public?',
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
                      Builder(
                        builder: (context) => StreamBuilder<MealRecipeRecord>(
                          stream: MealRecipeRecord.getDocument(mealRef!),
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
                            final buttonMealRecipeRecord = snapshot.data!;
                            return FFButtonWidget(
                              onPressed: () async {
                                if (buttonMealRecipeRecord.adminApproved ==
                                    false) {
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
                                        child:
                                            const EditRecipeWithModeratorApprovalComponentWidget(),
                                      );
                                    },
                                  );

                                  await mealRef!.update(
                                      createMealRecipeRecordData(
                                    isReady: true,
                                    isPublic: true,
                                  ));
                                  _resetAddRecipeAppState();
                                  AppCubit.instance.setYesPublishToPublic(false);
                                  if (!context.mounted) return;
                                  context.goNamed('home');
                                } else {
                                  AppCubit.instance.setYesPublishToPublic(true);

                                  await mealRef!.update(
                                      createMealRecipeRecordData(
                                    isReady: true,
                                    isPublic: true,
                                  ));
                                  if (!context.mounted) return;
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: const Text('Information:'),
                                        content: const Text(
                                            'Your recipe has been published.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: const Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  _resetAddRecipeAppState();
                                  AppCubit.instance.setYesPublishToPublic(false);
                                  if (!context.mounted) return;
                                  context.goNamed('home');
                                }
                              },
                              text: 'YES',
                              options: FFButtonOptions(
                                height: 40.0,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Poppins',
                                      color:
                                          FlutterFlowTheme.of(context).success,
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
                            );
                          },
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: const Text('Information:'),
                                content: const Text(
                                    'Your recipe has been saved as private. You can still find it in \"My Recipes\"'),
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

                          await mealRef!.update(createMealRecipeRecordData(
                            isReady: true,
                            isPublic: false,
                          ));
                          _resetAddRecipeAppState();
                          if (!context.mounted) return;
                          context.goNamed(
                            'home',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: const TransitionInfo(
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
