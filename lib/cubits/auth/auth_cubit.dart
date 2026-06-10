// MVP mode: AuthCubit no longer talks to Firebase Auth. It just starts in
// the `authenticated` state with the demo user, and every sign-in / sign-out
// method is a no-op that either re-emits the same authenticated state or
// briefly emits `unauthenticated` (sign-out) so the UI can navigate.

import 'dart:async';

import 'package:bloc/bloc.dart';

import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/firebase_user_provider.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState()) {
    // Seed authenticated state synchronously so first BlocBuilder read sees
    // a logged-in user, never `unknown`.
    final user = PlateitupFirebaseUser();
    currentUser = user;
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      lastEventId: state.lastEventId + 1,
    ));
  }

  static final AuthCubit instance = AuthCubit();

  Future<BaseAuthUser?> signInWithEmail(String email, String password) =>
      _fakeSignIn();

  Future<BaseAuthUser?> createAccountWithEmail(
          String email, String password) =>
      _fakeSignIn();

  Future<BaseAuthUser?> signInWithGoogle() => _fakeSignIn();
  Future<BaseAuthUser?> signInWithApple() => _fakeSignIn();
  Future<BaseAuthUser?> signInWithGithub() => _fakeSignIn();
  Future<BaseAuthUser?> signInAnonymously() => _fakeSignIn();
  Future<BaseAuthUser?> signInWithJwtToken(String token) => _fakeSignIn();

  Future<void> signOut() async {
    // Briefly unauthenticated so the sign-out caller's navigation succeeds.
    // The demo user is restored on the next sign-in tap.
    currentUser = null;
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      lastEventId: state.lastEventId + 1,
    ));
  }

  Future<void> sendEmailVerification() async {/* no-op */}
  Future<void> refreshCurrentUser() async {/* no-op */}

  Future<String?> sendPasswordReset(String email) async => null;

  Future<void> deleteAccount() async {
    currentUser = null;
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      lastEventId: state.lastEventId + 1,
    ));
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(
        clearError: true,
        lastEventId: state.lastEventId + 1,
      ));
    }
  }

  Future<BaseAuthUser?> _fakeSignIn() async {
    emit(state.copyWith(
      status: AuthStatus.loading,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));
    // Tiny artificial delay so the spinner actually appears.
    await Future.delayed(const Duration(milliseconds: 200));
    final user = PlateitupFirebaseUser();
    currentUser = user;
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));
    return user;
  }
}
