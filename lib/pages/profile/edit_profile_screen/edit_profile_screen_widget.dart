import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/app/app_state.dart' as app;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/email_verification_sent_component/email_verification_sent_component_widget.dart';
import '/pages/components/upload_image_modal/upload_image_modal_widget.dart';
import 'edit_profile_cubit.dart';
import 'edit_profile_state.dart';

/// Edit-profile screen — Cubit conversion.
///
/// [EditProfileCubit] owns the password-visibility toggles, the
/// change-password call, and the change-email/verification call.
/// Text controllers stay widget-local so they can be lazy-initialised with
/// the user's current values from the [StreamBuilder<UsersRecord>] snapshot.
class EditProfileScreenWidget extends StatelessWidget {
  const EditProfileScreenWidget({
    super.key,
    required this.userDocRef,
  });

  final DocumentReference? userDocRef;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: _EditProfileView(userDocRef: userDocRef),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView({required this.userDocRef});

  final DocumentReference? userDocRef;

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Lazy-init in the StreamBuilder builder using `??=`: first build with a
  // snapshot seeds the text from the user record; subsequent builds reuse
  // the same controller so the user's edits aren't blown away on rebuild.
  TextEditingController? _displayNameController;
  TextEditingController? _emailController;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FocusNode _displayNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();

  @override
  void dispose() {
    _displayNameController?.dispose();
    _emailController?.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _displayNameFocus.dispose();
    _emailFocus.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listenWhen: (prev, curr) =>
          prev.lastEventId != curr.lastEventId &&
          curr.changePasswordMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.changePasswordMessage!,
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontSize: 14.0,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      },
      child: BlocBuilder<AppCubit, app.AppState>(
        builder: (context, appState) => BlocBuilder<EditProfileCubit,
            EditProfileState>(builder: (context, editState) {
          return _buildBody(context, editState);
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EditProfileState editState) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(widget.userDocRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).success,
                  ),
                ),
              ),
            ),
          );
        }
        final editProfileScreenUsersRecord = snapshot.data!;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              buttonSize: 48.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 25.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
            title: Text(
              'Edit Profile',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 310.0,
                      child: Stack(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        children: [
                          Container(
                            height: 200.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.network(
                                    editProfileScreenUsersRecord.coverPhotoUrl,
                                    width: double.infinity,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: UploadImageModalWidget(
                                                requestId: 'coverPhotoBanner',
                                                docRefUser: widget.userDocRef,
                                              ),
                                            );
                                          },
                                        ).then((value) => safeSetState(() {}));
                                      },
                                      child: Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          size: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, 1.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 32.0),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 0.0,
                                shape: const CircleBorder(),
                                child: Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: UploadImageModalWidget(
                                              requestId: 'profileBanner',
                                              docRefUser: widget.userDocRef,
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Image.network(
                                              editProfileScreenUsersRecord
                                                  .photoUrl,
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, 1.0),
                                          child: Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              size: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                        child: Text(
                          'All changes are auto-saved except for email',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Your information',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _displayNameController ??=
                                          TextEditingController(
                                        text: editProfileScreenUsersRecord
                                            .displayName,
                                      ),
                                      focusNode: _displayNameFocus,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_displayNameController',
                                        const Duration(milliseconds: 2000),
                                        () async {
                                          await widget.userDocRef!
                                              .update(createUsersRecordData(
                                            displayName:
                                                _displayNameController!.text,
                                          ));
                                        },
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Display Name',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                        hintText: 'Display Name',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.0,
                                          ),
                                      maxLength: 20,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(0.0, 17.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _emailController ??=
                                          TextEditingController(
                                        text:
                                            editProfileScreenUsersRecord.email,
                                      ),
                                      focusNode: _emailFocus,
                                      readOnly:
                                          AppCubit.instance.state.isChangeEmailBtnTapped ==
                                              false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                        hintText: 'Email',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  if (currentUserEmailVerified == false)
                                    AuthUserStreamWidget(
                                      builder: (context) => Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons
                                                .exclamationTriangle,
                                            color: FlutterFlowTheme.of(context)
                                                .warning,
                                            size: 16.0,
                                          ),
                                          Text(
                                            'Email not verified',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
                                ],
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 1.0),
                                child: Builder(
                                  builder: (context) => FFButtonWidget(
                                    onPressed: () async {
                                      // Two-step UX: first tap arms the
                                      // field (read-only → editable), second
                                      // tap submits.
                                      if (!AppCubit.instance.state.isChangeEmailBtnTapped) {
                                        AppCubit.instance.setIsChangeEmailBtnTapped(true);
                                        return;
                                      }
                                      final newEmail =
                                          _emailController?.text ?? '';
                                      if (newEmail.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Email required!'),
                                          ),
                                        );
                                        return;
                                      }
                                      final err = await context
                                          .read<EditProfileCubit>()
                                          .updateEmail(
                                            newEmail: newEmail,
                                            userDocRef: widget.userDocRef!,
                                          );
                                      if (!context.mounted) return;
                                      if (err != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(err)),
                                        );
                                        return;
                                      }
                                      await showDialog<void>(
                                        context: context,
                                        builder: (dialogContext) => Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment:
                                              const AlignmentDirectional(
                                                      0.0, 0.0)
                                                  .resolve(Directionality.of(
                                                      context)),
                                          child:
                                              EmailVerificationSentComponentWidget(),
                                        ),
                                      );
                                      AppCubit.instance.setIsChangeEmailBtnTapped(false);
                                    },
                                    text: AppCubit.instance.state.isChangeEmailBtnTapped ==
                                            true
                                        ? 'Save Changes'
                                        : 'Change Email',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0, 0.0, 12.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: AppCubit.instance.state.isChangeEmailBtnTapped ==
                                              true
                                          ? FlutterFlowTheme.of(context).success
                                          : FlutterFlowTheme.of(context)
                                              .tertiary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
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
                                ),
                              ),
                              TextFormField(
                                controller: _currentPasswordController,
                                focusNode: _currentPasswordFocus,
                                readOnly: !AppCubit.instance.state.isChangePasswordBtnClicked,
                                obscureText: !editState.currentPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Current Password',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                  hintText: 'Current Password',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  suffixIcon: InkWell(
                                    onTap: context
                                        .read<EditProfileCubit>()
                                        .toggleCurrentPasswordVisibility,
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      editState.currentPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF757575),
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              if (AppCubit.instance.state.isChangePasswordBtnClicked ==
                                  true)
                                TextFormField(
                                  controller: _newPasswordController,
                                  focusNode: _newPasswordFocus,
                                  obscureText:
                                      !editState.newPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                        ),
                                    hintText: 'New Password',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .success,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    filled: true,
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    suffixIcon: InkWell(
                                      onTap: context
                                          .read<EditProfileCubit>()
                                          .toggleNewPasswordVisibility,
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        editState.newPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color(0xFF757575),
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              if (AppCubit.instance.state.isPasswordValidated == false)
                                Text(
                                  'Password must have minimum 8 characters, at least one letter, one number and one special character',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 1.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    // First tap arms (reveal "new password"
                                    // field); second tap submits.
                                    if (!AppCubit.instance.state.isChangePasswordBtnClicked) {
                                      _currentPasswordController.clear();
                                      AppCubit.instance.setIsChangePasswordBtnClicked(true);
                                      return;
                                    }
                                    final newPw = _newPasswordController.text;
                                    if (functions.validatePassword(newPw) !=
                                        true) {
                                      AppCubit.instance.setIsPasswordValidated(false);
                                      return;
                                    }
                                    await context
                                        .read<EditProfileCubit>()
                                        .changePassword(
                                          currentPassword:
                                              _currentPasswordController.text,
                                          newPassword: newPw,
                                          email:
                                              editProfileScreenUsersRecord
                                                  .email,
                                        );
                                    if (!context.mounted) return;
                                    AppCubit.instance.setIsPasswordValidated(true);
                                    AppCubit.instance.setIsChangePasswordBtnClicked(false);
                                    _currentPasswordController.clear();
                                    _newPasswordController.clear();
                                  },
                                  text:
                                      AppCubit.instance.state.isChangePasswordBtnClicked ==
                                              true
                                          ? 'Save Changes'
                                          : 'Change Password',
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: AppCubit.instance.state.isChangePasswordBtnClicked ==
                                            true
                                        ? FlutterFlowTheme.of(context).success
                                        : FlutterFlowTheme.of(context).tertiary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
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
                              ),
                            ]
                                .divide(SizedBox(height: 16.0))
                                .addToStart(SizedBox(height: 16.0)),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
