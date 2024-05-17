import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'no_search_results_component_model.dart';
export 'no_search_results_component_model.dart';

class NoSearchResultsComponentWidget extends StatefulWidget {
  const NoSearchResultsComponentWidget({
    super.key,
    required this.searchItemName,
  });

  final String? searchItemName;

  @override
  State<NoSearchResultsComponentWidget> createState() =>
      _NoSearchResultsComponentWidgetState();
}

class _NoSearchResultsComponentWidgetState
    extends State<NoSearchResultsComponentWidget> {
  late NoSearchResultsComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoSearchResultsComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: FlutterFlowTheme.of(context).error,
            size: 72.0,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
            child: Text(
              'No Results Found',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Roboto',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              'There are currently no recipes for \"${widget.searchItemName}\"',
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
