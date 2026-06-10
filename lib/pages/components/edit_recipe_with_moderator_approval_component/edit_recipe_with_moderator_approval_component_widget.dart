import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Notice shown after a recipe edit is saved but still needs moderator approval.
class EditRecipeWithModeratorApprovalComponentWidget extends StatelessWidget {
  const EditRecipeWithModeratorApprovalComponentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
