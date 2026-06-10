import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/components/confirmation_modal_component/confirmation_modal_component_widget.dart';
import '/pages/components/modal_video_link_template/modal_video_link_template_widget.dart';
import '/pages/components/publish_decision_component/publish_decision_component_widget.dart';
import '/pages/components/time_spinner_component/time_spinner_component_widget.dart';
import '/pages/components/upload_image_modal/upload_image_modal_widget.dart';
import 'edit_recipe_cubit.dart';
import 'edit_recipe_state.dart';

/// Edit-recipe screen — Cubit conversion.
///
/// Same shape as add-recipe: the cubit owns the two top-level toggles, the
/// widget owns the text/scroll/focus controllers and per-field Firestore
/// writes.
class EditRecipeScreenWidget extends StatelessWidget {
  const EditRecipeScreenWidget({
    super.key,
    required this.mealRef,
    required this.ingredientList,
    required this.procedureList,
    required this.recipeCategoryList,
  });

  final DocumentReference? mealRef;
  final List<IngredientStruct>? ingredientList;
  final List<ProcedureStruct>? procedureList;
  final List<String>? recipeCategoryList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditRecipeCubit(),
      child: _EditRecipeView(
        mealRef: mealRef,
        ingredientList: ingredientList,
        procedureList: procedureList,
        recipeCategoryList: recipeCategoryList,
      ),
    );
  }
}

class _EditRecipeView extends StatefulWidget {
  const _EditRecipeView({
    required this.mealRef,
    required this.ingredientList,
    required this.procedureList,
    required this.recipeCategoryList,
  });

  final DocumentReference? mealRef;
  final List<IngredientStruct>? ingredientList;
  final List<ProcedureStruct>? procedureList;
  final List<String>? recipeCategoryList;

  @override
  State<_EditRecipeView> createState() => _EditRecipeViewState();
}

class _EditRecipeViewState extends State<_EditRecipeView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _unfocusNode = FocusNode();
  final _titleController = TextEditingController();
  final _titleFocus = FocusNode();
  final _attributionController = TextEditingController();
  final _attributionFocus = FocusNode();
  final _ingredientNameController = TextEditingController();
  late final FocusNode _ingredientNameFocus;
  final _quantityController = TextEditingController();
  late final FocusNode _quantityFocus;
  final _stepsController = TextEditingController();
  late final FocusNode _stepsFocus;

  final _editRecipeColumn = ScrollController();
  final _ingredientParentColumn = ScrollController();
  final _listviewIngredient = ScrollController();
  final _stepsParentColumn = ScrollController();
  final _listViewController = ScrollController();
  final _columnController = ScrollController();

  late final ExpandableController _expandableController;
  late final TabController _tabBarController;

  String? _measurementDropdownValue;
  FormFieldController<String>? _measurementDropdownController;
  List<String>? _recipeCategoryDropdownValue;
  FormFieldController<List<String>>? _recipeCategoryDropdownController;

  @override
  void initState() {
    super.initState();
    _ingredientNameFocus = FocusNode()..addListener(() => setState(() {}));
    _quantityFocus = FocusNode()..addListener(() => setState(() {}));
    _stepsFocus = FocusNode()..addListener(() => setState(() {}));
    _expandableController = ExpandableController(initialExpanded: false);
    _tabBarController = TabController(vsync: this, length: 2, initialIndex: 0)
      ..addListener(() => setState(() {}));

    // Seed AppCubit with the params we were navigated in with — the
    // ingredient/procedure builder UIs read directly from those lists.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final app = AppCubit.instance;
      app.setIsBannerUploaded(true);
      app.setIngredientNewList(
          (widget.ingredientList ?? const <IngredientStruct>[]).toList());
      app.setProcedureList(
          (widget.procedureList ?? const <ProcedureStruct>[]).toList());
      app.setChosenRecipeCategory(
          (widget.recipeCategoryList ?? const <String>[]).toList());
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    _titleController.dispose();
    _titleFocus.dispose();
    _attributionController.dispose();
    _attributionFocus.dispose();
    _ingredientNameController.dispose();
    _ingredientNameFocus.dispose();
    _quantityController.dispose();
    _quantityFocus.dispose();
    _stepsController.dispose();
    _stepsFocus.dispose();
    _editRecipeColumn.dispose();
    _ingredientParentColumn.dispose();
    _listviewIngredient.dispose();
    _stepsParentColumn.dispose();
    _listViewController.dispose();
    _columnController.dispose();
    _expandableController.dispose();
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, app.AppState>(
      builder: (context, _) =>
          BlocBuilder<EditRecipeCubit, EditRecipeState>(
              builder: (context, recipeState) {
        return _buildBody(context, recipeState);
      }),
    );
  }

  Widget _buildBody(BuildContext context, EditRecipeState recipeState) {
    return StreamBuilder<MealRecipeRecord>(
      stream: MealRecipeRecord.getDocument(widget.mealRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).success,
                  ),
                ),
              ),
            ),
          );
        }
        final editRecipeScreenMealRecipeRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: Builder(
                builder: (context) => FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 20.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    if (recipeState.publishToPublic == true) {
                      if (AppCubit.instance.state.isBannerUploaded == true) {
                        if (_titleController.text == '') {
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('No Recipe Name Detected!'),
                                content: Text(
                                    'If you want it to be public. You need to put the recipe name. Thank you!'),
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
                          if (_attributionController.text ==
                              '') {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('No Attribution Detected!'),
                                  content: Text(
                                      'If you want it to be public, you need to include the author of the recipe. Thank you!'),
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
                            if (AppCubit.instance.state.chosenRecipeCategory.length == 0) {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('No Category Detected!'),
                                    content: Text(
                                        'If you want it to be public, you need to include the recipe category. Thank you!'),
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
                              if ((AppCubit.instance.state.chosenRecipeCategory.length ==
                                      1) &&
                                  (AppCubit.instance.state.chosenRecipeCategory[0] ==
                                      ' ')) {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('No Category Detected!'),
                                      content: Text(
                                          'If you want it to be public, you need to include the recipe category. Thank you!'),
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
                                if (dateTimeFormat('Hm',
                                        AppCubit.instance.state.estimatedTimeSpinner) ==
                                    '00:00') {
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text(
                                            'No Preparation Time Detected!'),
                                        content: Text(
                                            'If you want it to be public, you need to include the preparation time [HH:MM]. Thank you!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  if (editRecipeScreenMealRecipeRecord
                                          .ingredient.length ==
                                      0) {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                              'No Ingredient List Detected!'),
                                          content: Text(
                                              'If you want it to be public. You need to add the ingredients. Thank you!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  alertDialogContext),
                                              child: Text('Ok'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    if (editRecipeScreenMealRecipeRecord
                                            .procedure.length ==
                                        0) {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title:
                                                Text('No Procedure Detected!'),
                                            content: Text(
                                                'If you want it to be public. You need to add the list of procedure to prepare the meal. Thank you!'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    alertDialogContext),
                                                child: Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: GestureDetector(
                                              onTap: () => _unfocusNode
                                                      .canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _unfocusNode)
                                                  : FocusScope.of(context)
                                                      .unfocus(),
                                              child:
                                                  PublishDecisionComponentWidget(
                                                mealRef: widget.mealRef!,
                                                keyword: 'edit',
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => setState(() {}));
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      } else {
                        await showDialog(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Default Banner Detected!'),
                              content: Text(
                                  'If you want it to be public. You need to change it. Thank you!'),
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
                      }
                    } else {
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

                      await widget.mealRef!.update(createMealRecipeRecordData(
                        isReady: true,
                      ));
                      setState(() {
                        AppCubit.instance.setIsBannerUploaded(false);
                      });
                      AppCubit.instance.setAddIsBasicRecipeInfoAdded(false);;
                      setState(() {
                        _titleController?.clear();
                        _attributionController?.clear();
                        _ingredientNameController?.clear();
                        _quantityController?.clear();
                        _stepsController?.clear();
                      });
                      setState(() {
                        AppCubit.instance.setIngredientList([]);
                        AppCubit.instance.setStepsList([]);
                      });
                      setState(() {
                        AppCubit.instance.setAddVideoLink('');
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
                    }
                  },
                ),
              ),
              title: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                // Match Add Recipe — proper title typography.
                child: Text(
                  'Edit Recipe',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20.0,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              actions: [
                Builder(
                  builder: (context) => FlutterFlowIconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: FlutterFlowTheme.of(context).error,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return Dialog(
                            elevation: 0,
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            alignment: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            child: GestureDetector(
                              onTap: () => _unfocusNode.canRequestFocus
                                  ? FocusScope.of(context)
                                      .requestFocus(_unfocusNode)
                                  : FocusScope.of(context).unfocus(),
                              child: Container(
                                height: 250.0,
                                width: 350.0,
                                child: ConfirmationModalComponentWidget(
                                  deleteBtnText: 'DELETE RECIPE',
                                  cancelBtnText: 'KEEP EDITING',
                                  keyword: 'DELETE-RECIPE-EDIT',
                                  title: 'Delete this recipe?',
                                  recipeID: editRecipeScreenMealRecipeRecord
                                      .reference,
                                ),
                              ),
                            ),
                          );
                        },
                      ).then((value) => setState(() {}));

                      if (AppCubit.instance.state.isEditRecipeContentDeleted == true) {
                        setState(() {
                          AppCubit.instance.setIsBannerUploaded(false);
                          AppCubit.instance.setAddIsBasicRecipeInfoAdded(false);
                        });
                        setState(() {
                          _titleController?.clear();
                          _attributionController?.clear();
                          _quantityController?.clear();
                          _ingredientNameController?.clear();
                          _stepsController?.clear();
                        });
                        AppCubit.instance.setProcedureList([]);
                          AppCubit.instance.setProcedureJson(ProcedureStruct.fromSerializableMap(
                                  jsonDecode('{\"steps\":\"\"}')));
                          AppCubit.instance.setCounterBtnClicked(0);
                          AppCubit.instance.setStepsList([]);
                          AppCubit.instance.setIngredientNewList([]);
                          AppCubit.instance.setAddVideoLink('');
                          AppCubit.instance.setIsEditRecipeContentDeleted(false);;
                        // Reverts back to 0
                        setState(() {
                          AppCubit.instance.setCounterBtnClicked(0);
                          AppCubit.instance.setIsProcedureItemEdited(false);
                          AppCubit.instance.setProcedureJson(ProcedureStruct.fromSerializableMap(
                                  jsonDecode('{\"steps\":\"\"}')));
                          AppCubit.instance.setProcedureList([]);
                          AppCubit.instance.setWasProcedureListReordered(false);
                          AppCubit.instance.setChosenRecipeCategory([]);
                          AppCubit.instance.setAttributionTemp('');
                          AppCubit.instance.setRecipeCategoryFromFirebase([]);
                        });
                      }
                    },
                  ),
                ),
              ],
              centerTitle: false,
              // Match Add Recipe — subtle drop-shadow on scroll.
              elevation: 1.0,
              shadowColor: Colors.black.withOpacity(0.04),
              surfaceTintColor: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            body: SafeArea(
              top: true,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    controller: _editRecipeColumn,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Visibility + autosave-status card — same layout
                        // as Add Recipe so the two screens read as one
                        // flow. Reads `isPublic` straight from the doc here
                        // (Edit Recipe uses the Firestore value as truth)
                        // rather than the cubit state.
                        Container(
                          margin: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 4.0),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              12.0, 6.0, 14.0, 6.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch.adaptive(
                                    value: recipeState.publishToPublic,
                                    onChanged: (newValue) async {
                                      context
                                          .read<EditRecipeCubit>()
                                          .setPublishToPublic(newValue!);
                                      if (newValue!) {
                                        await editRecipeScreenMealRecipeRecord
                                            .reference
                                            .update(createMealRecipeRecordData(
                                          isPublic: true,
                                        ));
                                      } else {
                                        await editRecipeScreenMealRecipeRecord
                                            .reference
                                            .update(createMealRecipeRecordData(
                                          isPublic: false,
                                        ));
                                      }
                                    },
                                    activeColor:
                                        FlutterFlowTheme.of(context).success,
                                    activeTrackColor:
                                        FlutterFlowTheme.of(context).success,
                                    inactiveTrackColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    inactiveThumbColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(4.0, 0.0, 4.0, 0.0),
                                    child: Icon(
                                      editRecipeScreenMealRecipeRecord
                                                  .isPublic ==
                                              true
                                          ? Icons.public_rounded
                                          : Icons.lock_outline_rounded,
                                      size: 16.0,
                                      color: editRecipeScreenMealRecipeRecord
                                                  .isPublic ==
                                              true
                                          ? FlutterFlowTheme.of(context)
                                              .success
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                  Text(
                                    editRecipeScreenMealRecipeRecord
                                                .isPublic ==
                                            true
                                        ? 'Public'
                                        : 'Private',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cloud_done_outlined,
                                    size: 14.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    'Auto-saved',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional(1.0, 1.0),
                          children: [
                            Container(
                              width: double.infinity,
                              height: 150.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () => _unfocusNode.canRequestFocus
                                            ? FocusScope.of(context).requestFocus(_unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: UploadImageModalWidget(
                                            docRef:
                                                editRecipeScreenMealRecipeRecord
                                                    .reference,
                                            requestId: 'recipeBanner',
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl:
                                        editRecipeScreenMealRecipeRecord.banner,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) =>
                                        Image.asset(
                                      'assets/images/error_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // "Change photo" pill — same affordance as
                            // Add Recipe so the two screens match.
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 12.0, 12.0),
                              child: Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0, 6.0, 12.0, 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius:
                                      BorderRadius.circular(999.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      'Change photo',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                // Hero-style title input — matches Add Recipe.
                                child: TextFormField(
                                  controller: () {
                                    if (_titleController.text.isEmpty) {
                                      _titleController.text =
                                          editRecipeScreenMealRecipeRecord
                                                  .title ??
                                              '';
                                    }
                                    return _titleController;
                                  }(),
                                  focusNode: _titleFocus,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_titleController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      await widget.mealRef!
                                          .update(createMealRecipeRecordData(
                                        title: _titleController.text,
                                      ));
                                    },
                                  ),
                                  autofocus: true,
                                  textCapitalization:
                                      TextCapitalization.words,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 8.0),
                                    hintText: 'Recipe name',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 18.0,
                                          letterSpacing: -0.2,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.2,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .success,
                                        width: 1.8,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 18.0,
                                        letterSpacing: -0.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                  maxLength: 20,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  buildCounter: (context,
                                          {required currentLength,
                                          required isFocused,
                                          maxLength}) =>
                                      null,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () => _unfocusNode.canRequestFocus
                                            ? FocusScope.of(context).requestFocus(_unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: ModalVideoLinkTemplateWidget(
                                            docRef:
                                                editRecipeScreenMealRecipeRecord
                                                    .reference,
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 4.0, 0.0),
                                      child: Icon(
                                        Icons.play_circle,
                                        color: Color(0xFF129575),
                                        size: 24.0,
                                      ),
                                    ),
                                    Container(
                                      width: 100.0,
                                      height: 18.0,
                                      decoration: BoxDecoration(),
                                      child: Text(
                                        editRecipeScreenMealRecipeRecord
                                                    .videolink ==
                                                ''
                                            ? 'Add video'
                                            : 'Video added',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  editRecipeScreenMealRecipeRecord
                                                              .videolink ==
                                                          ''
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .success,
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // Byline-style attribution input — matches
                                // Add Recipe.
                                child: TextFormField(
                                  controller: () {
                                    if (_attributionController.text.isEmpty) {
                                      _attributionController.text =
                                          editRecipeScreenMealRecipeRecord
                                                  .attribution ??
                                              '';
                                    }
                                    return _attributionController;
                                  }(),
                                  focusNode: _attributionFocus,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_attributionController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      await widget.mealRef!
                                          .update(createMealRecipeRecordData(
                                        attribution:
                                            _attributionController.text,
                                      ));
                                      context
                                          .read<EditRecipeCubit>()
                                          .setIsOriginalRecipe(
                                              _attributionController.text ==
                                                  currentUserDisplayName);
                                    },
                                  ),
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 6.0),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0.0, 0.0, 4.0, 0.0),
                                      child: Icon(
                                        Icons.person_outline_rounded,
                                        size: 16.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                    prefixIconConstraints:
                                        const BoxConstraints(minWidth: 22.0),
                                    hintText: 'Recipe by…',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .success,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLength: 20,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  buildCounter: (context,
                                          {required currentLength,
                                          required isFocused,
                                          maxLength}) =>
                                      null,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  AuthUserStreamWidget(
                                    builder: (context) => Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        unselectedWidgetColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                      ),
                                      child: Checkbox(
                                        value:
                                            recipeState.isOriginalRecipe,
                                        onChanged: (newValue) async {
                                          context
                                              .read<EditRecipeCubit>()
                                              .setIsOriginalRecipe(newValue!);
                                          if (newValue) {
                                            AppCubit.instance.setAttributionTemp(_attributionController.text);

                                            setState(() {
                                              _attributionController
                                                  ?.text = currentUserDisplayName;
                                            });

                                            await widget.mealRef!.update(
                                                createMealRecipeRecordData(
                                              attribution: _attributionController
                                                  .text,
                                            ));
                                          } else {
                                            setState(() {
                                              _attributionController
                                                      ?.text =
                                                  AppCubit.instance.state.attributionTemp;
                                            });

                                            await widget.mealRef!.update(
                                                createMealRecipeRecordData(
                                              attribution: _attributionController
                                                  .text,
                                            ));
                                          }
                                        },
                                        side: BorderSide(
                                          width: 2,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        activeColor:
                                            FlutterFlowTheme.of(context)
                                                .success,
                                        checkColor:
                                            FlutterFlowTheme.of(context).info,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Original Recipe',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          color:
                                              recipeState.isOriginalRecipe !=
                                                      true
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryText
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.timer_sharp,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0,
                              ),
                              Container(
                                width: 60.0,
                                height: 30.0,
                                decoration: BoxDecoration(),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Builder(
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
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: GestureDetector(
                                              onTap: () => _unfocusNode
                                                      .canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _unfocusNode)
                                                  : FocusScope.of(context)
                                                      .unfocus(),
                                              child:
                                                  TimeSpinnerComponentWidget(),
                                            ),
                                          );
                                        },
                                      ).then((value) => setState(() {}));

                                      await widget.mealRef!
                                          .update(createMealRecipeRecordData(
                                        prepTime:
                                            AppCubit.instance.state.estimatedTimeSpinner,
                                      ));
                                    },
                                    child: Text(
                                      dateTimeFormat(
                                          'Hm',
                                          editRecipeScreenMealRecipeRecord
                                                  .prepTime ??
                                              DateTime(2024)),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: ExpandableNotifier(
                                  controller:
                                      _expandableController,
                                  child: ExpandablePanel(
                                    header: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        multiSelectController:
                                            _recipeCategoryDropdownController ??=
                                                FormFieldController<List<String>>(
                                                    _recipeCategoryDropdownValue ??=
                                                        List<String>.from(
                                          widget.recipeCategoryList ?? const <String>[],
                                        )),
                                        options: AppCubit.instance.state.recipeCategories,
                                        width: 300.0,
                                        maxHeight: 200.0,
                                        searchHintTextStyle:
                                            FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                        searchTextStyle:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.0,
                                                ),
                                        textStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        hintText: 'List of Recipe Category',
                                        searchHintText:
                                            'Search for a category..',
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 15.0,
                                        ),
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor: Colors.transparent,
                                        borderWidth: 2.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 4.0, 16.0, 4.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: true,
                                        isMultiSelect: true,
                                        onMultiSelectChanged: (val) async {
                                          setState(() {
                                            _recipeCategoryDropdownValue = val;
                                          });
                                          AppCubit.instance.setChosenRecipeCategory((val ?? const <String>[]).toList());

                                          await widget.mealRef!.update({
                                            ...mapToFirestore(
                                              {
                                                'category': AppCubit.instance.state.chosenRecipeCategory,
                                              },
                                            ),
                                          });
                                        },
                                      ),
                                    ),
                                    collapsed: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final choosenRecipeCategoryListView =
                                                    AppCubit.instance.state.chosenRecipeCategory
                                                        .toList();
                                                return Wrap(
                                                  spacing: 0.0,
                                                  runSpacing: 8.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: List.generate(
                                                      choosenRecipeCategoryListView
                                                          .length,
                                                      (choosenRecipeCategoryListViewIndex) {
                                                    final choosenRecipeCategoryListViewItem =
                                                        choosenRecipeCategoryListView[
                                                            choosenRecipeCategoryListViewIndex];
                                                    return Visibility(
                                                      visible:
                                                          choosenRecipeCategoryListViewItem !=
                                                              ' ',
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: 40.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .alternate,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.0,
                                                                        0.0),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          8.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    choosenRecipeCategoryListViewItem,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    expanded: Container(),
                                    theme: ExpandableThemeData(
                                      tapHeaderToExpand: true,
                                      tapBodyToExpand: false,
                                      tapBodyToCollapse: true,
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      hasIcon: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 450.0,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Column(
                              children: [
                                // Pill-style segmented control — matches
                                // Add Recipe.
                                Align(
                                  alignment: const Alignment(0.0, 0),
                                  child: FlutterFlowButtonTabBar(
                                    useToggleButtonStyle: false,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w700,
                                          lineHeight: 1.4,
                                        ),
                                    unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              lineHeight: 1.4,
                                            ),
                                    labelColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    unselectedLabelColor:
                                        const Color(0xFF129575),
                                    backgroundColor: const Color(0xFF129575),
                                    unselectedBackgroundColor:
                                        const Color(0xFF129575)
                                            .withOpacity(0.10),
                                    unselectedBorderColor: Colors.transparent,
                                    borderWidth: 0.0,
                                    borderRadius: 999.0,
                                    elevation: 0.0,
                                    buttonMargin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 4.0, 0.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 8.0),
                                    tabs: const [
                                      Tab(text: 'Ingredients'),
                                      Tab(text: 'Procedure'),
                                    ],
                                    controller: _tabBarController,
                                    onTap: (i) async {
                                      [() async {}, () async {}][i]();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabBarController,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                        child: SingleChildScrollView(
                                          primary: false,
                                          controller:
                                              _ingredientParentColumn,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final ingredientLocalList =
                                                      AppCubit.instance.state.ingredientNewList
                                                          .toList();
                                                  return ReorderableListView
                                                      .builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        ingredientLocalList
                                                            .length,
                                                    itemBuilder: (context,
                                                        ingredientLocalListIndex) {
                                                      final ingredientLocalListItem =
                                                          ingredientLocalList[
                                                              ingredientLocalListIndex];
                                                      return Container(
                                                        key: ValueKey(
                                                            "ListView_vkbw29j5" +
                                                                '_' +
                                                                ingredientLocalListIndex
                                                                    .toString()),
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          20.0,
                                                                          0.0,
                                                                          16.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 76.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                8.0,
                                                                                0.0),
                                                                            child:
                                                                                Container(
                                                                              width: 52.0,
                                                                              height: 52.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/default-ingredient.png',
                                                                                  width: 300.0,
                                                                                  height: 200.0,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                150.0,
                                                                            decoration:
                                                                                BoxDecoration(),
                                                                            child:
                                                                                Text(
                                                                              ingredientLocalListItem.ingrName,
                                                                              maxLines: 2,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Color(0xFF121212),
                                                                                    fontSize: 16.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    lineHeight: 1.5,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            65.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(),
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                                child: AutoSizeText(
                                                                                  ingredientLocalListItem.ingrQuantity,
                                                                                  maxLines: 1,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                        fontFamily: 'Poppins',
                                                                                        color: Color(0xFFA9A9A9),
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        lineHeight: 1.5,
                                                                                      ),
                                                                                  minFontSize: 14.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(),
                                                                              alignment: AlignmentDirectional(-1.0, 0.0),
                                                                              child: Text(
                                                                                ingredientLocalListItem.ingrUnit,
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Poppins',
                                                                                      color: Color(0xFFA9A9A9),
                                                                                      letterSpacing: 0.0,
                                                                                    ),
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
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      1.0,
                                                                      -1.0),
                                                              child: Container(
                                                                width: (AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_ingredientNameFocus?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_quantityFocus?.hasFocus ?? false) ==
                                                                                false))
                                                                    ? 60.0
                                                                    : 30.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    if ((AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_ingredientNameFocus?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_quantityFocus?.hasFocus ?? false) ==
                                                                                false)))
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            4.0,
                                                                            0.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            if ((_ingredientNameController.text == '') &&
                                                                                (_quantityController.text == '')) {
                                                                              await _ingredientParentColumn?.animateTo(
                                                                                _ingredientParentColumn!.position.maxScrollExtent,
                                                                                duration: Duration(milliseconds: 100),
                                                                                curve: Curves.ease,
                                                                              );
                                                                              setState(() {
                                                                                AppCubit.instance.removeAtIndexFromIngredientNewList(ingredientLocalListIndex);
                                                                                AppCubit.instance.setIsIngredientInfoToBeEdited(true);
                                                                              });

                                                                              await editRecipeScreenMealRecipeRecord.reference.update({
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'ingredient': getIngredientListFirestoreData(
                                                                                      AppCubit.instance.state.ingredientNewList,
                                                                                    ),
                                                                                  },
                                                                                ),
                                                                              });
                                                                              setState(() {
                                                                                _ingredientNameController?.text = ingredientLocalListItem.ingrName;
                                                                              });
                                                                              setState(() {
                                                                                _quantityController?.text = ingredientLocalListItem.ingrQuantity;
                                                                              });
                                                                              setState(() {
                                                                                _measurementDropdownController?.value = ingredientLocalListItem.ingrUnit;
                                                                              });
                                                                            } else {
                                                                              if ((_ingredientNameController.text != '') && (_quantityController.text == '')) {
                                                                                await showDialog(
                                                                                  context: context,
                                                                                  builder: (alertDialogContext) {
                                                                                    return AlertDialog(
                                                                                      title: Text('[Ingredient Name] is not Empty!'),
                                                                                      content: Text('SAVE or REMOVE the text currently inside the text field before editing.'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () => Navigator.pop(alertDialogContext),
                                                                                          child: Text('Ok'),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                if ((_quantityController.text != '') && (_ingredientNameController.text == '')) {
                                                                                  await showDialog(
                                                                                    context: context,
                                                                                    builder: (alertDialogContext) {
                                                                                      return AlertDialog(
                                                                                        title: Text('[Quantity] is not Empty!'),
                                                                                        content: Text('SAVE or REMOVE the text currently inside the text field before editing.'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () => Navigator.pop(alertDialogContext),
                                                                                            child: Text('Ok'),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                } else {
                                                                                  if ((_ingredientNameController.text != '') && (_quantityController.text != '')) {
                                                                                    await showDialog(
                                                                                      context: context,
                                                                                      builder: (alertDialogContext) {
                                                                                        return AlertDialog(
                                                                                          title: Text('[Ingredient Name] and [Quantity] is not Empty!'),
                                                                                          content: Text('SAVE or REMOVE the text currently inside the text field before editing.'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                                              child: Text('Ok'),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }
                                                                              }
                                                                            }
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.edit_square,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).tertiary,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if ((AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_ingredientNameFocus?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_quantityFocus?.hasFocus ?? false) ==
                                                                                false)))
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              AppCubit.instance.removeAtIndexFromIngredientNewList(ingredientLocalListIndex);
                                                                            });

                                                                            await editRecipeScreenMealRecipeRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'ingredient': getIngredientListFirestoreData(
                                                                                    AppCubit.instance.state.ingredientNewList,
                                                                                  ),
                                                                                },
                                                                              ),
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_forever,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    scrollController: _listviewIngredient,
                                                    onReorder: (oldIdx, newIdx) async {
                                                      final reordered = await actions
                                                          .onReorderIngredient(
                                                        oldIdx,
                                                        newIdx,
                                                        ingredientLocalList.toList(),
                                                      );
                                                      await widget.mealRef!.update({
                                                        ...mapToFirestore({
                                                          'ingredient':
                                                              getIngredientListFirestoreData(reordered),
                                                        }),
                                                      });
                                                      if (!mounted) return;
                                                      setState(() {
                                                        AppCubit.instance.setIngredientNewList((reordered ?? const <IngredientStruct>[]).toList());
                                                        AppCubit.instance.setWasIngredientListReordered(true);
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 16.0, 0.0, 0.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 76.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(8.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Stack(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.0, 0.0),
                                                              children: [
                                                                Container(
                                                                  width: 52.0,
                                                                  height: 52.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryBackground,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/default-ingredient.png',
                                                                      width:
                                                                          300.0,
                                                                      height:
                                                                          200.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              width: 170.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller: _ingredientNameController,
                                                                  focusNode: _ingredientNameFocus,
                                                                  autofocus:
                                                                      true,
                                                                  textCapitalization:
                                                                      TextCapitalization
                                                                          .words,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                  obscureText:
                                                                      false,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              Color(0xFF121212),
                                                                          fontSize:
                                                                              16.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          lineHeight:
                                                                              1.5,
                                                                        ),
                                                                    hintText:
                                                                        '[Ingredient Name]',
                                                                    hintStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontStyle:
                                                                              FontStyle.italic,
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
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                  maxLines:
                                                                      null,
                                                                  maxLength: 15,
                                                                  maxLengthEnforcement:
                                                                      MaxLengthEnforcement
                                                                          .enforced,
                                                                  buildCounter: (context,
                                                                          {required currentLength,
                                                                          required isFocused,
                                                                          maxLength}) =>
                                                                      null,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 35.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child:
                                                                  TextFormField(
                                                                controller: _quantityController,
                                                                focusNode: _quantityFocus,
                                                                autofocus: true,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: Color(
                                                                            0xFFA9A9A9),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        lineHeight:
                                                                            1.5,
                                                                      ),
                                                                  hintText:
                                                                      '[Qt.]',
                                                                  hintStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontStyle:
                                                                            FontStyle.italic,
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
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                minLines: 1,
                                                                maxLength: 4,
                                                                maxLengthEnforcement:
                                                                    MaxLengthEnforcement
                                                                        .enforced,
                                                                buildCounter: (context,
                                                                        {required currentLength,
                                                                        required isFocused,
                                                                        maxLength}) =>
                                                                    null,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 80.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child:
                                                                    FlutterFlowDropDown<
                                                                        String>(
                                                                  controller: _measurementDropdownController ??=
                                                                      FormFieldController<String>(
                                                                    _measurementDropdownValue ??= AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                                            true
                                                                        ? (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')
                                                                        : 'pc/s',
                                                                  ),
                                                                  options:
                                                                      AppCubit.instance.state.metricAndImperial,
                                                                  onChanged: (val) =>
                                                                      setState(() =>
                                                                          _measurementDropdownValue =
                                                                              val),
                                                                  width: 60.0,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                  hintText: AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                                          true
                                                                      ? (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')
                                                                      : 'pc/s',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 24.0,
                                                                  ),
                                                                  elevation:
                                                                      2.0,
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderWidth:
                                                                      2.0,
                                                                  borderRadius:
                                                                      8.0,
                                                                  margin: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  hidesUnderline:
                                                                      true,
                                                                  isOverButton:
                                                                      true,
                                                                  isSearchable:
                                                                      false,
                                                                  isMultiSelect:
                                                                      false,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                  false)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 0.0, 64.0),
                                                  child: FFButtonWidget(
                                                    onPressed: () {
                                                      if (_ingredientNameController.text ==
                                                          '') {
                                                        return true;
                                                      } else if (_quantityController.text ==
                                                          '') {
                                                        return true;
                                                      } else {
                                                        return false;
                                                      }
                                                    }()
                                                        ? null
                                                        : () async {
                                                            if ((_ingredientNameController
                                                                        .text !=
                                                                    '') &&
                                                                (_quantityController
                                                                        .text !=
                                                                    '')) {
                                                              setState(() {
                                                                AppCubit.instance.setIngredientJson(<String,
                                                                        dynamic>{
                                                                  'ingr_name':
                                                                      _ingredientNameController.text,
                                                                  'ingr_quantity':
                                                                      _quantityController.text,
                                                                  'ingr_unit':
                                                                      _measurementDropdownValue,
                                                                });
                                                              });

                                                              await editRecipeScreenMealRecipeRecord
                                                                  .reference
                                                                  .update({
                                                                ...mapToFirestore(
                                                                  {
                                                                    'ingredient':
                                                                        FieldValue
                                                                            .arrayUnion([
                                                                      getIngredientFirestoreData(
                                                                        updateIngredientStruct(
                                                                          IngredientStruct.maybeFromMap(
                                                                              AppCubit.instance.state.ingredientJson),
                                                                          clearUnsetFields:
                                                                              false,
                                                                        ),
                                                                        true,
                                                                      )
                                                                    ]),
                                                                  },
                                                                ),
                                                              });
                                                              setState(() {
                                                                AppCubit.instance.addToIngredientNewList(
                                                                    IngredientStruct.maybeFromMap(
                                                                        AppCubit.instance.state.ingredientJson)!);
                                                              });
                                                              setState(() {
                                                                _measurementDropdownController
                                                                        ?.value =
                                                                    'pc/s';
                                                              });
                                                              setState(() {
                                                                _quantityController.clear();
                                                                _ingredientNameController.clear();
                                                              });
                                                            } else {
                                                              if (_ingredientNameController.text == '') {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Missing Ingredient Name',
                                                                      style:
                                                                          TextStyle(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontSize:
                                                                            16.0,
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
                                                                if (_quantityController.text == '') {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        'Missing Quantity Ingredient',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryBackground,
                                                                          fontSize:
                                                                              16.0,
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
                                                                }
                                                              }
                                                            }

                                                            await _ingredientParentColumn.animateTo(
                                                              _ingredientParentColumn.position.maxScrollExtent,
                                                              duration: const Duration(milliseconds: 100),
                                                              curve: Curves.ease,
                                                            );
                                                            setState(() {
                                                              AppCubit.instance.setTempHideWidget(true);
                                                            });
                                                          },
                                                    text: 'Add Ingredient',
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 40.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  24.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color: (_ingredientNameController
                                                                      .text !=
                                                                  '') &&
                                                              (_quantityController
                                                                      .text !=
                                                                  '')
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .success
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      elevation: 3.0,
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                              if (AppCubit.instance.state.isIngredientInfoToBeEdited ==
                                                  true)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 0.0, 64.0),
                                                  child: FFButtonWidget(
                                                    onPressed: () async {
                                                      // Check if there's any changes with the ingredient name value
                                                      if (_ingredientNameController.text ==
                                                          '') {
                                                        // Check if there's any changes with the quantity text value
                                                        if (_quantityController.text == '') {
                                                          // Check if the dropdown value is equal to the stored value of the choosen data to be edited.
                                                          if (_measurementDropdownValue ==
                                                              (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrName ?? ''),
                                                                'ingr_quantity':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrQuantity ?? ''),
                                                                'ingr_unit':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? ''),
                                                              });
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrName ?? ''),
                                                                'ingr_quantity':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrQuantity ?? ''),
                                                                'ingr_unit': _measurementDropdownValue,
                                                              });
                                                            });
                                                          }
                                                        } else {
                                                          if (_measurementDropdownValue ==
                                                              (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrName ?? ''),
                                                                'ingr_quantity':
                                                                    _quantityController.text,
                                                                'ingr_unit':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? ''),
                                                              });
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrName ?? ''),
                                                                'ingr_quantity':
                                                                    _quantityController.text,
                                                                'ingr_unit': _measurementDropdownValue,
                                                              });
                                                            });
                                                          }
                                                        }
                                                      } else {
                                                        if (_quantityController.text == '') {
                                                          if (_measurementDropdownValue ==
                                                              (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name': _ingredientNameController.text,
                                                                'ingr_quantity':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrQuantity ?? ''),
                                                                'ingr_unit':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? ''),
                                                              });
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name': _ingredientNameController.text,
                                                                'ingr_quantity':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrQuantity ?? ''),
                                                                'ingr_unit': _measurementDropdownValue,
                                                              });
                                                            });
                                                          }
                                                        } else {
                                                          if (_measurementDropdownValue ==
                                                              (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? '')) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name': _ingredientNameController.text,
                                                                'ingr_quantity':
                                                                    _quantityController.text,
                                                                'ingr_unit':
                                                                    (AppCubit.instance.state.ingredientInfoEdited?.ingrUnit ?? ''),
                                                              });
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              AppCubit.instance.setIngredientJson(<String,
                                                                      dynamic>{
                                                                'ingr_name': _ingredientNameController.text,
                                                                'ingr_quantity':
                                                                    _quantityController.text,
                                                                'ingr_unit': _measurementDropdownValue,
                                                              });
                                                            });
                                                          }
                                                        }
                                                      }

                                                      await editRecipeScreenMealRecipeRecord
                                                          .reference
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'ingredient':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              getIngredientFirestoreData(
                                                                updateIngredientStruct(
                                                                  IngredientStruct
                                                                      .maybeFromMap(
                                                                          AppCubit.instance.state.ingredientJson),
                                                                  clearUnsetFields:
                                                                      false,
                                                                ),
                                                                true,
                                                              )
                                                            ]),
                                                          },
                                                        ),
                                                      });
                                                      setState(() {
                                                        _measurementDropdownController
                                                            ?.value = 'pc/s';
                                                      });
                                                      setState(() {
                                                        AppCubit.instance.addToIngredientNewList(
                                                            IngredientStruct
                                                                .maybeFromMap(
                                                                    AppCubit.instance.state.ingredientJson)!);
                                                      });
                                                      setState(() {
                                                        AppCubit.instance.setIsIngredientInfoToBeEdited(false);
                                                      });
                                                      setState(() {
                                                        _quantityController.clear();
                                                        _ingredientNameController.clear();
                                                      });
                                                      await _ingredientParentColumn.animateTo(
                                                        _ingredientParentColumn.position.maxScrollExtent,
                                                        duration: const Duration(milliseconds: 100),
                                                        curve: Curves.ease,
                                                      );
                                                    },
                                                    text: 'Save Changes',
                                                    options: FFButtonOptions(
                                                      width: double.infinity,
                                                      height: 40.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  24.0,
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
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                      elevation: 3.0,
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                        child: SingleChildScrollView(
                                          primary: false,
                                          controller: _stepsParentColumn,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final procedureListview =
                                                      AppCubit.instance.state.procedureList
                                                          .toList();
                                                  return ReorderableListView
                                                      .builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: procedureListview
                                                        .length,
                                                    itemBuilder: (context,
                                                        procedureListviewIndex) {
                                                      final procedureListviewItem =
                                                          procedureListview[
                                                              procedureListviewIndex];
                                                      return Container(
                                                        key: ValueKey(
                                                            "ListView_vqexduah" +
                                                                '_' +
                                                                procedureListviewIndex
                                                                    .toString()),
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          20.0,
                                                                          0.0,
                                                                          16.0),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            4.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            4.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            0.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            0.0),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          16.0,
                                                                          36.0,
                                                                          16.0),
                                                                  child: Text(
                                                                    procedureListviewItem
                                                                        .steps,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    maxLines:
                                                                        10,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          0.0),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8.0),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        8.0,
                                                                        12.0,
                                                                        0.0),
                                                                child: Text(
                                                                  'Step ${functions.incrementSteps(procedureListviewIndex).toString()}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      1.0,
                                                                      -1.0),
                                                              child: Container(
                                                                width: (AppCubit.instance.state.isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_stepsFocus?.hasFocus ??
                                                                                false) ==
                                                                            false)
                                                                    ? 60.0
                                                                    : 30.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if ((AppCubit.instance.state.isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_stepsFocus?.hasFocus ??
                                                                                false) ==
                                                                            false))
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              4.0,
                                                                              0.0,
                                                                              4.0,
                                                                              0.0),
                                                                          child:
                                                                              InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              if (_stepsController.text == '') {
                                                                                await _stepsParentColumn?.animateTo(
                                                                                  _stepsParentColumn!.position.maxScrollExtent,
                                                                                  duration: Duration(milliseconds: 100),
                                                                                  curve: Curves.ease,
                                                                                );
                                                                                if (AppCubit.instance.state.wasProcedureListReordered == true) {
                                                                                  setState(() {
                                                                                    AppCubit.instance.setProcedureJson(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                                    AppCubit.instance.setIsProcedureItemEdited(true);
                                                                                  });
                                                                                  setState(() {
                                                                                    AppCubit.instance.removeFromProcedureList(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                                    AppCubit.instance.setWasProcedureListReordered(false);
                                                                                  });
                                                                                } else {
                                                                                  setState(() {
                                                                                    AppCubit.instance.setProcedureJson(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                                    AppCubit.instance.setIsProcedureItemEdited(true);
                                                                                  });
                                                                                  setState(() {
                                                                                    AppCubit.instance.removeFromProcedureList(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                                  });
                                                                                }

                                                                                await widget.mealRef!.update({
                                                                                  ...mapToFirestore(
                                                                                    {
                                                                                      'procedure': getProcedureListFirestoreData(
                                                                                        AppCubit.instance.state.procedureList,
                                                                                      ),
                                                                                    },
                                                                                  ),
                                                                                });
                                                                                setState(() {
                                                                                  _stepsController?.text = (AppCubit.instance.state.procedureJson?.steps ?? '');
                                                                                });
                                                                              } else {
                                                                                await showDialog(
                                                                                  context: context,
                                                                                  builder: (alertDialogContext) {
                                                                                    return AlertDialog(
                                                                                      title: Text('[Step Description] is not Empty!'),
                                                                                      content: Text('SAVE or REMOVE the text currently inside the text field before editing.'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                          onPressed: () => Navigator.pop(alertDialogContext),
                                                                                          child: Text('Ok'),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.edit_square,
                                                                              color: FlutterFlowTheme.of(context).tertiary,
                                                                              size: 24.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if ((AppCubit.instance.state.isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_stepsFocus?.hasFocus ??
                                                                                false) ==
                                                                            false))
                                                                      Align(
                                                                        alignment: AlignmentDirectional(
                                                                            1.0,
                                                                            -1.0),
                                                                        child:
                                                                            InkWell(
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          focusColor:
                                                                              Colors.transparent,
                                                                          hoverColor:
                                                                              Colors.transparent,
                                                                          highlightColor:
                                                                              Colors.transparent,
                                                                          onTap:
                                                                              () async {
                                                                            if (AppCubit.instance.state.wasProcedureListReordered ==
                                                                                true) {
                                                                              setState(() {
                                                                                AppCubit.instance.removeFromProcedureList(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                AppCubit.instance.removeFromProcedureList(AppCubit.instance.state.procedureList[procedureListviewIndex]);
                                                                              });
                                                                            }

                                                                            await widget.mealRef!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'procedure': getProcedureListFirestoreData(
                                                                                    AppCubit.instance.state.procedureList,
                                                                                  ),
                                                                                },
                                                                              ),
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_forever,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).error,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    scrollController: _listViewController,
                                                    onReorder: (oldIdx, newIdx) async {
                                                      final reordered = await actions
                                                          .onReorderProcedure(
                                                        oldIdx,
                                                        newIdx,
                                                        procedureListview.toList(),
                                                      );
                                                      await widget.mealRef!.update({
                                                        ...mapToFirestore({
                                                          'procedure':
                                                              getProcedureListFirestoreData(reordered),
                                                        }),
                                                      });
                                                      if (!mounted) return;
                                                      setState(() {
                                                        AppCubit.instance.setProcedureList((reordered ?? const <ProcedureStruct>[]).toList());
                                                        AppCubit.instance.setWasProcedureListReordered(true);
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 16.0, 0.0, 64.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    controller:
                                                        _columnController,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      8.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: TextFormField(
                                                            controller: _stepsController,
                                                            focusNode: _stepsFocus,
                                                            autofocus: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: _stepsFocus.hasFocus
                                                                  ? 'Step ${functions.incrementSteps(AppCubit.instance.state.procedureList.length).toString()}'
                                                                  : 'What are the steps to make this meal?',
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        letterSpacing:
                                                                            0.0,
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
                                                                ),
                                                            maxLines: 4,
                                                            maxLength: 250,
                                                            maxLengthEnforcement:
                                                                MaxLengthEnforcement
                                                                    .enforced,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      8.0,
                                                                      16.0,
                                                                      0.0),
                                                          child: FFButtonWidget(
                                                            onPressed:
                                                                () async {
                                                              if (_stepsController.text != '') {
                                                                setState(() {
                                                                  AppCubit.instance.setStepsJson(<String,
                                                                          dynamic>{
                                                                    'steps': _stepsController.text,
                                                                  });
                                                                });
                                                                setState(() {
                                                                  AppCubit.instance.addToProcedureList(
                                                                      ProcedureStruct.maybeFromMap(
                                                                          AppCubit.instance.state.stepsJson)!);
                                                                });

                                                                await editRecipeScreenMealRecipeRecord
                                                                    .reference
                                                                    .update({
                                                                  ...mapToFirestore(
                                                                    {
                                                                      'procedure':
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        getProcedureFirestoreData(
                                                                          updateProcedureStruct(
                                                                            ProcedureStruct.maybeFromMap(AppCubit.instance.state.stepsJson),
                                                                            clearUnsetFields:
                                                                                false,
                                                                          ),
                                                                          true,
                                                                        )
                                                                      ]),
                                                                    },
                                                                  ),
                                                                });
                                                                setState(() {
                                                                  _stepsController.clear();
                                                                });
                                                                setState(() {
                                                                  AppCubit.instance.setIsProcedureItemEdited(false);
                                                                });
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Text(
                                                                      'Are you sure you added a step?',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            4000),
                                                                    backgroundColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .error,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            text: 'Add',
                                                            options:
                                                                FFButtonOptions(
                                                              height: 40.0,
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0),
                                                              iconPadding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
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
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                              elevation: 3.0,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].divide(SizedBox(height: 12.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
