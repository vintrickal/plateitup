import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'go_to_history_component_model.dart';
export 'go_to_history_component_model.dart';

class GoToHistoryComponentWidget extends StatefulWidget {
  const GoToHistoryComponentWidget({
    super.key,
    required this.pairedUserRef,
  });

  final DocumentReference? pairedUserRef;

  @override
  State<GoToHistoryComponentWidget> createState() =>
      _GoToHistoryComponentWidgetState();
}

class _GoToHistoryComponentWidgetState
    extends State<GoToHistoryComponentWidget> {
  late GoToHistoryComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GoToHistoryComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PairedUserRecord>(
      stream: PairedUserRecord.getDocument(widget.pairedUserRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).success,
                ),
              ),
            ),
          );
        }
        final containerPairedUserRecord = snapshot.data!;
        return Container(
          width: 250.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(),
                child: Text(
                  'Your review has been saved. You can find it in \"History\"',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  context.pushNamed(
                    'profile_screen',
                    queryParameters: {
                      'userDocRef': serializeParam(
                        containerPairedUserRecord.sender,
                        ParamType.DocumentReference,
                      ),
                      'partnerRef': serializeParam(
                        containerPairedUserRecord.recipient,
                        ParamType.DocumentReference,
                      ),
                      'tabIndex': serializeParam(
                        2,
                        ParamType.int,
                      ),
                    }.withoutNulls,
                    extra: <String, dynamic>{
                      kTransitionInfoKey: TransitionInfo(
                        hasTransition: true,
                        transitionType: PageTransitionType.fade,
                        duration: Duration(milliseconds: 0),
                      ),
                    },
                  );
                },
                text: 'Go to History',
                options: FFButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).success,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(SizedBox(height: 16.0)),
          ),
        );
      },
    );
  }
}
