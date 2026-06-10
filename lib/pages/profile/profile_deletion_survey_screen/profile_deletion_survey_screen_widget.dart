import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/pages/components/request_account_deletion_component/request_account_deletion_component_widget.dart';

/// Account-deletion reason survey: collects a radio-selected reason (plus
/// optional free-text "Other"), confirms with an expandable warning panel,
/// and writes a [DeleteAccountRequestRecord] for moderator review.
class ProfileDeletionSurveyScreenWidget extends StatefulWidget {
  const ProfileDeletionSurveyScreenWidget({super.key});

  @override
  State<ProfileDeletionSurveyScreenWidget> createState() =>
      _ProfileDeletionSurveyScreenWidgetState();
}

class _ProfileDeletionSurveyScreenWidgetState
    extends State<ProfileDeletionSurveyScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _unfocusNode = FocusNode();
  final TextEditingController _otherTxtfieldTextController =
      TextEditingController();
  final FocusNode _otherTxtfieldFocusNode = FocusNode();
  FormFieldController<String>? _rdBtnOptionsValueController;
  late final ExpandableController _expandableExpandableController =
      ExpandableController(initialExpanded: true);

  String? get _rdBtnOptionsValue => _rdBtnOptionsValueController?.value;

  @override
  void dispose() {
    _unfocusNode.dispose();
    _otherTxtfieldFocusNode.dispose();
    _otherTxtfieldTextController.dispose();
    _expandableExpandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).success,
          automaticallyImplyLeading: false,
          leading: Visibility(
            visible: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            ),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ),
          title: Text(
            'Delete Account',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Roboto',
                  color: Colors.white,
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REQUEST FOR ACCOUNT DELETION',
                  style: FlutterFlowTheme.of(context).headlineLarge.override(
                        fontFamily: 'Roboto',
                        color: FlutterFlowTheme.of(context).error,
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  'Why are you deleting your account? Your feedback will greatly assist us in improving the app',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                      ),
                ),
                FlutterFlowRadioButton(
                  options: const [
                    'The app is not functioning properly',
                    'I am unhappy with the user experience',
                    'I have a privacy concern',
                    'Other'
                  ],
                  onChanged: (val) => setState(() {}),
                  controller: _rdBtnOptionsValueController ??=
                      FormFieldController<String>(
                          'The app is not functioning properly'),
                  optionHeight: 32.0,
                  textStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Poppins',
                            letterSpacing: 0.0,
                          ),
                  selectedTextStyle:
                      FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                  buttonPosition: RadioButtonPosition.left,
                  direction: Axis.vertical,
                  radioButtonColor: FlutterFlowTheme.of(context).error,
                  inactiveRadioButtonColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  toggleable: false,
                  horizontalAlignment: WrapAlignment.start,
                  verticalAlignment: WrapCrossAlignment.start,
                ),
                if (_rdBtnOptionsValue == 'Other')
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        4.0, 0.0, 4.0, 0.0),
                    child: TextFormField(
                      controller: _otherTxtfieldTextController,
                      focusNode: _otherTxtfieldFocusNode,
                      autofocus: false,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.done,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.0,
                                ),
                        hintText: 'Enter other reason(s) here.',
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).success,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Poppins',
                            letterSpacing: 0.0,
                          ),
                      maxLength: 500,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                if (_rdBtnOptionsValue != '')
                  Text(
                    'Thank you for your time on the app. Before you leave, here are a few reminders. ',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Poppins',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                if (_rdBtnOptionsValue != '')
                  Container(
                    width: double.infinity,
                    color: const Color(0x00000000),
                    child: ExpandableNotifier(
                      controller: _expandableExpandableController,
                      child: ExpandablePanel(
                        header: Text(
                          'Deleting your account will:',
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        collapsed: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 24.0,
                                ),
                                Text(
                                  'Remove your account and access to the app.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 24.0,
                                ),
                                Text(
                                  'Erase your information.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 24.0,
                                ),
                                Text(
                                  'Your account cannot be restored.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ].divide(const SizedBox(width: 8.0)),
                            ),
                          ].divide(const SizedBox(height: 8.0)),
                        ),
                        expanded: Container(),
                        theme: const ExpandableThemeData(
                          tapHeaderToExpand: true,
                          tapBodyToExpand: false,
                          tapBodyToCollapse: false,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: true,
                        ),
                      ),
                    ),
                  ),
                if ((_rdBtnOptionsValue != '') &&
                    responsiveVisibility(
                      context: context,
                      desktop: false,
                    ))
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Builder(
                      builder: (context) => FFButtonWidget(
                        onPressed: ((_rdBtnOptionsValue == 'Other') &&
                                (_otherTxtfieldTextController.text == ''))
                            ? null
                            : () async {
                                final deleteRequestItem =
                                    await queryDeleteAccountRequestRecordOnce(
                                  queryBuilder:
                                      (deleteAccountRequestRecord) =>
                                          deleteAccountRequestRecord.where(
                                    'user_id',
                                    isEqualTo: currentUserReference,
                                  ),
                                  singleRecord: true,
                                ).then((s) => s.firstOrNull);
                                if (!context.mounted) return;
                                if (deleteRequestItem != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'You already have an active request.',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                      ),
                                      duration: const Duration(
                                          milliseconds: 4000),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .secondary,
                                    ),
                                  );
                                } else {
                                  await DeleteAccountRequestRecord.collection
                                      .doc()
                                      .set({
                                    ...createDeleteAccountRequestRecordData(
                                      userId: currentUserReference,
                                      reason: _rdBtnOptionsValue,
                                      otherReason:
                                          _otherTxtfieldTextController.text,
                                    ),
                                    ...mapToFirestore(
                                      {
                                        'date_requested':
                                            FieldValue.serverTimestamp(),
                                      },
                                    ),
                                  });
                                  if (!context.mounted) return;
                                  context.safePop();
                                  await showDialog(
                                    context: context,
                                    builder: (dialogContext) {
                                      return Dialog(
                                        elevation: 0,
                                        insetPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        alignment: const AlignmentDirectional(
                                                0.0, 0.0)
                                            .resolve(
                                                Directionality.of(context)),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _unfocusNode.canRequestFocus
                                                  ? FocusScope.of(context)
                                                      .requestFocus(
                                                          _unfocusNode)
                                                  : FocusScope.of(context)
                                                      .unfocus(),
                                          child: const SizedBox(
                                            height: 100.0,
                                            width: 350.0,
                                            child:
                                                RequestAccountDeletionComponentWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                        text: 'Proceed',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: (_rdBtnOptionsValue == 'Other') &&
                                  (_otherTxtfieldTextController.text == '')
                              ? FlutterFlowTheme.of(context).secondaryText
                              : FlutterFlowTheme.of(context).success,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
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
                    ),
                  ),
              ]
                  .divide(const SizedBox(height: 16.0))
                  .addToStart(const SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
