import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
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
import '/pages/components/publish_empty_recipe_component/publish_empty_recipe_component_widget.dart';
import '/pages/components/time_spinner_component/time_spinner_component_widget.dart';
import '/pages/components/upload_image_modal/upload_image_modal_widget.dart';
import 'add_recipe_cubit.dart';
import 'add_recipe_state.dart';

/// Add-recipe screen — Cubit conversion.
///
/// The page is big and the bulk of its behaviour is widget-local Firestore
/// writes (text-field debounced updates, ingredient/procedure list edits,
/// image uploads). The cubit owns just two toggles — [publishToPublic] and
/// [isOriginalRecipe] — which drive the back-button validation and
/// attribution-field state.
class AddRecipeScreenWidget extends StatelessWidget {
  const AddRecipeScreenWidget({
    super.key,
    required this.userRef,
    required this.mealRef,
  });

  final DocumentReference? userRef;
  final DocumentReference? mealRef;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddRecipeCubit(),
      child: _AddRecipeView(userRef: userRef, mealRef: mealRef),
    );
  }
}

class _AddRecipeView extends StatefulWidget {
  const _AddRecipeView({required this.userRef, required this.mealRef});

  final DocumentReference? userRef;
  final DocumentReference? mealRef;

  @override
  State<_AddRecipeView> createState() => _AddRecipeViewState();
}

class _AddRecipeViewState extends State<_AddRecipeView>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Imperative controllers — they don't fit the cubit's immutable state.
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

  final _columnController1 = ScrollController();
  final _ingredientParentColumn = ScrollController();
  final _listviewIngredient = ScrollController();
  final _stepsParentColumn = ScrollController();
  final _listViewController = ScrollController();
  final _columnController2 = ScrollController();

  late final ExpandableController _expandableController;
  late final TabController _tabBarController;

  // Dropdown / chip selections kept widget-local since FormFieldController
  // doesn't compose with immutable state cleanly.
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

    // Fresh-session reset. The ingredient/procedure lists, in-progress
    // edit flags, video link, banner-uploaded toggle, category selections
    // and other draft state live on the global AppCubit — which persists
    // across navigations. Without this, opening Add Recipe a second time
    // would show ingredients and steps from the previous session. Mirrors
    // the field list the delete-recipe button clears, minus the text
    // controllers (which are owned by this State and start empty anyway).
    final app = AppCubit.instance;
    app.setIngredientNewList([]);
    app.setIsIngredientListNotEmpty(false);
    app.setIngredientInfoEdited(null);
    app.setIsIngredientInfoToBeEdited(false);
    app.setWasIngredientListReordered(false);
    app.setIngredientBanner('');
    app.setIsIngredientBannerUploaded(false);
    app.setProcedureList([]);
    app.setProcedureJson(null);
    app.setIsProcedureItemEdited(false);
    app.setWasProcedureListReordered(false);
    app.setStepsList([]);
    app.setCounterBtnClicked(0);
    app.setAddVideoLink('');
    app.setIsBannerUploaded(false);
    app.setAddIsBasicRecipeInfoAdded(false);
    app.setChosenRecipeCategory([]);
    app.setAttributionTemp('');
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
    _columnController1.dispose();
    _ingredientParentColumn.dispose();
    _listviewIngredient.dispose();
    _stepsParentColumn.dispose();
    _listViewController.dispose();
    _columnController2.dispose();
    _expandableController.dispose();
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, app.AppState>(
      builder: (context, _) =>
          BlocBuilder<AddRecipeCubit, AddRecipeState>(builder: (context, recipeState) {
        return _buildBody(context, recipeState);
      }),
    );
  }

  Widget _buildBody(BuildContext context, AddRecipeState recipeState) {
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
        final addRecipeScreenMealRecipeRecord = snapshot.data!;
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
                                    'If you want it to be PUBLIC, you need to include the recipe name. Thank you!'),
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
                                      'If you want it to be PUBLIC, you need to include the author of the recipe. Thank you!'),
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
                                    title: Text('No Recipe Category Detected!'),
                                    content: Text(
                                        'If you want it to be PUBLIC, you need to include the recipe category. Thank you!'),
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
                                      title:
                                          Text('No Recipe Category Detected!'),
                                      content: Text(
                                          'If you want it to be PUBLIC, you need to include the recipe category. Thank you!'),
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
                                            'If you want it to be PUBLIC, you need to include the preparation time [HH:MM]. Thank you!'),
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
                                  if (AppCubit.instance.state.ingredientNewList.length ==
                                      0) {
                                    await showDialog(
                                      context: context,
                                      builder: (alertDialogContext) {
                                        return AlertDialog(
                                          title: Text(
                                              'No Ingredient List Detected!'),
                                          content: Text(
                                              'If you want it to be PUBLIC you need to add the ingredients. Thank you!'),
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
                                    if (AppCubit.instance.state.procedureList.length ==
                                        0) {
                                      await showDialog(
                                        context: context,
                                        builder: (alertDialogContext) {
                                          return AlertDialog(
                                            title:
                                                Text('No Procedure Detected!'),
                                            content: Text(
                                                'If you want it to be PUBLIC, you need to add the list of procedures to prepare the meal. Thank you!'),
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
                                                mealRef:
                                                    addRecipeScreenMealRecipeRecord
                                                        .reference,
                                                keyword: '',
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
                                  'If you want it to be PUBLIC. You need to change it. Thank you!'),
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
                      if ((AppCubit.instance.state.isBannerUploaded == false) ||
                          (_titleController.text == '') ||
                          (AppCubit.instance.state.ingredientList.length == 0) ||
                          (AppCubit.instance.state.stepsList.length == 0)) {
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
                                child: PublishEmptyRecipeComponentWidget(
                                  mealRef:
                                      addRecipeScreenMealRecipeRecord.reference,
                                  keyword: 'add',
                                ),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      } else {
                        setState(() {
                          AppCubit.instance.setIsBannerUploaded(false);
                        });
                        AppCubit.instance.setAddIsBasicRecipeInfoAdded(false);;
                        setState(() {
                          _titleController?.clear();
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
                    }
                  },
                ),
              ),
              title: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                // Proper title typography — was bodyMedium-overridden-to-18.
                child: Text(
                  'Add Recipe',
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
                    borderRadius: 0.0,
                    borderWidth: 0.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.delete_forever_rounded,
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
                                  keyword: 'DELETE-RECIPE-ADD',
                                  title: 'Delete this recipe?',
                                  recipeID:
                                      addRecipeScreenMealRecipeRecord.reference,
                                ),
                              ),
                            ),
                          );
                        },
                      ).then((value) => setState(() {}));

                      if (AppCubit.instance.state.isAddRecipeContentDeleted == true) {
                        setState(() {
                          AppCubit.instance.setIsBannerUploaded(false);
                        });
                        setState(() {
                          AppCubit.instance.setAddIsBasicRecipeInfoAdded(false);
                        });
                        setState(() {
                          _titleController?.clear();
                          _ingredientNameController?.clear();
                          _quantityController?.clear();
                          _stepsController?.clear();
                          _attributionController?.clear();
                        });
                        AppCubit.instance.setProcedureList([]);
                          AppCubit.instance.setProcedureJson(ProcedureStruct.fromSerializableMap(
                                  jsonDecode('{\"steps\":\"\"}')));
                          AppCubit.instance.setCounterBtnClicked(0);
                          AppCubit.instance.setStepsList([]);
                          AppCubit.instance.setIngredientNewList([]);;
                        setState(() {
                          AppCubit.instance.setAddVideoLink('');
                        });
                        setState(() {
                          AppCubit.instance.setIsAddRecipeContentDeleted(false);
                        });
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
              // Subtle drop-shadow separates the bar from the scroll content
              // — was flat (elevation: 0) which made the title float.
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
                    controller: _columnController1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Visibility + autosave-status row — wrapped in a
                        // light card so it reads as a single section header
                        // instead of two floating widgets above the banner.
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
                                          .read<AddRecipeCubit>()
                                          .setPublishToPublic(newValue!);
                                      if (newValue!) {
                                        await addRecipeScreenMealRecipeRecord
                                            .reference
                                            .update(createMealRecipeRecordData(
                                          isPublic: true,
                                        ));
                                      } else {
                                        await addRecipeScreenMealRecipeRecord
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
                                  // Lock/globe icon makes the visibility
                                  // state legible at a glance.
                                  Padding(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(4.0, 0.0, 4.0, 0.0),
                                    child: Icon(
                                      recipeState.publishToPublic == true
                                          ? Icons.public_rounded
                                          : Icons.lock_outline_rounded,
                                      size: 16.0,
                                      color: recipeState.publishToPublic ==
                                              true
                                          ? FlutterFlowTheme.of(context)
                                              .success
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                  Text(
                                    recipeState.publishToPublic == true
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
                              // Cloud-done icon + label communicates the
                              // autosave status more clearly than plain text.
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
                                  onTap: () =>
                                      _unfocusNode.canRequestFocus
                                          ? FocusScope.of(context)
                                              .requestFocus(_unfocusNode)
                                          : FocusScope.of(context).unfocus(),
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: UploadImageModalWidget(
                                      docRef: addRecipeScreenMealRecipeRecord
                                          .reference,
                                      requestId: 'recipeBanner',
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => safeSetState(() {}));
                          },
                          child: Stack(
                            alignment: AlignmentDirectional(1.0, 1.0),
                            children: [
                              if (AppCubit.instance.state.isBannerUploaded == false)
                                // Self-contained "Tap to upload" placeholder.
                                // Replaces a broken `https://fakeimg.pl/...`
                                // external URL that 404s in offline MVP mode.
                                Container(
                                  width: double.infinity,
                                  height: 180.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 56.0,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: FlutterFlowTheme.of(context)
                                              .success
                                              .withOpacity(0.12),
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .success,
                                          size: 28.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        'Add cover photo',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        'JPG or PNG, up to 5 MB',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 11.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (AppCubit.instance.state.isBannerUploaded == true)
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
                                  child: StreamBuilder<MealRecipeRecord>(
                                    stream: MealRecipeRecord.getDocument(
                                        addRecipeScreenMealRecipeRecord
                                            .reference),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 24.0,
                                            height: 24.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .success,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final uploadedBannerMealRecipeRecord =
                                          snapshot.data!;
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          uploadedBannerMealRecipeRecord.banner,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              // "Tap to change" pill — only shows when a
                              // banner has been uploaded. The empty state
                              // already invites uploading, so the pill
                              // would be redundant there.
                              if (AppCubit.instance.state.isBannerUploaded ==
                                  true)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 12.0),
                                  child: Container(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(10.0, 6.0, 12.0, 6.0),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withOpacity(0.55),
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
                                          style:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    letterSpacing: 0.0,
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                // Hero-style title input — was a 14pt
                                // borderless field with a "[Recipe name]"
                                // bracket-hint. Now reads as a proper
                                // section heading with a subtle bottom
                                // accent that flips green on focus.
                                child: TextFormField(
                                  controller: _titleController,
                                  focusNode: _titleFocus,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_titleController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      await addRecipeScreenMealRecipeRecord
                                          .reference
                                          .update(createMealRecipeRecordData(
                                        title: _titleController.text,
                                      ));
                                    },
                                  ),
                                  autofocus: false,
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
                              Row(
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
                                    child: Stack(
                                      children: [
                                        if (AppCubit.instance.state.addVideoLink == '')
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () => _unfocusNode.canRequestFocus
                                                        ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                        : FocusScope.of(context).unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          ModalVideoLinkTemplateWidget(
                                                        docRef:
                                                            addRecipeScreenMealRecipeRecord
                                                                .reference,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Text(
                                              'Add video',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 13.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        if (AppCubit.instance.state.addVideoLink != '')
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () => _unfocusNode.canRequestFocus
                                                        ? FocusScope.of(context).requestFocus(_unfocusNode)
                                                        : FocusScope.of(context).unfocus(),
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          ModalVideoLinkTemplateWidget(
                                                        docRef:
                                                            addRecipeScreenMealRecipeRecord
                                                                .reference,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Text(
                                              'Video added',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF129575),
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                            ),
                                          ),
                                      ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // Attribution / credit field — softer than
                                // the title (smaller, lighter weight), with
                                // a person-outline icon prefix so it reads
                                // as a byline.
                                child: TextFormField(
                                  controller: _attributionController,
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
                                          .read<AddRecipeCubit>()
                                          .setIsOriginalRecipe(
                                              _attributionController.text ==
                                                  currentUserDisplayName);
                                    },
                                  ),
                                  autofocus: false,
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
                                  Theme(
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
                                      value: recipeState.isOriginalRecipe,
                                      onChanged: (newValue) async {
                                        context
                                            .read<AddRecipeCubit>()
                                            .setIsOriginalRecipe(newValue!);
                                        if (newValue!) {
                                          if (_attributionController
                                                  .text ==
                                              '') {
                                            setState(() {
                                              AppCubit.instance.setAttributionTemp('');
                                            });
                                          } else {
                                            setState(() {
                                              AppCubit.instance.setAttributionTemp(_attributionController
                                                  .text);
                                            });
                                          }

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
                                          FlutterFlowTheme.of(context).success,
                                      checkColor:
                                          FlutterFlowTheme.of(context).info,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.timer_sharp,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0,
                              ),
                              Container(
                                width: 50.0,
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
                                      dateTimeFormat('Hm',
                                          AppCubit.instance.state.estimatedTimeSpinner),
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
                                          AppCubit.instance.state.staticStringList,
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
                                            child: Visibility(
                                              visible: AppCubit.instance.state.chosenRecipeCategory
                                                      .length !=
                                                  0,
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
                                                        WrapCrossAlignment
                                                            .center,
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
                                                            choosenRecipeCategoryListViewIndex !=
                                                                0,
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
                                                                MainAxisSize
                                                                    .min,
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
                                                                  child:
                                                                      Padding(
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
                                // Segmented tab control — bumped from 11pt
                                // to a more legible 13pt with a rounded
                                // pill background. Background tinted with a
                                // very light alpha of the brand green so
                                // the unselected state still feels related
                                // to the selected one.
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
                                    backgroundColor:
                                        const Color(0xFF129575),
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
                                    padding:
                                        const EdgeInsets.symmetric(
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
                                                            "Column_j294fq96" +
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

                                                                              await addRecipeScreenMealRecipeRecord.reference.update({
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

                                                                            await addRecipeScreenMealRecipeRecord.reference.update({
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
                                                      final reordered =
                                                          await actions
                                                              .onReorderIngredient(
                                                        oldIdx,
                                                        newIdx,
                                                        ingredientLocalList
                                                            .toList(),
                                                      );
                                                      await widget.mealRef!
                                                          .update({
                                                        ...mapToFirestore({
                                                          'ingredient':
                                                              getIngredientListFirestoreData(
                                                                  reordered),
                                                        }),
                                                      });
                                                      if (!mounted) return;
                                                      setState(() {
                                                        AppCubit.instance.setIngredientNewList((reordered ?? const <IngredientStruct>[])
                                                                .toList());
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
                                                                      false,
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
                                                              width: 45.0,
                                                              decoration:
                                                                  BoxDecoration(),
                                                              child:
                                                                  TextFormField(
                                                                controller: _quantityController,
                                                                focusNode: _quantityFocus,
                                                                autofocus:
                                                                    false,
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
                                                                      '[Qty.]',
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
                                                                    _measurementDropdownValue ??=
                                                                        AppCubit.instance.state.isIngredientInfoToBeEdited
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

                                                              await addRecipeScreenMealRecipeRecord
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

                                                            await _ingredientParentColumn
                                                                .animateTo(
                                                              _ingredientParentColumn
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          100),
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

                                                      await addRecipeScreenMealRecipeRecord
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
                                                      await _ingredientParentColumn
                                                          .animateTo(
                                                        _ingredientParentColumn
                                                            .position
                                                            .maxScrollExtent,
                                                        duration: const Duration(
                                                            milliseconds: 100),
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
                                                            "ListView_uoy5ckqs" +
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
                                                      final reordered =
                                                          await actions
                                                              .onReorderProcedure(
                                                        oldIdx,
                                                        newIdx,
                                                        procedureListview.toList(),
                                                      );
                                                      await widget.mealRef!
                                                          .update({
                                                        ...mapToFirestore({
                                                          'procedure':
                                                              getProcedureListFirestoreData(
                                                                  reordered),
                                                        }),
                                                      });
                                                      if (!mounted) return;
                                                      setState(() {
                                                        AppCubit.instance.setProcedureList((reordered ?? const <ProcedureStruct>[])
                                                                .toList());
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
                                                    primary: false,
                                                    controller: _columnController2,
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
                                                              labelText: _stepsFocus
                                                                          .hasFocus
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

                                                                await addRecipeScreenMealRecipeRecord
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
