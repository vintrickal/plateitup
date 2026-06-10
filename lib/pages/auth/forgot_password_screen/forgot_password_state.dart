import 'package:equatable/equatable.dart';

/// Phase of the forgot-password flow.
///
/// The screen renders three different bodies based on this:
///   * [idle] / [searching]            → the email-entry form
///   * [notFound]                      → the form + a "no such user" hint
///   * [found] / [sending] / [sent]    → the confirmation + Send Link button
///   * [error]                         → form, with a SnackBar driven by
///                                       `BlocListener` on [errorMessage].
enum ForgotPasswordStatus {
  idle,
  searching,
  notFound,
  found,
  sending,
  sent,
  error,
}

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.email = '',
    this.errorMessage,
    this.lastEventId = 0,
  });

  final ForgotPasswordStatus status;

  /// The email the user last searched for. Held in state so the "found an
  /// account associated with X" line below the form survives a rebuild
  /// without re-reading the controller.
  final String email;

  final String? errorMessage;

  /// Bumped on every emission so [BlocListener] re-fires for back-to-back
  /// errors with the same message.
  final int lastEventId;

  bool get isBusy =>
      status == ForgotPasswordStatus.searching ||
      status == ForgotPasswordStatus.sending;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? email,
    String? errorMessage,
    bool clearError = false,
    int? lastEventId,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [status, email, errorMessage, lastEventId];
}
