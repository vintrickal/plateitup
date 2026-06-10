import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Placeholder shown when a meal-category filter returns no recipes (and on
/// the search results page when the query has no hits). Pure presentation —
/// no state, no callbacks. Used to ship as a `StatefulWidget` with an empty
/// FlutterFlow model; the Cubit conversion strips that.
class NoMealCategoryFoundWidget extends StatelessWidget {
  const NoMealCategoryFoundWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 72.0,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          child: Text(
            valueOrDefault<String>(title, 'title'),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Roboto',
                  letterSpacing: 0.0,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: Text(
            valueOrDefault<String>(message, 'message'),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Poppins',
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    );
  }
}
