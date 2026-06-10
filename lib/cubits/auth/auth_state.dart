import 'package:equatable/equatable.dart';

import '/auth/base_auth_user_provider.dart';

/// Where the user is in the auth flow.
///
/// [unknown] is the initial state before the first auth-state event arrives;
/// the splash UI should stay up while we're here.
enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

/// Snapshot of the auth subsystem consumed by widgets via
/// `BlocBuilder<AuthCubit, AuthState>`.
///
/// [errorMessage] is non-null only when [status] is [AuthStatus.error]; it's
/// the user-facing string a `BlocListener` should surface as a SnackBar.
/// [lastEventId] increments on every emission, so listeners can show the
/// same error twice in a row without Equatable dropping the second event.
class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.lastEventId = 0,
  });

  final AuthStatus status;
  final BaseAuthUser? user;
  final String? errorMessage;
  final int lastEventId;

  bool get isLoggedIn =>
      status == AuthStatus.authenticated && (user?.loggedIn ?? false);

  AuthState copyWith({
    AuthStatus? status,
    BaseAuthUser? user,
    String? errorMessage,
    bool clearError = false,
    int? lastEventId,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [status, user?.uid, errorMessage, lastEventId];
}
