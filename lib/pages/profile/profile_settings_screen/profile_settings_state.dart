import 'package:equatable/equatable.dart';

/// State for the profile-settings screen.
///
/// The screen is mostly a static list of nav rows over a `StreamBuilder<UsersRecord>`,
/// so the only state we hold is the delete-account guard outcome:
///   * [DeleteGuard.idle]            — user hasn't tapped delete yet
///   * [DeleteGuard.checking]        — running the paired-user lookup
///   * [DeleteGuard.pairedAsReceiver] / [pairedAsSender] — show the
///     "you're still paired, unpair first" alert
///   * [DeleteGuard.clear]           — go to the deletion-survey screen
enum DeleteGuard {
  idle,
  checking,
  pairedAsReceiver,
  pairedAsSender,
  clear,
}

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    this.deleteGuard = DeleteGuard.idle,
    this.lastEventId = 0,
  });

  final DeleteGuard deleteGuard;

  /// Monotonic counter so [BlocListener] re-fires the navigation/dialog
  /// even when the user runs the same guard twice in a row.
  final int lastEventId;

  ProfileSettingsState copyWith({
    DeleteGuard? deleteGuard,
    int? lastEventId,
  }) {
    return ProfileSettingsState(
      deleteGuard: deleteGuard ?? this.deleteGuard,
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [deleteGuard, lastEventId];
}
