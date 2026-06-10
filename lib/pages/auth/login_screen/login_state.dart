import 'package:equatable/equatable.dart';

/// Tracks which login button (if any) is currently in-flight.
///
/// Keeping the provider in state lets the widget spin only the button the
/// user actually pressed (the FlutterFlow original spun nothing — it just
/// blocked the whole screen).
enum LoginMethod { none, email, google, apple }

enum LoginStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.method = LoginMethod.none,
    this.passwordVisible = false,
    this.errorMessage,
    this.lastEventId = 0,
  });

  final LoginStatus status;
  final LoginMethod method;
  final bool passwordVisible;
  final String? errorMessage;

  /// Bumped on each emission so [BlocListener] re-runs even when the same
  /// error fires twice.
  final int lastEventId;

  bool get isSubmitting => status == LoginStatus.submitting;

  bool isSubmittingWith(LoginMethod m) =>
      status == LoginStatus.submitting && method == m;

  LoginState copyWith({
    LoginStatus? status,
    LoginMethod? method,
    bool? passwordVisible,
    String? errorMessage,
    bool clearError = false,
    int? lastEventId,
  }) {
    return LoginState(
      status: status ?? this.status,
      method: method ?? this.method,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props =>
      [status, method, passwordVisible, errorMessage, lastEventId];
}
