import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'no_meal_category_found_model.dart';
export 'no_meal_category_found_model.dart';

class NoMealCategoryFoundWidget extends StatefulWidget {
  const NoMealCategoryFoundWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String? title;
  final String? message;

  @override
  State<NoMealCategoryFoundWidget> createState() =>
      _NoMealCategoryFoundWidgetState();
}

class _NoMealCategoryFoundWidgetState extends State<NoMealCategoryFoundWidget> {
  late NoMealCategoryFoundModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoMealCategoryFoundModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 72.0,
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              widget.title,
              'title',
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Roboto',
                  letterSpacing: 0.0,
                ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              widget.message,
              'message',
            ),
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
