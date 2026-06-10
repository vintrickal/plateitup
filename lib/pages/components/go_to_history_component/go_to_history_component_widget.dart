import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

/// Toast-style dialog confirming a partner review was saved. The button jumps
/// to the History tab of the user's profile.
class GoToHistoryComponentWidget extends StatelessWidget {
  const GoToHistoryComponentWidget({
    super.key,
    required this.pairedUserRef,
  });

  final DocumentReference? pairedUserRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PairedUserRecord>(
      stream: PairedUserRecord.getDocument(pairedUserRef!),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your review has been saved. You can find it in \"History\"',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
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
                      kTransitionInfoKey: const TransitionInfo(
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
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 0.0, 12.0, 0.0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).success,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ].divide(const SizedBox(height: 16.0)),
          ),
        );
      },
    );
  }
}
