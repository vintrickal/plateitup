// MVP mode: Apple sign-in stubbed. sign_in_with_apple plugin removed from
// pubspec — the function still exists so AuthCubit compiles, but it just
// returns a sentinel and the upstream success path runs.

Future<Object?> appleSignIn() async => const Object();
