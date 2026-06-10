import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'sign_up_cubit.dart';
import 'sign_up_state.dart';

/// Sign-up screen — Cubit rewrite of the FlutterFlow page.
///
/// Cubit owns the flow state ([SignUpState]); this widget keeps the
/// `TextEditingController`s and `FocusNode`s (Flutter's text-field machinery
/// doesn't compose with immutable state) and forwards values to [SignUpCubit]
/// only at submit-time.
class SignUpScreenWidget extends StatelessWidget {
  const SignUpScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _displayName = TextEditingController();
  final _displayNameFocus = FocusNode();
  final _email = TextEditingController();
  final _emailFocus = FocusNode();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmPassword = TextEditingController();
  final _confirmPasswordFocus = FocusNode();

  final _animationsMap = <String, AnimationInfo>{
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.0.ms,
          duration: 400.0.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void dispose() {
    _unfocusNode.dispose();
    _displayName.dispose();
    _displayNameFocus.dispose();
    _email.dispose();
    _emailFocus.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    _confirmPassword.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listenWhen: (prev, curr) => prev.lastEventId != curr.lastEventId,
      listener: (context, state) {
        if (state.status == SignUpStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              duration: const Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).secondary,
            ),
          );
        } else if (state.status == SignUpStatus.success) {
          // Navigate to home. We don't use goNamedAuth here because the
          // AuthCubit has already flipped to authenticated *before* this
          // listener fires (we await the credential before emitting
          // success), so the simple goNamed is safe.
          context.goNamed('home');
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: SafeArea(
              top: true,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _Header(),
                      Align(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FormField(
                                controller: _displayName,
                                focusNode: _displayNameFocus,
                                label: 'Display Name',
                                autofocus: true,
                                maxLength: 20,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              _FormField(
                                controller: _email,
                                focusNode: _emailFocus,
                                label: 'Email',
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                              ),
                              _PasswordField(
                                controller: _password,
                                focusNode: _passwordFocus,
                                label: 'Password',
                                obscure: !state.passwordVisible,
                                onToggle: context
                                    .read<SignUpCubit>()
                                    .togglePasswordVisibility,
                              ),
                              _PasswordField(
                                controller: _confirmPassword,
                                focusNode: _confirmPasswordFocus,
                                label: 'Confirm Password',
                                obscure: !state.confirmPasswordVisible,
                                onToggle: context
                                    .read<SignUpCubit>()
                                    .toggleConfirmPasswordVisibility,
                              ),
                              if (!state.isPasswordValid)
                                Text(
                                  'Password must have minimum 8 characters, at least one capital letter, one number and one special character',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .error,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              Align(
                                alignment: const AlignmentDirectional(1.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: FFButtonWidget(
                                    onPressed: () =>
                                        context.goNamed('login_screen'),
                                    text: 'I have an account. Sign in',
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsets.zero,
                                      iconPadding: EdgeInsets.zero,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: FFButtonWidget(
                                    onPressed: state.isSubmitting
                                        ? null
                                        : () => context
                                            .read<SignUpCubit>()
                                            .submit(
                                              displayName: _displayName.text,
                                              email: _email.text,
                                              password: _password.text,
                                              confirmPassword:
                                                  _confirmPassword.text,
                                            ),
                                    text: state.isSubmitting
                                        ? 'Creating account…'
                                        : 'Create Account',
                                    options: FFButtonOptions(
                                      width: 230.0,
                                      height: 52.0,
                                      padding: EdgeInsets.zero,
                                      iconPadding: EdgeInsets.zero,
                                      color: FlutterFlowTheme.of(context)
                                          .success,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 3.0,
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ).animateOnPageLoad(
                              _animationsMap['columnOnPageLoadAnimation']!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.network(
            'https://res.cloudinary.com/hz3gmuqw6/image/upload/c_fill,q_auto,w_750/f_auto/plating-food-phpsUAQLM',
          ).image,
        ),
      ),
      child: SizedBox(
        width: 100.0,
        height: 138.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x00FFFFFF),
                FlutterFlowTheme.of(context).secondaryBackground,
              ],
              stops: const [0.0, 1.0],
              begin: const AlignmentDirectional(0.0, -1.0),
              end: const AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    0.0, 150.0, 0.0, 0.0),
                child: Text(
                  'Plate it Up!',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Roboto',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  'Access your wonderful recipes by logging in below.',
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Plain (non-password) text field with the FlutterFlow-themed decoration.
/// Extracted so the build() above stays readable.
class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.focusNode,
    required this.label,
    this.autofocus = false,
    this.maxLength,
    this.keyboardType,
    this.autofillHints,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final bool autofocus;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          autofillHints: autofillHints,
          decoration: _decoration(context, label),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                letterSpacing: 0.0,
              ),
          maxLength: maxLength,
          maxLengthEnforcement:
              maxLength != null ? MaxLengthEnforcement.enforced : null,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final decoration = _decoration(context, label).copyWith(
      suffixIcon: InkWell(
        onTap: onToggle,
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 24.0,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofillHints: const [AutofillHints.password],
          obscureText: obscure,
          decoration: decoration,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }
}

InputDecoration _decoration(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
    contentPadding: const EdgeInsets.all(24.0),
  );
}
