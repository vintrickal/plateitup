import 'package:equatable/equatable.dart';

/// State for [ProfileScreenWidget].
///
/// The screen is mostly a passive renderer over a `StreamBuilder<UsersRecord>`
/// and `TabBar`s; the only state we need to track is whether the page-load
/// paired-user check has finished, so we don't animate the tab controller
/// to the initial index before the controller exists.
class ProfileScreenState extends Equatable {
  const ProfileScreenState({
    this.didCompletePageLoad = false,
    this.lastEventId = 0,
  });

  final bool didCompletePageLoad;
  final int lastEventId;

  ProfileScreenState copyWith({
    bool? didCompletePageLoad,
    int? lastEventId,
  }) {
    return ProfileScreenState(
      didCompletePageLoad:
          didCompletePageLoad ?? this.didCompletePageLoad,
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [didCompletePageLoad, lastEventId];
}
