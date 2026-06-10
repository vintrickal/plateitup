import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

/// Empty-state shown when a recipe search yields no results.
class NoSearchResultsComponentWidget extends StatelessWidget {
  const NoSearchResultsComponentWidget({
    super.key,
    required this.searchItemName,
  });

  final String? searchItemName;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: FlutterFlowTheme.of(context).error,
            size: 72.0,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: Text(
              'No Results Found',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Roboto',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              'There are currently no recipes for \"${searchItemName}\"',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
