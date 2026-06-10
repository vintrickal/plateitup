import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/nav/nav.dart';
import 'login_cubit.dart';
import 'login_state.dart';

/// Login screen — Cubit rewrite of the FlutterFlow page.
///
/// State (which provider is in-flight, password visibility, last error)
/// lives in [LoginCubit]; this widget keeps the text controllers and forwards
/// values on button press.
class LoginScreenWidget extends StatelessWidget {
  const LoginScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit()..onPageLoad(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final _email = TextEditingController();
  final _emailFocus = FocusNode();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

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
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.0.ms,
          duration: 400.0.ms,
          begin: const Offset(0.0, 60.0),
          end: const Offset(0.0, 0.0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 200.0.ms,
          duration: 400.0.ms,
          begin: const Offset(-0.349, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void dispose() {
    _unfocusNode.dispose();
    _email.dispose();
    _emailFocus.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (prev, curr) => prev.lastEventId != curr.lastEventId,
      listener: (context, state) {
        if (state.status == LoginStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } else if (state.status == LoginStatus.success) {
          context.goNamed('home');
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: PopScope(
            canPop: false,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              body: SingleChildScrollView(
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
                              controller: _email,
                              focusNode: _emailFocus,
                              label: 'Email',
                              autofillHints: const [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _PasswordField(
                              controller: _password,
                              focusNode: _passwordFocus,
                              label: 'Password',
                              obscure: !state.passwordVisible,
                              onToggle: context
                                  .read<LoginCubit>()
                                  .togglePasswordVisibility,
                            ),
                            _PrimaryButton(
                              text: state.isSubmittingWith(LoginMethod.email)
                                  ? 'Signing in…'
                                  : 'Sign In',
                              enabled: !state.isSubmitting,
                              onPressed: () =>
                                  context.read<LoginCubit>().signInWithEmail(
                                        _email.text,
                                        _password.text,
                                      ),
                            ),
                            _OutlinedButton(
                              text: 'Forgot Password',
                              // See sign-up button below — same pushNamed-
                              // Future-never-resolves issue.
                              onPressed: () {
                                context.pushNamed(
                                  'forgot_password_screen',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: const TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                            ),
                            const _ProviderSection(),
                          ]
                              .divide(const SizedBox(height: 16.0))
                              .toList(),
                        ).animateOnPageLoad(
                            _animationsMap['columnOnPageLoadAnimation']!),
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

/// "Or sign up with" + email-signup nav button + Google sign-in. Apple is
/// commented out in the original — kept hidden here too until you re-enable
/// `sign_in_with_apple` plumbing on the iOS side.
class _ProviderSection extends StatelessWidget {
  const _ProviderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Text(
              'Or sign up with',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Poppins',
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 16.0,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: _ProviderButton(
                        text: 'Sign up with e-mail',
                        icon: const Icon(Icons.mail_outline_rounded, size: 24),
                        enabled: !state.isSubmitting,
                        // Block body (not arrow) so this returns void instead
                        // of the Future<T?> from pushNamed. Otherwise
                        // FFButtonWidget awaits that future — and it never
                        // resolves if the sign-up screen calls `goNamed` to
                        // come back (which replaces the stack instead of
                        // popping). The result was a spinner that stuck on
                        // "Sign up with e-mail" forever once the user
                        // returned to the sign-in page.
                        onPressed: () {
                          context.pushNamed('sign_up_screen');
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: _ProviderButton(
                        text: state.isSubmittingWith(LoginMethod.google)
                            ? 'Signing in…'
                            : 'Continue with Google',
                        icon: const FaIcon(FontAwesomeIcons.google, size: 20),
                        enabled: !state.isSubmitting,
                        onPressed: context.read<LoginCubit>().signInWithGoogle,
                      ),
                    ),
                    // Apple button intentionally hidden — see commented-out
                    // block in the original widget for the visual config.
                  ],
                );
              },
            ),
          ),
        ),
      ].divide(const SizedBox(height: 16.0)).toList(),
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

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.focusNode,
    required this.label,
    this.keyboardType,
    this.autofillHints,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
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
          autofillHints: autofillHints,
          decoration: _decoration(context, label),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Poppins',
                letterSpacing: 0.0,
              ),
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.text,
    required this.enabled,
    required this.onPressed,
  });

  final String text;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: FFButtonWidget(
          onPressed: enabled ? onPressed : null,
          text: text,
          options: FFButtonOptions(
            width: 230.0,
            height: 52.0,
            padding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            color: FlutterFlowTheme.of(context).success,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
            elevation: 3.0,
            borderSide:
                const BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        child: FFButtonWidget(
          onPressed: onPressed,
          text: text,
          options: FFButtonOptions(
            width: 230.0,
            height: 44.0,
            padding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Poppins',
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    required this.text,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final String text;
  final Widget icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      onPressed: enabled ? onPressed : null,
      text: text,
      icon: icon,
      options: FFButtonOptions(
        width: 230.0,
        height: 44.0,
        padding: EdgeInsets.zero,
        iconPadding: EdgeInsets.zero,
        color: FlutterFlowTheme.of(context).secondaryBackground,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Poppins',
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
        elevation: 0.0,
        borderSide:
            BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 2),
        borderRadius: BorderRadius.circular(12.0),
        hoverColor: FlutterFlowTheme.of(context).primaryBackground,
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
