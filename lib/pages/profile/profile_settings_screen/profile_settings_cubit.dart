import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '/backend/backend.dart';
import 'profile_settings_state.dart';

/// Drives [ProfileSettingsScreenWidget].
///
/// Single piece of logic: when the user taps the delete-account row we need
/// to check whether they're still in a paired-user relationship (either as
/// the recipient or the sender). If so, show a "must unpair first" alert;
/// if not, send them to the deletion survey.
class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  ProfileSettingsCubit() : super(const ProfileSettingsState());

  /// Run the guard for the user identified by [userRef] (the user record
  /// the screen is currently viewing — typically `currentUserReference`).
  Future<void> checkDeleteAccount(DocumentReference userRef) async {
    emit(state.copyWith(
      deleteGuard: DeleteGuard.checking,
      lastEventId: state.lastEventId + 1,
    ));

    final asReceiver = await queryPairedUserRecordOnce(
      queryBuilder: (q) => q.where('recipient', isEqualTo: userRef),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    if (asReceiver != null) {
      emit(state.copyWith(
        deleteGuard: DeleteGuard.pairedAsReceiver,
        lastEventId: state.lastEventId + 1,
      ));
      return;
    }

    final asSender = await queryPairedUserRecordOnce(
      queryBuilder: (q) => q.where('sender', isEqualTo: userRef),
      singleRecord: true,
    ).then((s) => s.firstOrNull);

    emit(state.copyWith(
      deleteGuard: asSender != null
          ? DeleteGuard.pairedAsSender
          : DeleteGuard.clear,
      lastEventId: state.lastEventId + 1,
    ));
  }

  /// Reset the guard so a follow-up tap re-runs the check.
  void resetDeleteGuard() {
    emit(state.copyWith(
      deleteGuard: DeleteGuard.idle,
      lastEventId: state.lastEventId + 1,
    ));
  }
}
