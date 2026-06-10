import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '/backend/backend.dart';
import '/cubits/auth/auth_cubit.dart';
import 'forgot_password_state.dart';

/// Drives the forgot-password screen.
///
/// Two-step flow that mirrors the original FlutterFlow behaviour:
///   1. [searchEmail] — Firestore lookup to confirm an account exists for
///      that address. We do this before calling Firebase reset because
///      `sendPasswordResetEmail` silently succeeds for unknown emails (to
///      avoid leaking user existence), but the original UX wanted a "no
///      such email" message.
///   2. [sendResetLink] — fire the Firebase reset email and move to
///      [ForgotPasswordStatus.sent], which the widget reacts to by showing
///      a dialog and navigating back to login.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({AuthCubit? authCubit})
      : _auth = authCubit ?? AuthCubit.instance,
        super(const ForgotPasswordState());

  final AuthCubit _auth;

  Future<void> searchEmail(String rawEmail) async {
    final email = rawEmail.trim();
    if (email.isEmpty) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: 'Nothing to search here!',
        lastEventId: state.lastEventId + 1,
      ));
      return;
    }

    emit(state.copyWith(
      status: ForgotPasswordStatus.searching,
      email: email,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));

    try {
      final match = await queryUsersRecordOnce(
        queryBuilder: (q) => q.where('email', isEqualTo: email),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      emit(state.copyWith(
        status: match == null
            ? ForgotPasswordStatus.notFound
            : ForgotPasswordStatus.found,
        lastEventId: state.lastEventId + 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: 'Search failed: $e',
        lastEventId: state.lastEventId + 1,
      ));
    }
  }

  Future<void> sendResetLink() async {
    if (state.email.isEmpty) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: 'Email required!',
        lastEventId: state.lastEventId + 1,
      ));
      return;
    }
    emit(state.copyWith(
      status: ForgotPasswordStatus.sending,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));
    final err = await _auth.sendPasswordReset(state.email);
    if (err != null) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: err,
        lastEventId: state.lastEventId + 1,
      ));
      return;
    }
    emit(state.copyWith(
      status: ForgotPasswordStatus.sent,
      lastEventId: state.lastEventId + 1,
    ));
  }

  /// Reset back to the email-entry form (used by the back button and after
  /// a successful send so the screen is clean if the user re-enters it).
  void reset() {
    emit(const ForgotPasswordState());
  }
}
