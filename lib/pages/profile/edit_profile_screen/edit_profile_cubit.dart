import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/backend.dart';
import '/custom_code/actions/index.dart' as actions;
import 'edit_profile_state.dart';

/// Drives [EditProfileScreenWidget].
///
/// Owns:
///   * the password-field visibility toggles (separate from the text
///     content, which stays in `TextEditingController`s),
///   * the change-password call (delegates to the existing custom action),
///   * the change-email call (Firebase + Firestore mirror).
///
/// Heavy lifting still lives in the original custom_code action so the
/// behaviour is byte-identical to FlutterFlow; we just stop using setState
/// to flip flags.
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileState());

  void toggleCurrentPasswordVisibility() => emit(state.copyWith(
        currentPasswordVisible: !state.currentPasswordVisible,
      ));

  void toggleNewPasswordVisibility() => emit(state.copyWith(
        newPasswordVisible: !state.newPasswordVisible,
      ));

  /// Calls [actions.changePassword] and surfaces its return string through
  /// state for the widget's `BlocListener` to SnackBar.
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String? email,
  }) async {
    emit(state.copyWith(
      isSubmitting: true,
      clearMessage: true,
      lastEventId: state.lastEventId + 1,
    ));
    final result = await actions.changePassword(
      currentPassword,
      newPassword,
      email ?? '',
    );
    emit(state.copyWith(
      isSubmitting: false,
      changePasswordMessage: result,
      lastEventId: state.lastEventId + 1,
    ));
    return result;
  }

  /// MVP mode: write the new email to the in-memory Firestore mirror only.
  /// The "verification" step is gone — nothing to verify against. Returns
  /// null on success.
  Future<String?> updateEmail({
    required String newEmail,
    required DocumentReference userDocRef,
  }) async {
    emit(state.copyWith(
      isSubmitting: true,
      lastEventId: state.lastEventId + 1,
    ));
    try {
      await userDocRef.update(createUsersRecordData(email: newEmail));
      emit(state.copyWith(
        isSubmitting: false,
        lastEventId: state.lastEventId + 1,
      ));
      return null;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        lastEventId: state.lastEventId + 1,
      ));
      return 'Email update failed: $e';
    }
  }
}
