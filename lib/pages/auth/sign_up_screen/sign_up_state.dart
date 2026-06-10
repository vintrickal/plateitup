import 'package:equatable/equatable.dart';

/// Where the sign-up flow currently sits.
///
/// The widget builds the same scaffold for every status; the difference is
/// whether the submit button is enabled / spinning, and which inline error
/// message is visible.
enum SignUpStatus { idle, submitting, success, failure }

class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.idle,
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.isPasswordValid = true,
    this.errorMessage,
    this.lastEventId = 0,
  });

  final SignUpStatus status;

  /// Eye-toggle for the password field — kept in state so the visibility
  /// survives rebuilds from other unrelated state changes.
  final bool passwordVisible;
  final bool confirmPasswordVisible;

  /// Drives the inline "min 8 chars, capital, number, special" hint under
  /// the password field. Defaults to true (hint hidden) — only flips after
  /// the user tries to submit with a weak password.
  final bool isPasswordValid;

  final String? errorMessage;

  /// Bumped every emit so [BlocListener] re-fires for repeated errors.
  final int lastEventId;

  bool get isSubmitting => status == SignUpStatus.submitting;

  SignUpState copyWith({
    SignUpStatus? status,
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    bool? isPasswordValid,
    String? errorMessage,
    bool clearError = false,
    int? lastEventId,
  }) {
    return SignUpState(
      status: status ?? this.status,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        passwordVisible,
        confirmPasswordVisible,
        isPasswordValid,
        errorMessage,
        lastEventId,
      ];
}
