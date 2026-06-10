import 'package:equatable/equatable.dart';

/// State for the edit-profile screen.
///
/// Most fields are toggles/flags that drive what the UI shows; the actual
/// text values live in the widget's [TextEditingController]s and are read
/// at submit-time.
class EditProfileState extends Equatable {
  const EditProfileState({
    this.currentPasswordVisible = false,
    this.newPasswordVisible = false,
    this.changePasswordMessage,
    this.isSubmitting = false,
    this.lastEventId = 0,
  });

  final bool currentPasswordVisible;
  final bool newPasswordVisible;

  /// Result from [AuthCubit]'s `changePassword` flow (or null if untouched).
  /// Surfaced via a `SnackBar` in the widget's `BlocListener`.
  final String? changePasswordMessage;

  /// True while either the change-password or change-email request is in
  /// flight. The save buttons disable themselves on this.
  final bool isSubmitting;

  /// Bumped on each emit so the `SnackBar` listener fires for repeat
  /// messages.
  final int lastEventId;

  EditProfileState copyWith({
    bool? currentPasswordVisible,
    bool? newPasswordVisible,
    String? changePasswordMessage,
    bool clearMessage = false,
    bool? isSubmitting,
    int? lastEventId,
  }) {
    return EditProfileState(
      currentPasswordVisible:
          currentPasswordVisible ?? this.currentPasswordVisible,
      newPasswordVisible: newPasswordVisible ?? this.newPasswordVisible,
      changePasswordMessage: clearMessage
          ? null
          : (changePasswordMessage ?? this.changePasswordMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastEventId: lastEventId ?? this.lastEventId,
    );
  }

  @override
  List<Object?> get props => [
        currentPasswordVisible,
        newPasswordVisible,
        changePasswordMessage,
        isSubmitting,
        lastEventId,
      ];
}
