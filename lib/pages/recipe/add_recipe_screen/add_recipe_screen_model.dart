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
import 'add_recipe_screen_widget.dart' show AddRecipeScreenWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddRecipeScreenModel extends FlutterFlowModel<AddRecipeScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Column widget.
  ScrollController? columnController1;
  // State field(s) for switch_status widget.
  bool? switchStatusValue;
  // State field(s) for title widget.
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;
  String? Function(BuildContext, String?)? titleTextControllerValidator;
  // State field(s) for attribution-textfield widget.
  FocusNode? attributionTextfieldFocusNode;
  TextEditingController? attributionTextfieldTextController;
  String? Function(BuildContext, String?)?
      attributionTextfieldTextControllerValidator;
  // State field(s) for original-recipe-chkbox widget.
  bool? originalRecipeChkboxValue;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for recipe-category-dropdown widget.
  List<String>? recipeCategoryDropdownValue;
  FormFieldController<List<String>>? recipeCategoryDropdownValueController;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for ingredient-parent-column widget.
  ScrollController? ingredientParentColumn;
  // State field(s) for listview-ingredient widget.
  ScrollController? listviewIngredient;
  // Stores action output result for [Custom Action - onReorderIngredient] action in listview-ingredient widget.
  List<IngredientStruct>? newIngredientOrder;
  // State field(s) for ingredient-name widget.
  FocusNode? ingredientNameFocusNode;
  TextEditingController? ingredientNameTextController;
  String? Function(BuildContext, String?)?
      ingredientNameTextControllerValidator;
  // State field(s) for quantity-text widget.
  FocusNode? quantityTextFocusNode;
  TextEditingController? quantityTextTextController;
  String? Function(BuildContext, String?)? quantityTextTextControllerValidator;
  // State field(s) for measurement-dropdown widget.
  String? measurementDropdownValue;
  FormFieldController<String>? measurementDropdownValueController;
  // State field(s) for steps-parent-column widget.
  ScrollController? stepsParentColumn;
  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // Stores action output result for [Custom Action - onReorderProcedure] action in ListView widget.
  List<ProcedureStruct>? newProcedureList;
  // State field(s) for Column widget.
  ScrollController? columnController2;
  // State field(s) for steps-textfield widget.
  FocusNode? stepsTextfieldFocusNode;
  TextEditingController? stepsTextfieldTextController;
  String? Function(BuildContext, String?)?
      stepsTextfieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    columnController1 = ScrollController();
    ingredientParentColumn = ScrollController();
    listviewIngredient = ScrollController();
    stepsParentColumn = ScrollController();
    listViewController = ScrollController();
    columnController2 = ScrollController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    columnController1?.dispose();
    titleFocusNode?.dispose();
    titleTextController?.dispose();

    attributionTextfieldFocusNode?.dispose();
    attributionTextfieldTextController?.dispose();

    expandableExpandableController.dispose();
    tabBarController?.dispose();
    ingredientParentColumn?.dispose();
    listviewIngredient?.dispose();
    ingredientNameFocusNode?.dispose();
    ingredientNameTextController?.dispose();

    quantityTextFocusNode?.dispose();
    quantityTextTextController?.dispose();

    stepsParentColumn?.dispose();
    listViewController?.dispose();
    columnController2?.dispose();
    stepsTextfieldFocusNode?.dispose();
    stepsTextfieldTextController?.dispose();
  }
}
