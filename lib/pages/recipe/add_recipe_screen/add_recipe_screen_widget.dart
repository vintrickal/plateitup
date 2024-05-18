import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
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
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_recipe_screen_model.dart';
export 'add_recipe_screen_model.dart';

class AddRecipeScreenWidget extends StatefulWidget {
  const AddRecipeScreenWidget({
    super.key,
    required this.userRef,
    required this.mealRef,
  });

  final DocumentReference? userRef;
  final DocumentReference? mealRef;

  @override
  State<AddRecipeScreenWidget> createState() => _AddRecipeScreenWidgetState();
}

class _AddRecipeScreenWidgetState extends State<AddRecipeScreenWidget>
    with TickerProviderStateMixin {
  late AddRecipeScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddRecipeScreenModel());

    _model.titleTextController ??= TextEditingController();
    _model.titleFocusNode ??= FocusNode();

    _model.attributionTextfieldTextController ??= TextEditingController();
    _model.attributionTextfieldFocusNode ??= FocusNode();

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: false);
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.ingredientNameTextController ??= TextEditingController();
    _model.ingredientNameFocusNode ??= FocusNode();
    _model.ingredientNameFocusNode!.addListener(() => setState(() {}));
    _model.quantityTextTextController ??= TextEditingController();
    _model.quantityTextFocusNode ??= FocusNode();
    _model.quantityTextFocusNode!.addListener(() => setState(() {}));
    _model.stepsTextfieldTextController ??= TextEditingController();
    _model.stepsTextfieldFocusNode ??= FocusNode();
    _model.stepsTextfieldFocusNode!.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
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
                    if (_model.switchStatusValue == true) {
                      if (FFAppState().isBannerUploaded == true) {
                        if (_model.titleTextController.text == '') {
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
                          if (_model.attributionTextfieldTextController.text ==
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
                            if (FFAppState().chosenRecipeCategory.length == 0) {
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
                              if ((FFAppState().chosenRecipeCategory.length ==
                                      1) &&
                                  (FFAppState().chosenRecipeCategory[0] ==
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
                                        FFAppState().estimatedTimeSpinner) ==
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
                                  if (FFAppState().ingredientNewList.length ==
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
                                    if (FFAppState().procedureList.length ==
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
                                              onTap: () => _model.unfocusNode
                                                      .canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _model.unfocusNode)
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
                      if ((FFAppState().isBannerUploaded == false) ||
                          (_model.titleTextController.text == '') ||
                          (FFAppState().ingredientList.length == 0) ||
                          (FFAppState().stepsList.length == 0)) {
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
                                onTap: () => _model.unfocusNode.canRequestFocus
                                    ? FocusScope.of(context)
                                        .requestFocus(_model.unfocusNode)
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
                          FFAppState().isBannerUploaded = false;
                        });
                        FFAppState().update(() {
                          FFAppState().addIsBasicRecipeInfoAdded = false;
                        });
                        setState(() {
                          _model.titleTextController?.clear();
                          _model.ingredientNameTextController?.clear();
                          _model.quantityTextTextController?.clear();
                          _model.stepsTextfieldTextController?.clear();
                        });
                        setState(() {
                          FFAppState().ingredientList = [];
                          FFAppState().stepsList = [];
                        });
                        setState(() {
                          FFAppState().addVideoLink = '';
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
                child: Text(
                  'Add Recipe',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
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
                              onTap: () => _model.unfocusNode.canRequestFocus
                                  ? FocusScope.of(context)
                                      .requestFocus(_model.unfocusNode)
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

                      if (FFAppState().isAddRecipeContentDeleted == true) {
                        setState(() {
                          FFAppState().isBannerUploaded = false;
                        });
                        setState(() {
                          FFAppState().addIsBasicRecipeInfoAdded = false;
                        });
                        setState(() {
                          _model.titleTextController?.clear();
                          _model.ingredientNameTextController?.clear();
                          _model.quantityTextTextController?.clear();
                          _model.stepsTextfieldTextController?.clear();
                          _model.attributionTextfieldTextController?.clear();
                        });
                        FFAppState().update(() {
                          FFAppState().procedureList = [];
                          FFAppState().procedureJson =
                              ProcedureStruct.fromSerializableMap(
                                  jsonDecode('{\"steps\":\"\"}'));
                          FFAppState().counterBtnClicked = 0;
                          FFAppState().stepsList = [];
                          FFAppState().ingredientNewList = [];
                        });
                        setState(() {
                          FFAppState().addVideoLink = '';
                        });
                        setState(() {
                          FFAppState().isAddRecipeContentDeleted = false;
                        });
                        // Reverts back to 0
                        setState(() {
                          FFAppState().counterBtnClicked = 0;
                          FFAppState().isProcedureItemEdited = false;
                          FFAppState().procedureJson =
                              ProcedureStruct.fromSerializableMap(
                                  jsonDecode('{\"steps\":\"\"}'));
                          FFAppState().procedureList = [];
                          FFAppState().wasProcedureListReordered = false;
                          FFAppState().chosenRecipeCategory = [];
                          FFAppState().attributionTemp = '';
                          FFAppState().recipeCategoryFromFirebase = [];
                        });
                      }
                    },
                  ),
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
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
                    controller: _model.columnController1,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Switch.adaptive(
                                  value: _model.switchStatusValue ??= true,
                                  onChanged: (newValue) async {
                                    setState(() =>
                                        _model.switchStatusValue = newValue!);
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
                                Text(
                                  _model.switchStatusValue == true
                                      ? 'Public'
                                      : 'Private',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Text(
                                'All changes are auto-saved',
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
                            ),
                          ],
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
                                      _model.unfocusNode.canRequestFocus
                                          ? FocusScope.of(context)
                                              .requestFocus(_model.unfocusNode)
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
                              if (FFAppState().isBannerUploaded == false)
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://fakeimg.pl/600x150',
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              if (FFAppState().isBannerUploaded == true)
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
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                  width: double.infinity,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(0.0),
                                      topRight: Radius.circular(0.0),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 0.0, 0.0, 4.0),
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        size: 24.0,
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
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
                                child: Container(
                                  width: 185.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(),
                                  child: TextFormField(
                                    controller: _model.titleTextController,
                                    focusNode: _model.titleFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.titleTextController',
                                      Duration(milliseconds: 2000),
                                      () async {
                                        await addRecipeScreenMealRecipeRecord
                                            .reference
                                            .update(createMealRecipeRecordData(
                                          title:
                                              _model.titleTextController.text,
                                        ));
                                      },
                                    ),
                                    autofocus: false,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      hintText: '[Recipe name]',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    validator: _model
                                        .titleTextControllerValidator
                                        .asValidator(context),
                                  ),
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
                                        if (FFAppState().addVideoLink == '')
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
                                                    onTap: () => _model
                                                            .unfocusNode
                                                            .canRequestFocus
                                                        ? FocusScope.of(context)
                                                            .requestFocus(_model
                                                                .unfocusNode)
                                                        : FocusScope.of(context)
                                                            .unfocus(),
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
                                              '[Insert Link]',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                          ),
                                        if (FFAppState().addVideoLink != '')
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
                                                    onTap: () => _model
                                                            .unfocusNode
                                                            .canRequestFocus
                                                        ? FocusScope.of(context)
                                                            .requestFocus(_model
                                                                .unfocusNode)
                                                        : FocusScope.of(context)
                                                            .unfocus(),
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
                                              'Contains URL',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFF129575),
                                                        letterSpacing: 0.0,
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
                                child: Container(
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: TextFormField(
                                    controller: _model
                                        .attributionTextfieldTextController,
                                    focusNode:
                                        _model.attributionTextfieldFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.attributionTextfieldTextController',
                                      Duration(milliseconds: 2000),
                                      () async {
                                        await widget.mealRef!
                                            .update(createMealRecipeRecordData(
                                          attribution: _model
                                              .attributionTextfieldTextController
                                              .text,
                                        ));
                                        if (_model
                                                .attributionTextfieldTextController
                                                .text ==
                                            currentUserDisplayName) {
                                          setState(() {
                                            _model.originalRecipeChkboxValue =
                                                true;
                                          });
                                        } else {
                                          setState(() {
                                            _model.originalRecipeChkboxValue =
                                                false;
                                          });
                                        }
                                      },
                                    ),
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: '[Attribution]',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLength: 35,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    buildCounter: (context,
                                            {required currentLength,
                                            required isFocused,
                                            maxLength}) =>
                                        null,
                                    validator: _model
                                        .attributionTextfieldTextControllerValidator
                                        .asValidator(context),
                                  ),
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
                                      value: _model
                                          .originalRecipeChkboxValue ??= false,
                                      onChanged: (newValue) async {
                                        setState(() =>
                                            _model.originalRecipeChkboxValue =
                                                newValue!);
                                        if (newValue!) {
                                          if (_model
                                                  .attributionTextfieldTextController
                                                  .text ==
                                              '') {
                                            setState(() {
                                              FFAppState().attributionTemp = '';
                                            });
                                          } else {
                                            setState(() {
                                              FFAppState().attributionTemp = _model
                                                  .attributionTextfieldTextController
                                                  .text;
                                            });
                                          }

                                          setState(() {
                                            _model
                                                .attributionTextfieldTextController
                                                ?.text = currentUserDisplayName;
                                          });

                                          await widget.mealRef!.update(
                                              createMealRecipeRecordData(
                                            attribution: _model
                                                .attributionTextfieldTextController
                                                .text,
                                          ));
                                        } else {
                                          setState(() {
                                            _model.attributionTextfieldTextController
                                                    ?.text =
                                                FFAppState().attributionTemp;
                                          });

                                          await widget.mealRef!.update(
                                              createMealRecipeRecordData(
                                            attribution: _model
                                                .attributionTextfieldTextController
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
                                              _model.originalRecipeChkboxValue !=
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
                                              onTap: () => _model.unfocusNode
                                                      .canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _model.unfocusNode)
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
                                            FFAppState().estimatedTimeSpinner,
                                      ));
                                    },
                                    child: Text(
                                      dateTimeFormat('Hm',
                                          FFAppState().estimatedTimeSpinner),
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
                                      _model.expandableExpandableController,
                                  child: ExpandablePanel(
                                    header: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(),
                                      child: FlutterFlowDropDown<String>(
                                        multiSelectController: _model
                                                .recipeCategoryDropdownValueController ??=
                                            FormFieldController<
                                                List<String>>(_model
                                                    .recipeCategoryDropdownValue ??=
                                                List<String>.from(
                                          FFAppState().staticStringList ?? [],
                                        )),
                                        options: FFAppState().recipeCategories,
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
                                          setState(() => _model
                                                  .recipeCategoryDropdownValue =
                                              val);
                                          setState(() {
                                            FFAppState().chosenRecipeCategory =
                                                _model
                                                    .recipeCategoryDropdownValue!
                                                    .toList()
                                                    .cast<String>();
                                          });

                                          await widget.mealRef!.update({
                                            ...mapToFirestore(
                                              {
                                                'category': FFAppState()
                                                    .chosenRecipeCategory,
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
                                              visible: FFAppState()
                                                      .chosenRecipeCategory
                                                      .length !=
                                                  0,
                                              child: Builder(
                                                builder: (context) {
                                                  final choosenRecipeCategoryListView =
                                                      FFAppState()
                                                          .chosenRecipeCategory
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
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: FlutterFlowButtonTabBar(
                                    useToggleButtonStyle: false,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          fontSize: 11.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          lineHeight: 1.5,
                                        ),
                                    unselectedLabelStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontSize: 11.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              lineHeight: 1.5,
                                            ),
                                    labelColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    unselectedLabelColor: Color(0xFF129575),
                                    backgroundColor: Color(0xFF129575),
                                    unselectedBackgroundColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    unselectedBorderColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderWidth: 0.0,
                                    borderRadius: 8.0,
                                    elevation: 0.0,
                                    buttonMargin:
                                        EdgeInsetsDirectional.fromSTEB(
                                            2.0, 0.0, 4.0, 0.0),
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Tab(
                                        text: 'Ingredient',
                                      ),
                                      Tab(
                                        text: 'Procedure',
                                      ),
                                    ],
                                    controller: _model.tabBarController,
                                    onTap: (i) async {
                                      [() async {}, () async {}][i]();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                        child: SingleChildScrollView(
                                          controller:
                                              _model.ingredientParentColumn,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final ingredientLocalList =
                                                      FFAppState()
                                                          .ingredientNewList
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
                                                                width: (FFAppState().isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_model.ingredientNameFocusNode?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_model.quantityTextFocusNode?.hasFocus ?? false) ==
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
                                                                    if ((FFAppState().isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_model.ingredientNameFocusNode?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_model.quantityTextFocusNode?.hasFocus ?? false) ==
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
                                                                            if ((_model.ingredientNameTextController.text == '') &&
                                                                                (_model.quantityTextTextController.text == '')) {
                                                                              await _model.ingredientParentColumn?.animateTo(
                                                                                _model.ingredientParentColumn!.position.maxScrollExtent,
                                                                                duration: Duration(milliseconds: 100),
                                                                                curve: Curves.ease,
                                                                              );
                                                                              setState(() {
                                                                                FFAppState().removeAtIndexFromIngredientNewList(ingredientLocalListIndex);
                                                                                FFAppState().isIngredientInfoToBeEdited = true;
                                                                              });

                                                                              await addRecipeScreenMealRecipeRecord.reference.update({
                                                                                ...mapToFirestore(
                                                                                  {
                                                                                    'ingredient': getIngredientListFirestoreData(
                                                                                      FFAppState().ingredientNewList,
                                                                                    ),
                                                                                  },
                                                                                ),
                                                                              });
                                                                              setState(() {
                                                                                _model.ingredientNameTextController?.text = ingredientLocalListItem.ingrName;
                                                                              });
                                                                              setState(() {
                                                                                _model.quantityTextTextController?.text = ingredientLocalListItem.ingrQuantity;
                                                                              });
                                                                              setState(() {
                                                                                _model.measurementDropdownValueController?.value = ingredientLocalListItem.ingrUnit;
                                                                              });
                                                                            } else {
                                                                              if ((_model.ingredientNameTextController.text != '') && (_model.quantityTextTextController.text == '')) {
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
                                                                                if ((_model.quantityTextTextController.text != '') && (_model.ingredientNameTextController.text == '')) {
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
                                                                                  if ((_model.ingredientNameTextController.text != '') && (_model.quantityTextTextController.text != '')) {
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
                                                                    if ((FFAppState().isIngredientInfoToBeEdited ==
                                                                            false) &&
                                                                        (((_model.ingredientNameFocusNode?.hasFocus ?? false) ==
                                                                                false) &&
                                                                            ((_model.quantityTextFocusNode?.hasFocus ?? false) ==
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
                                                                              FFAppState().removeAtIndexFromIngredientNewList(ingredientLocalListIndex);
                                                                            });

                                                                            await addRecipeScreenMealRecipeRecord.reference.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'ingredient': getIngredientListFirestoreData(
                                                                                    FFAppState().ingredientNewList,
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
                                                    scrollController: _model
                                                        .listviewIngredient,
                                                    onReorder: (int
                                                            reorderableOldIndex,
                                                        int reorderableNewIndex) async {
                                                      _model.newIngredientOrder =
                                                          await actions
                                                              .onReorderIngredient(
                                                        reorderableOldIndex,
                                                        reorderableNewIndex,
                                                        ingredientLocalList
                                                            .toList(),
                                                      );

                                                      await widget.mealRef!
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'ingredient':
                                                                getIngredientListFirestoreData(
                                                              _model
                                                                  .newIngredientOrder,
                                                            ),
                                                          },
                                                        ),
                                                      });
                                                      setState(() {
                                                        FFAppState()
                                                                .ingredientNewList =
                                                            _model
                                                                .newIngredientOrder!
                                                                .toList()
                                                                .cast<
                                                                    IngredientStruct>();
                                                        FFAppState()
                                                                .wasIngredientListReordered =
                                                            true;
                                                      });

                                                      setState(() {});
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
                                                                  controller: _model
                                                                      .ingredientNameTextController,
                                                                  focusNode: _model
                                                                      .ingredientNameFocusNode,
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
                                                                  validator: _model
                                                                      .ingredientNameTextControllerValidator
                                                                      .asValidator(
                                                                          context),
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
                                                                controller: _model
                                                                    .quantityTextTextController,
                                                                focusNode: _model
                                                                    .quantityTextFocusNode,
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
                                                                validator: _model
                                                                    .quantityTextTextControllerValidator
                                                                    .asValidator(
                                                                        context),
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
                                                                  controller: _model
                                                                          .measurementDropdownValueController ??=
                                                                      FormFieldController<
                                                                          String>(
                                                                    _model
                                                                        .measurementDropdownValue ??= FFAppState().isIngredientInfoToBeEdited ==
                                                                            true
                                                                        ? FFAppState()
                                                                            .ingredientInfoEdited
                                                                            .ingrUnit
                                                                        : 'pc/s',
                                                                  ),
                                                                  options:
                                                                      FFAppState()
                                                                          .metricAndImperial,
                                                                  onChanged: (val) =>
                                                                      setState(() =>
                                                                          _model.measurementDropdownValue =
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
                                                                  hintText: FFAppState()
                                                                              .isIngredientInfoToBeEdited ==
                                                                          true
                                                                      ? FFAppState()
                                                                          .ingredientInfoEdited
                                                                          .ingrUnit
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
                                              if (FFAppState()
                                                      .isIngredientInfoToBeEdited ==
                                                  false)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 0.0, 64.0),
                                                  child: FFButtonWidget(
                                                    onPressed: () {
                                                      if (_model
                                                              .ingredientNameTextController
                                                              .text ==
                                                          '') {
                                                        return true;
                                                      } else if (_model
                                                              .quantityTextTextController
                                                              .text ==
                                                          '') {
                                                        return true;
                                                      } else {
                                                        return false;
                                                      }
                                                    }()
                                                        ? null
                                                        : () async {
                                                            if ((_model.ingredientNameTextController
                                                                        .text !=
                                                                    '') &&
                                                                (_model.quantityTextTextController
                                                                        .text !=
                                                                    '')) {
                                                              setState(() {
                                                                FFAppState()
                                                                        .ingredientJson =
                                                                    <String,
                                                                        dynamic>{
                                                                  'ingr_name':
                                                                      _model
                                                                          .ingredientNameTextController
                                                                          .text,
                                                                  'ingr_quantity':
                                                                      _model
                                                                          .quantityTextTextController
                                                                          .text,
                                                                  'ingr_unit':
                                                                      _model
                                                                          .measurementDropdownValue,
                                                                };
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
                                                                              FFAppState().ingredientJson),
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
                                                                FFAppState().addToIngredientNewList(
                                                                    IngredientStruct.maybeFromMap(
                                                                        FFAppState()
                                                                            .ingredientJson)!);
                                                              });
                                                              setState(() {
                                                                _model.measurementDropdownValueController
                                                                        ?.value =
                                                                    'pc/s';
                                                              });
                                                              setState(() {
                                                                _model
                                                                    .quantityTextTextController
                                                                    ?.clear();
                                                                _model
                                                                    .ingredientNameTextController
                                                                    ?.clear();
                                                              });
                                                            } else {
                                                              if (_model
                                                                      .ingredientNameTextController
                                                                      .text ==
                                                                  '') {
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
                                                                if (_model
                                                                        .quantityTextTextController
                                                                        .text ==
                                                                    '') {
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

                                                            await _model
                                                                .ingredientParentColumn
                                                                ?.animateTo(
                                                              _model
                                                                  .ingredientParentColumn!
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      100),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                            setState(() {
                                                              FFAppState()
                                                                      .tempHideWidget =
                                                                  true;
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
                                                      color: (_model.ingredientNameTextController
                                                                      .text !=
                                                                  '') &&
                                                              (_model.quantityTextTextController
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
                                              if (FFAppState()
                                                      .isIngredientInfoToBeEdited ==
                                                  true)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 0.0, 64.0),
                                                  child: FFButtonWidget(
                                                    onPressed: () async {
                                                      // Check if there's any changes with the ingredient name value
                                                      if (_model
                                                              .ingredientNameTextController
                                                              .text ==
                                                          '') {
                                                        // Check if there's any changes with the quantity text value
                                                        if (_model
                                                                .quantityTextTextController
                                                                .text ==
                                                            '') {
                                                          // Check if the dropdown value is equal to the stored value of the choosen data to be edited.
                                                          if (_model
                                                                  .measurementDropdownValue ==
                                                              FFAppState()
                                                                  .ingredientInfoEdited
                                                                  .ingrUnit) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrName,
                                                                'ingr_quantity':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrQuantity,
                                                                'ingr_unit':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrUnit,
                                                              };
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrName,
                                                                'ingr_quantity':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrQuantity,
                                                                'ingr_unit': _model
                                                                    .measurementDropdownValue,
                                                              };
                                                            });
                                                          }
                                                        } else {
                                                          if (_model
                                                                  .measurementDropdownValue ==
                                                              FFAppState()
                                                                  .ingredientInfoEdited
                                                                  .ingrUnit) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrName,
                                                                'ingr_quantity':
                                                                    _model
                                                                        .quantityTextTextController
                                                                        .text,
                                                                'ingr_unit':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrUnit,
                                                              };
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrName,
                                                                'ingr_quantity':
                                                                    _model
                                                                        .quantityTextTextController
                                                                        .text,
                                                                'ingr_unit': _model
                                                                    .measurementDropdownValue,
                                                              };
                                                            });
                                                          }
                                                        }
                                                      } else {
                                                        if (_model
                                                                .quantityTextTextController
                                                                .text ==
                                                            '') {
                                                          if (_model
                                                                  .measurementDropdownValue ==
                                                              FFAppState()
                                                                  .ingredientInfoEdited
                                                                  .ingrUnit) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name': _model
                                                                    .ingredientNameTextController
                                                                    .text,
                                                                'ingr_quantity':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrQuantity,
                                                                'ingr_unit':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrUnit,
                                                              };
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name': _model
                                                                    .ingredientNameTextController
                                                                    .text,
                                                                'ingr_quantity':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrQuantity,
                                                                'ingr_unit': _model
                                                                    .measurementDropdownValue,
                                                              };
                                                            });
                                                          }
                                                        } else {
                                                          if (_model
                                                                  .measurementDropdownValue ==
                                                              FFAppState()
                                                                  .ingredientInfoEdited
                                                                  .ingrUnit) {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name': _model
                                                                    .ingredientNameTextController
                                                                    .text,
                                                                'ingr_quantity':
                                                                    _model
                                                                        .quantityTextTextController
                                                                        .text,
                                                                'ingr_unit':
                                                                    FFAppState()
                                                                        .ingredientInfoEdited
                                                                        .ingrUnit,
                                                              };
                                                            });
                                                          } else {
                                                            // Do the action chain if there were no changes on the following fields:
                                                            // - Ingredient Name
                                                            // - Quantity
                                                            // - Unit
                                                            setState(() {
                                                              FFAppState()
                                                                      .ingredientJson =
                                                                  <String,
                                                                      dynamic>{
                                                                'ingr_name': _model
                                                                    .ingredientNameTextController
                                                                    .text,
                                                                'ingr_quantity':
                                                                    _model
                                                                        .quantityTextTextController
                                                                        .text,
                                                                'ingr_unit': _model
                                                                    .measurementDropdownValue,
                                                              };
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
                                                                          FFAppState()
                                                                              .ingredientJson),
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
                                                        _model
                                                            .measurementDropdownValueController
                                                            ?.value = 'pc/s';
                                                      });
                                                      setState(() {
                                                        FFAppState().addToIngredientNewList(
                                                            IngredientStruct
                                                                .maybeFromMap(
                                                                    FFAppState()
                                                                        .ingredientJson)!);
                                                      });
                                                      setState(() {
                                                        FFAppState()
                                                                .isIngredientInfoToBeEdited =
                                                            false;
                                                      });
                                                      setState(() {
                                                        _model
                                                            .quantityTextTextController
                                                            ?.clear();
                                                        _model
                                                            .ingredientNameTextController
                                                            ?.clear();
                                                      });
                                                      await _model
                                                          .ingredientParentColumn
                                                          ?.animateTo(
                                                        _model
                                                            .ingredientParentColumn!
                                                            .position
                                                            .maxScrollExtent,
                                                        duration: Duration(
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
                                          controller: _model.stepsParentColumn,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final procedureListview =
                                                      FFAppState()
                                                          .procedureList
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
                                                                width: (FFAppState().isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_model.stepsTextfieldFocusNode?.hasFocus ??
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
                                                                    if ((FFAppState().isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_model.stepsTextfieldFocusNode?.hasFocus ??
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
                                                                              if (_model.stepsTextfieldTextController.text == '') {
                                                                                await _model.stepsParentColumn?.animateTo(
                                                                                  _model.stepsParentColumn!.position.maxScrollExtent,
                                                                                  duration: Duration(milliseconds: 100),
                                                                                  curve: Curves.ease,
                                                                                );
                                                                                if (FFAppState().wasProcedureListReordered == true) {
                                                                                  setState(() {
                                                                                    FFAppState().procedureJson = _model.newProcedureList![procedureListviewIndex];
                                                                                    FFAppState().isProcedureItemEdited = true;
                                                                                  });
                                                                                  setState(() {
                                                                                    FFAppState().removeFromProcedureList(_model.newProcedureList![procedureListviewIndex]);
                                                                                    FFAppState().wasProcedureListReordered = false;
                                                                                  });
                                                                                } else {
                                                                                  setState(() {
                                                                                    FFAppState().procedureJson = FFAppState().procedureList[procedureListviewIndex];
                                                                                    FFAppState().isProcedureItemEdited = true;
                                                                                  });
                                                                                  setState(() {
                                                                                    FFAppState().removeFromProcedureList(FFAppState().procedureList[procedureListviewIndex]);
                                                                                  });
                                                                                }

                                                                                await widget.mealRef!.update({
                                                                                  ...mapToFirestore(
                                                                                    {
                                                                                      'procedure': getProcedureListFirestoreData(
                                                                                        FFAppState().procedureList,
                                                                                      ),
                                                                                    },
                                                                                  ),
                                                                                });
                                                                                setState(() {
                                                                                  _model.stepsTextfieldTextController?.text = FFAppState().procedureJson.steps;
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
                                                                    if ((FFAppState().isProcedureItemEdited ==
                                                                            false) &&
                                                                        ((_model.stepsTextfieldFocusNode?.hasFocus ??
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
                                                                            if (FFAppState().wasProcedureListReordered ==
                                                                                true) {
                                                                              setState(() {
                                                                                FFAppState().removeFromProcedureList(_model.newProcedureList![procedureListviewIndex]);
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                FFAppState().removeFromProcedureList(FFAppState().procedureList[procedureListviewIndex]);
                                                                              });
                                                                            }

                                                                            await widget.mealRef!.update({
                                                                              ...mapToFirestore(
                                                                                {
                                                                                  'procedure': getProcedureListFirestoreData(
                                                                                    FFAppState().procedureList,
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
                                                    scrollController: _model
                                                        .listViewController,
                                                    onReorder: (int
                                                            reorderableOldIndex,
                                                        int reorderableNewIndex) async {
                                                      _model.newProcedureList =
                                                          await actions
                                                              .onReorderProcedure(
                                                        reorderableOldIndex,
                                                        reorderableNewIndex,
                                                        procedureListview
                                                            .toList(),
                                                      );

                                                      await widget.mealRef!
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'procedure':
                                                                getProcedureListFirestoreData(
                                                              _model
                                                                  .newProcedureList,
                                                            ),
                                                          },
                                                        ),
                                                      });
                                                      setState(() {
                                                        FFAppState()
                                                                .procedureList =
                                                            _model
                                                                .newProcedureList!
                                                                .toList()
                                                                .cast<
                                                                    ProcedureStruct>();
                                                        FFAppState()
                                                                .wasProcedureListReordered =
                                                            true;
                                                      });

                                                      setState(() {});
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
                                                  height: 168.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    controller: _model
                                                        .columnController2,
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
                                                            controller: _model
                                                                .stepsTextfieldTextController,
                                                            focusNode: _model
                                                                .stepsTextfieldFocusNode,
                                                            autofocus: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: (_model
                                                                              .stepsTextfieldFocusNode
                                                                              ?.hasFocus ??
                                                                          false) !=
                                                                      true
                                                                  ? 'What are the steps to make this meal?'
                                                                  : 'Step ${functions.incrementSteps(FFAppState().procedureList.length).toString()}',
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
                                                            validator: _model
                                                                .stepsTextfieldTextControllerValidator
                                                                .asValidator(
                                                                    context),
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
                                                              if (_model
                                                                      .stepsTextfieldTextController
                                                                      .text !=
                                                                  '') {
                                                                setState(() {
                                                                  FFAppState()
                                                                          .stepsJson =
                                                                      <String,
                                                                          dynamic>{
                                                                    'steps': _model
                                                                        .stepsTextfieldTextController
                                                                        .text,
                                                                  };
                                                                });
                                                                setState(() {
                                                                  FFAppState().addToProcedureList(
                                                                      ProcedureStruct.maybeFromMap(
                                                                          FFAppState()
                                                                              .stepsJson)!);
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
                                                                            ProcedureStruct.maybeFromMap(FFAppState().stepsJson),
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
                                                                  _model
                                                                      .stepsTextfieldTextController
                                                                      ?.clear();
                                                                });
                                                                setState(() {
                                                                  FFAppState()
                                                                          .isProcedureItemEdited =
                                                                      false;
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
