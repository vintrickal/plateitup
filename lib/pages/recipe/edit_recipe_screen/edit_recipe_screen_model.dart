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
import '/pages/components/time_spinner_component/time_spinner_component_widget.dart';
import '/pages/components/upload_image_modal/upload_image_modal_widget.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'edit_recipe_screen_widget.dart' show EditRecipeScreenWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditRecipeScreenModel extends FlutterFlowModel<EditRecipeScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for edit-recipe-column widget.
  ScrollController? editRecipeColumn;
  // State field(s) for switch_status widget.
  bool? switchStatusValue;
  // State field(s) for title-textfield widget.
  FocusNode? titleTextfieldFocusNode;
  TextEditingController? titleTextfieldTextController;
  String? Function(BuildContext, String?)?
      titleTextfieldTextControllerValidator;
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
  // State field(s) for steps-textfield widget.
  FocusNode? stepsTextfieldFocusNode;
  TextEditingController? stepsTextfieldTextController;
  String? Function(BuildContext, String?)?
      stepsTextfieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    editRecipeColumn = ScrollController();
    ingredientParentColumn = ScrollController();
    listviewIngredient = ScrollController();
    stepsParentColumn = ScrollController();
    listViewController = ScrollController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    editRecipeColumn?.dispose();
    titleTextfieldFocusNode?.dispose();
    titleTextfieldTextController?.dispose();

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
    stepsTextfieldFocusNode?.dispose();
    stepsTextfieldTextController?.dispose();
  }
}
