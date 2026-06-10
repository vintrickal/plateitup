import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';

/// Admin reminder shown on the deletion-flow screens. Pure presentation.
class DeletionReminderWidget extends StatelessWidget {
  const DeletionReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 8.0),
        child: Container(
          width: 350.0,
          height: 150.0,
          constraints: const BoxConstraints(maxWidth: 570.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE0E3E7)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Reminder:\n1. Find email in Firebase Auth and Delete it.\n2. Go to Firebase Storage and delete the uploaded file',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
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
