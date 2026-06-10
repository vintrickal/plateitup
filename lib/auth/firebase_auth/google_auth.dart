// MVP mode: Google sign-in stubbed out. Returns a sentinel so AuthCubit's
// success path runs. google_sign_in plugin removed from pubspec.

Future<Object?> googleSignInFunc() async => const Object();

Future<void> signOutWithGoogle() async {/* no-op */}
