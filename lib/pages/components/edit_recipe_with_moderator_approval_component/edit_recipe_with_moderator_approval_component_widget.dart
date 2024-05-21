import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_recipe_with_moderator_approval_component_model.dart';
export 'edit_recipe_with_moderator_approval_component_model.dart';

class EditRecipeWithModeratorApprovalComponentWidget extends StatefulWidget {
  const EditRecipeWithModeratorApprovalComponentWidget({super.key});

  @override
  State<EditRecipeWithModeratorApprovalComponentWidget> createState() =>
      _EditRecipeWithModeratorApprovalComponentWidgetState();
}

class _EditRecipeWithModeratorApprovalComponentWidgetState
    extends State<EditRecipeWithModeratorApprovalComponentWidget> {
  late EditRecipeWithModeratorApprovalComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(
        context, () => EditRecipeWithModeratorApprovalComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Text(
          'Changes have been saved, but they still need moderator approval.',
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
