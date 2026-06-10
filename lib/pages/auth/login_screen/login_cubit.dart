import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/auth/auth_cubit.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'login_state.dart';

/// Drives the login screen. Handles email/password, Google, and (when
/// re-enabled) Apple sign-in. Shared helper [_afterSignIn] does the
/// post-auth side effects every provider needs:
///   1. Look up whether this user already has a paired-user record and
///      mirror that into the global app state ([AppCubit]).
///   2. Reset the sign-up screen's flags so a stale failed sign-up doesn't
///      bleed into the next visit.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({AuthCubit? authCubit, AppCubit? appCubit})
      : _auth = authCubit ?? AuthCubit.instance,
        _app = appCubit ?? AppCubit.instance,
        super(const LoginState());

  final AuthCubit _auth;
  final AppCubit _app;

  void togglePasswordVisibility() =>
      emit(state.copyWith(passwordVisible: !state.passwordVisible));

  /// Resets the sign-up tap flag — preserves the FlutterFlow on-page-load
  /// behaviour so the sign-up screen starts clean if the user goes there
  /// straight from a fresh login screen.
  void onPageLoad() => _app.setSignupWasTapped(false);

  Future<bool> signInWithEmail(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _fail('Email and password are required.');
      return false;
    }
    return _run(LoginMethod.email,
        () => _auth.signInWithEmail(email.trim(), password));
  }

  Future<bool> signInWithGoogle() => _run(
        LoginMethod.google,
        () async {
          final user = await _auth.signInWithGoogle();
          if (user == null) return null;
          // Google users get a freshly minted profile doc on first sign-in
          // because [maybeCreateUser] runs inside AuthCubit. The FlutterFlow
          // original then *overwrote* a handful of fields — keep doing that
          // so existing accounts aren't affected.
          final ref = currentUserReference;
          if (ref != null) {
            await ref.update(createUsersRecordData(
              uniqueCode: functions.generateRandomString(),
              coverPhotoUrl:
                  'https://media.sproutsocial.com/uploads/1c_facebook-cover-photo_clean@2x.png',
              uid: ref.id,
              displayName: functions.limitCharacterFunc(currentUserDisplayName),
            ));
            await SavedRecipeRecord.collection
                .doc(ref.id)
                .set(createSavedRecipeRecordData(userId: ref));
          }
          return user;
        },
      );

  Future<bool> signInWithApple() =>
      _run(LoginMethod.apple, _auth.signInWithApple);

  // ---------------------------------------------------------------------------

  /// Wraps a sign-in attempt: flips the spinner on, runs the auth call,
  /// runs post-auth side effects, and emits success/failure.
  Future<bool> _run(
      LoginMethod method, Future<dynamic> Function() signInFn) async {
    emit(state.copyWith(
      status: LoginStatus.submitting,
      method: method,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));

    try {
      final user = await signInFn();
      if (user == null) {
        // User cancelled the provider sheet or AuthCubit emitted an error;
        // mirror its message into our state if we have one.
        emit(state.copyWith(
          status: LoginStatus.failure,
          method: LoginMethod.none,
          errorMessage: _auth.state.errorMessage,
          lastEventId: state.lastEventId + 1,
        ));
        return false;
      }
      await _afterSignIn();
      emit(state.copyWith(
        status: LoginStatus.success,
        method: LoginMethod.none,
        lastEventId: state.lastEventId + 1,
      ));
      return true;
    } catch (e) {
      _fail('Sign in failed: $e');
      return false;
    }
  }

  Future<void> _afterSignIn() async {
    _app.setIsShowFullList(true);

    final paired = await queryPairedUserRecordOnce(
      queryBuilder: (q) => q.where('recipient', isEqualTo: currentUserReference),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    _app
      ..setHasPartner(paired != null)
      ..setPairedUserCollection(paired?.reference)
      ..setSignupWasTapped(false)
      ..setIsPasswordValidated(true);
  }

  void _fail(String message) {
    emit(state.copyWith(
      status: LoginStatus.failure,
      method: LoginMethod.none,
      errorMessage: message,
      lastEventId: state.lastEventId + 1,
    ));
  }
}
