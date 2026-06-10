import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/components/confirmation_assign_meal_to_partner_screen/confirmation_assign_meal_to_partner_screen_widget.dart';
import '/pages/components/reported_container/reported_container_widget.dart';
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Bottom-sheet options for a meal recipe a user did NOT author — assign to
/// partner, save/unsave, and report the recipe.
class OptionNotAuthorComponentWidget extends StatelessWidget {
  const OptionNotAuthorComponentWidget({
    super.key,
    required this.userRef,
    required this.mealRef,
    this.pairedUserRef,
  });

  final DocumentReference? userRef;
  final DocumentReference? mealRef;
  final DocumentReference? pairedUserRef;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<MealRecipeRecord>(
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
          final optionsContainerMealRecipeRecord = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Color(0x33000000),
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
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
                  List<SavedRecipeRecord> optionsColumnSavedRecipeRecordList =
                      snapshot.data!;
                  // Return an empty Container when the item does not exist.
                  if (snapshot.data!.isEmpty) {
                    return Container();
                  }
                  final optionsColumnSavedRecipeRecord =
                      optionsColumnSavedRecipeRecordList.isNotEmpty
                          ? optionsColumnSavedRecipeRecordList.first
                          : null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            12.0, 12.0, 0.0, 0.0),
                        child: Text(
                          'Options',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      if (AppCubit.instance.state.hasPartner == true)
                        Builder(
                          builder: (context) => InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                              await showDialog(
                                barrierDismissible: false,
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
                                        ConfirmationAssignMealToPartnerScreenWidget(
                                      pairedUserRef: pairedUserRef!,
                                      mealRecipeRef: mealRef!,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.group_add_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Send Request',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      Stack(
                        children: [
                          if (optionsColumnSavedRecipeRecord?.savedMealRecipeId
                                  ?.contains(mealRef) ==
                              false)
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                AppCubit.instance.addToSavedRecipeList(mealRef!);

                                await optionsColumnSavedRecipeRecord!.reference
                                    .update({
                                  ...mapToFirestore(
                                    {
                                      'saved_meal_recipe_id':
                                          FieldValue.arrayUnion([mealRef]),
                                    },
                                  ),
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1.0, -1.0),
                                      child: Container(
                                        width: 32.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.bookmark_border,
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Save Recipe',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ].divide(const SizedBox(width: 4.0)),
                                ),
                              ),
                            ),
                          if (optionsColumnSavedRecipeRecord?.savedMealRecipeId
                                  ?.contains(mealRef) ==
                              true)
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                AppCubit.instance.removeFromSavedRecipeList(
                                    optionsContainerMealRecipeRecord
                                        .reference);

                                await optionsColumnSavedRecipeRecord!.reference
                                    .update({
                                  ...mapToFirestore(
                                    {
                                      'saved_meal_recipe_id':
                                          FieldValue.arrayRemove([mealRef]),
                                    },
                                  ),
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(1.0, -1.0),
                                      child: Container(
                                        width: 32.0,
                                        height: 32.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.bookmark_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Save Recipe',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ]
                                      .divide(const SizedBox(width: 8.0))
                                      .addToStart(const SizedBox(width: 5.0)),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                  child: const SizedBox(
                                    height: 150.0,
                                    width: 350.0,
                                    child: ReportedContainerWidget(),
                                  ),
                                );
                              },
                            );
                            if (!context.mounted) return;
                            await mealRef!.update(createMealRecipeRecordData(
                              isRecipeReported: true,
                            ));
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.report_outlined,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 24.0,
                                ),
                                Text(
                                  'Report Recipe',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ]
                                  .divide(const SizedBox(width: 8.0))
                                  .addToStart(const SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                    ].divide(const SizedBox(height: 16.0)),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
