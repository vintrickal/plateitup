import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/backend.dart';
import '/cubits/app/app_cubit.dart';
import '/cubits/auth/auth_cubit.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'sign_up_state.dart';

/// Owns the sign-up form state and the create-account flow.
///
/// Validation rules match the FlutterFlow original — empty display name and
/// the regex-based [functions.validatePassword] both block submission. On
/// success we create the Firestore user document, seed an empty saved-recipe
/// doc, then leave navigation to the widget so it can call `goNamed('home')`
/// (route names live in the widget layer).
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({AuthCubit? authCubit, AppCubit? appCubit})
      : _auth = authCubit ?? AuthCubit.instance,
        _app = appCubit ?? AppCubit.instance,
        super(const SignUpState());

  final AuthCubit _auth;
  final AppCubit _app;

  void togglePasswordVisibility() =>
      emit(state.copyWith(passwordVisible: !state.passwordVisible));

  void toggleConfirmPasswordVisibility() => emit(
      state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));

  /// Returns true if sign-up completed and the caller should navigate to
  /// home; false if validation failed or the auth call errored (state has
  /// already been updated so the widget can react via [BlocListener]).
  Future<bool> submit({
    required String displayName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (displayName.trim().isEmpty) {
      _fail('Display name is empty!');
      return false;
    }

    final passwordOk = functions.validatePassword(password) ?? false;
    if (!passwordOk) {
      emit(state.copyWith(
        status: SignUpStatus.idle,
        isPasswordValid: false,
        lastEventId: state.lastEventId + 1,
      ));
      return false;
    }

    if (password != confirmPassword) {
      _fail("Passwords don't match!");
      return false;
    }

    emit(state.copyWith(
      status: SignUpStatus.submitting,
      isPasswordValid: true,
      clearError: true,
      lastEventId: state.lastEventId + 1,
    ));

    final user = await _auth.createAccountWithEmail(email, password);
    if (user == null) {
      // AuthCubit already emitted an error with a friendly message; mirror
      // that into our own status so the button stops spinning.
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: _auth.state.errorMessage,
        lastEventId: state.lastEventId + 1,
      ));
      return false;
    }

    try {
      final uid = user.uid!;
      final usersRef = UsersRecord.collection.doc(uid);
      // We use .update (not .set) because AuthCubit.createAccountWithEmail
      // -> maybeCreateUser has already written the base document.
      await usersRef.update({
        ...createUsersRecordData(
          email: email,
          displayName: displayName,
          photoUrl:
              'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
          uniqueCode: functions.generateRandomString(),
          coverPhotoUrl:
              'https://media.sproutsocial.com/uploads/1c_facebook-cover-photo_clean@2x.png',
        ),
        ...mapToFirestore({
          'created_time': FieldValue.serverTimestamp(),
        }),
      });

      // Seed an empty saved-recipe collection doc keyed by the user id.
      // Identical to the FlutterFlow original — required by the home page,
      // which reads from saved-recipe on first load.
      final savedRef = SavedRecipeRecord.collection.doc(uid);
      await savedRef.set(createSavedRecipeRecordData(userId: usersRef));
    } catch (e) {
      _fail('Sign-up succeeded but profile setup failed: $e');
      return false;
    }

    // Reset the FlutterFlow-era flags that other (still-unconverted) pages
    // observe. Once those pages move to BlocBuilder<AppCubit>, this becomes
    // dead state we can drop.
    _app
      ..setSignupWasTapped(false)
      ..setIsPasswordValidated(true);

    emit(state.copyWith(
      status: SignUpStatus.success,
      lastEventId: state.lastEventId + 1,
    ));
    return true;
  }

  void _fail(String message) {
    emit(state.copyWith(
      status: SignUpStatus.failure,
      errorMessage: message,
      lastEventId: state.lastEventId + 1,
    ));
  }
}
