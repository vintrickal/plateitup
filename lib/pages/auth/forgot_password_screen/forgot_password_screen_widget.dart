import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_state.dart';

/// Forgot-password screen — Cubit-driven rewrite of the FlutterFlow widget.
///
/// All flow state lives in [ForgotPasswordCubit]; this widget is now a pure
/// view that reads [ForgotPasswordState] and forwards button presses.
class ForgotPasswordScreenWidget extends StatelessWidget {
  const ForgotPasswordScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return PopScope(
      canPop: false,
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        // Errors and the "sent" milestone are one-shot; route them through
        // listenWhen so we don't fire the dialog twice on every rebuild.
        listenWhen: (prev, curr) => prev.lastEventId != curr.lastEventId,
        listener: (context, state) async {
          if (state.status == ForgotPasswordStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                duration: const Duration(milliseconds: 4000),
                backgroundColor: FlutterFlowTheme.of(context).secondary,
              ),
            );
          } else if (state.status == ForgotPasswordStatus.sent) {
            await showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Sent!'),
                content: const Text('The link has been sent to your email.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Ok'),
                  ),
                ],
              ),
            );
            if (!context.mounted) return;
            cubit.reset();
            context.goNamed('login_screen');
          }
        },
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).success,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  size: 24.0,
                ),
                onPressed: () {
                  cubit.reset();
                  context.pop();
                },
              ),
              title: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                child: Text(
                  'Forgot Password',
                  style: FlutterFlowTheme.of(context).displaySmall.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              actions: const [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Align(
              alignment: const AlignmentDirectional(0.0, -1.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 570.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 0.0, 16.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We will send you an email with a link to reset your password, please enter the email associated with your account below.',
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                            ),
                      ),
                      if (state.status != ForgotPasswordStatus.found)
                        _SearchPanel(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          state: state,
                          onSearch: () =>
                              cubit.searchEmail(_emailController.text),
                        ),
                      if (state.status == ForgotPasswordStatus.found ||
                          state.status == ForgotPasswordStatus.sending)
                        _ConfirmPanel(
                          email: state.email,
                          busy: state.status ==
                              ForgotPasswordStatus.sending,
                          onSend: cubit.sendResetLink,
                        ),
                    ]
                        .divide(const SizedBox(height: 16.0))
                        .addToStart(const SizedBox(height: 16.0)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.onSearch,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ForgotPasswordState state;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.status == ForgotPasswordStatus.notFound)
          Text(
            'Sorry, we were unable to find an email adddress that matched your search.',
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Poppins',
                  letterSpacing: 0.0,
                ),
          ),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofillHints: const [AutofillHints.email],
            obscureText: false,
            decoration: InputDecoration(
              labelText: 'Your email address...',
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 0.0,
                  ),
              hintText: 'Enter your email...',
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 0.0,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).success,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(
                  24.0, 24.0, 20.0, 24.0),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Poppins',
                  letterSpacing: 0.0,
                ),
            maxLines: null,
            keyboardType: TextInputType.emailAddress,
            cursorColor: FlutterFlowTheme.of(context).primary,
          ),
        ),
        Align(
          child: FFButtonWidget(
            onPressed:
                state.status == ForgotPasswordStatus.searching ? null : onSearch,
            text: state.status == ForgotPasswordStatus.searching
                ? 'Searching…'
                : 'Search',
            options: FFButtonOptions(
              width: 270.0,
              height: 50.0,
              padding: EdgeInsets.zero,
              iconPadding: EdgeInsets.zero,
              color: FlutterFlowTheme.of(context).success,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 0.0,
                  ),
              elevation: 3.0,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
      ].divide(const SizedBox(height: 24.0)),
    );
  }
}

class _ConfirmPanel extends StatelessWidget {
  const _ConfirmPanel({
    required this.email,
    required this.busy,
    required this.onSend,
  });

  final String email;
  final bool busy;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 16.0, 16.0, 8.0),
                child: Text(
                  'We found an account associated with',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 0.0, 16.0, 8.0),
                child: Text(
                  email,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
          Align(
            child: FFButtonWidget(
              onPressed: busy ? null : onSend,
              text: busy ? 'Sending…' : 'Send Link',
              options: FFButtonOptions(
                width: 270.0,
                height: 50.0,
                padding: EdgeInsets.zero,
                iconPadding: EdgeInsets.zero,
                color: FlutterFlowTheme.of(context).success,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Poppins',
                      letterSpacing: 0.0,
                    ),
                elevation: 3.0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ].divide(const SizedBox(height: 16.0)),
      ),
    );
  }
}
